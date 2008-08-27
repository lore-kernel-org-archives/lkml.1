Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYH0SjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYH0SjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 14:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYH0Si7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 14:38:59 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:39468 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752554AbYH0Si6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 14:38:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=F2xut11xAVOWuuLWqe8/6tpHT1TfO7F5ilm73keJuF9na5deFWNkcylV4v1iYNvnVDE8aQj1A2fFm1nVv0qhduL0p2hxJZC+Iand1vE0fYaFsQjwtd4pu0r1sVkmUUy/OGsTdFQVgpDFrWxIWdrUdgL59CCNdiU7tuUuHp+j6Fc=  ;
X-YMail-OSG: bMt9IDMVM1ktV23UDvq8Hyo30kL.olxRDtcKHCMU_rf.jFNWDAaZo92unCpsGAm1WM7OSPsPxkP1ELpGJN2EH2oqv5m6srkRlS5tF3UShmpOnj_UO6Lz12gpkvgZT0E-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@kroah.com>
Subject: Re: USB Serial device disconnect causes IRQ disable after using ehci controller halted
Date: Wed, 27 Aug 2008 11:37:23 -0700
User-Agent: KMail/1.9.9
Cc: amruth_pv@yahoo.com, Alan Stern <stern@rowland.harvard.edu>,
       Karsten Wiese <fzu@wemgehoertderstaat.de>,
       Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <434860.93444.qm@web45203.mail.sp1.yahoo.com> <200808262335.05204.david-b@pacbell.net> <20080827175325.GB31820@kroah.com>
In-Reply-To: <20080827175325.GB31820@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808271137.24557.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 August 2008, Greg KH wrote:
> 
> > As noted by Stefan Neis <Stefan.Neis@kobil.com>, we had a recent
> > regression with EHCI periodic transfers, in some (seemingly not
> > all that common) cases.
> > 
> > The root cause was that the schedule activation was only loosely
> > coupled to the addition or removal of transfers, so two different 
> > execution contexts could both think they had to deactivate (or
> > conversely activate) the schedule.  So this fix tightens that
> > coupling, managing it more like a refcount.
> > 
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> Do you want me to also apply this one?  If so, for .27 or .28?

It should get into 2.6.27, and probably 26.stable ... assuming
that it checks out properly.  A somewhat cruftier version resolved
Stefan's problem, but I'd rather not merge that one.  Hmm, I'll
ask Stefan to confirm this version.

- Dave
