Return-Path: <linux-kernel-owner+w=401wt.eu-S1761931AbYDBUnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761931AbYDBUnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762576AbYDBUbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:31:16 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:23236 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762571AbYDBUbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:31:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UjxgQ8BDpFT39QYHVTSETZ24cMYtQ9ovfrxPHySsRbIBlKXkj31yboBwdpoPGGvAJl9MZMBNPANwErNmy8gzs3d0QE7qxD8cdj0dfW9fD5cflYA4eWvM7AAnts9zzLG9VQbL0AJEiRerGLoe6ov76SD5o0hF+/O3z1K2UWhI9jI=  ;
X-YMail-OSG: zSwXu1IVM1kgpes7uf9Bd9ixU0QlHRTF4z0owXq057YdAlqUY4AMpMCV9ygsrRD4XQYT84l_dg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb ehci_iaa_watchdog fix
Date: Wed, 2 Apr 2008 13:31:09 -0700
User-Agent: KMail/1.9.6
Cc: Mark Lord <lkml@rtr.ca>, pavel@suse.cz, oliver@neukum.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, jikos@suse.cz,
       gregkh@suse.de, akpm@linux-foundation.org
References: <Pine.LNX.4.44L0.0804021244230.5042-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0804021244230.5042-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804021331.09991.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008, Alan Stern wrote:
> > -     if (ehci->reclaim
> > -                     && !timer_pending(&ehci->iaa_watchdog)
> > -                     && HC_IS_RUNNING(ehci_to_hcd(ehci)->state)) {
> > +     if (ehci->reclaim && !timer_pending(&ehci->iaa_watchdog)) {
> >               u32 cmd, status;
> >  
> >               /* If we get here, IAA is *REALLY* late.  It's barely
> 
> Okay, I'm puzzled.  How could this make any difference?

It's more like:  what else in that patch could have had
any such effect?  That HC_IS_RUNNING test was the only
candidate.

Those hcd->state tests have been getting more and more
dodgey as time goes by.  At this point I hardly trust
any of them.  There *IS* no clear state machine which
governs the usbcore/HCD interaction.

- Dave


