Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbXHNIB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbXHNIB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 04:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbXHNIBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 04:01:18 -0400
Received: from smtp107.sbc.mail.re2.yahoo.com ([68.142.229.98]:39206 "HELO
	smtp107.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754064AbXHNIBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 04:01:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZnVKTxFBLJstpxLSVKIVWwaZrYZmoDSujV/XfgP94H450IJ98ULs+L9WLxKP0m/W/3lvZ9GhrQ9AA85FYjydNUXCrrq25lJzvLrYQg3FuvNRYc3qfa2FX2tjh4uXQGGlSD59AZv1bVH37TI/VJ1CMDdX7Gb40X4FhA3w4PmUq8g=  ;
X-YMail-OSG: ieP.lQoVM1nE1LTxgKpNHcB2jXq4zazz._qw0LW404SkgUkUvwxLZ0glJDT72uzzrRme1cRF0Q--
From: David Brownell <david-b@pacbell.net>
To: webmaster@dragonslave.de
Subject: Re: EHCI Regression in 2.6.23-rc2
Date: Tue, 14 Aug 2007 01:01:19 -0700
User-Agent: KMail/1.9.6
Cc: Stuart_Hayes@dell.com, greg@kroah.com, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, jikos@jikos.cz
References: <200708101045.57166.dex@dragonslave.de> <200708131516.18675.david-b@pacbell.net> <200708140843.42196.webmaster@dragonslave.de>
In-Reply-To: <200708140843.42196.webmaster@dragonslave.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200708140101.19651.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 August 2007, Daniel Exner wrote:
> David Brownell wrote:
> > On Monday 13 August 2007, Stuart_Hayes@dell.com wrote:
> > > With the VIA controller I have,
> >
> > Which kind is that?  The VT6202 is buggy as all get-out, and
> > they sold a *LOT* of those discrete chips for use in add-on PCI
> > cards.  We generally warn people away from those.  A more current
> > version is the VT6212, which was much more usable.  (If it says
> > EHCI 0.95, it's a VT6202... their EHCI 1.0 chips were much better.)
>
> Where exactly should I search for this? Neither lspci nor lsusb showed any 
> hint on the EHCI rev. the chip conforms to..

The driver logs that information as it starts; on this sytem:

 ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004

vs "EHCI 0.95".

 
> [..]
> > > Perhaps for now the best thing would just be to bypass the EHCI CPU
> > > frequency notifier code (i.e., my patch) for VIA EHCI controllers, since
> > > they are broken.  Would a hard-coded blacklist (just an "if
> > > (manufacturer==VIA)..." type thing) be OK?
> >
> > Yes ... although if you don't need to blacklist their EHCI 1.0 chips
> > don't do it.  (Any VIA EHCI integrated into a southbridge is going
> > to follow spec rev 1.0 pretty well, modulo idiosyncratic timings.)
>  
> I guess its needed to blacklist even the ECHI 1.0 chips, since my problem is
> with exactly one of those ;)

Something doesn't add up then ... above you ask where to find that info,
but here you say you already got it from somwhere ... ?


> I'm not really into USB protocol specs, but perhaps its possible to test 
> wether the problem Stuarts patch addressed can actually happen on VIA EHCI 
> chips? Perhaps those guys solved the problem in Hard/Firmware..

Theoretically possible, and I've certainly seen hardware made to do
stranger things than that.


> > > I've also acquired a card with an NEC EHCI controller on it, which I'm
> > > going to look at while I'm into it...
> >
> > Another case where there are a lot of add-on "EHCI 0.95" cards; but
> > in this case the quirks were less significant.
>
> Some guy donated me a PCMCIA card with one of those, cause it'll wont work in 
> his Windows only Notebook :)

A NEC 0.95 ??  Should be fine with Linux.  Assuming no bugs have
crept in.

- Dave



