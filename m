Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbYACDuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbYACDuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 22:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbYACDun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 22:50:43 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:46492 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752904AbYACDum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 22:50:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Javfm89VsHurDzNIBndxm3gSBL4eC+KbfB4TOo2sWyrSfdorHgDgO6HFwSY6dZ05F6Zb6+T1nONWUgzq6EW+NMgjcsf+RYpUuyLo8K5IcRJMXJOtODSDmI1MOBS4rsWNchmF1VbQKvwiu2M38cQ8GPt5193Qq/Skwal4ryNHQRc=  ;
X-YMail-OSG: c9iggvIVM1l9K5kEEiL8BdNp4ez4uijxeSq0NmE9JMfPlpsnu9hqtMmT4qQSl24.vrzFN71BQw--
From: David Brownell <david-b@pacbell.net>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB options normally reserved for OTG
Date: Wed, 2 Jan 2008 19:43:38 -0800
User-Agent: KMail/1.9.6
Cc: linux-usb-devel@lists.sourceforge.net, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <200801020948.51310.rgetz@blackfin.uclinux.org> <200801021047.16036.david-b@pacbell.net> <200801022203.04991.rgetz@blackfin.uclinux.org>
In-Reply-To: <200801022203.04991.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801021943.38716.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 January 2008, Robin Getz wrote:
> On Wed 2 Jan 2008 13:47, David Brownell pondered:
> > On Wednesday 02 January 2008, Robin Getz wrote:
> > > From: Robin Getz <rgetz@blackfin.uclinux.org>
> > > 
> > > Allow embedded developers to turn support for USB Hubs off even if
> > > they have a full root hub. This saves the overhead (RAM and Flash size).
> > 
> > ISTR that it won't save very much code though ... the Linux USB
> > stack structures all its enumeration logic around hubs.
> 
> Today, there is an USB (Host), USB_GADGET and USB_OTG (which depends on USB && 
> USB_GADGET).
> 
> This just enables cutting more code out, with out having to have USB_GADGET & 
> USB_OTG enabled. When I checked - that is where most of the savings came 
> from.

Right.  I'm not objecting to this at all.  Just pointing
out that usbcore will still end up including quite a lot
of hub functionality, because there's still going to be
a root hub in the system and a khubd managing it.

This patch might be improved slightly -- in ways that, as I
understand things, could save some RAM on Blackfin! -- by
having the BLACKLIST_HUB option get rid of the transaction
translator support (changing C code not just Kconfig).
It's pretty minimal, but won't be used...

Also, as you point out, it's no longer OTG specific, so
renaming the option would improve clarity.   Maybe to
something along the lines of USB_HOST_NO_EXTERNAL_HUBS.
No big deal, at least now.

- Dave

