Return-Path: <linux-kernel-owner+w=401wt.eu-S1030259AbXBZPn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030259AbXBZPn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 10:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030298AbXBZPn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 10:43:56 -0500
Received: from tim.rpsys.net ([194.106.48.114]:55784 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030259AbXBZPny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 10:43:54 -0500
Subject: Re: 2.6.21-rc1 dims my LCD
From: Richard Purdie <rpurdie@rpsys.net>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org,
       FB-Dev <linux-fbdev-devel@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.64.0702261617240.10496@twin.jikos.cz>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz>
	 <1172490091.5824.30.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz>
	 <20070226142157.GA2909@khazad-dum.debian.net>
	 <1172501357.5824.91.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0702261617240.10496@twin.jikos.cz>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 15:43:37 +0000
Message-Id: <1172504617.5824.102.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-26 at 16:24 +0100, Jiri Kosina wrote:
> On Mon, 26 Feb 2007, Richard Purdie wrote:
> 
> > Jiri: I've appended a patch that should already be queued, could you
> > test and see if it solves the problem.
> 
> Thanks. In the meantime I have gone through the code and I can confirm 
> that this is the root cause of what I am observing.
> 
> Now regarding the patch - at the time when the dim happened previously, 
> currently there is a observable blink (after which the brightness is 
> correct). 

The reason for the behaviour is that its turning the backlight down/off
to save power as it thinks the screen is blank. The blink therefore
makes sense as far as the backlight class is concerned and its working
as intended now.

> I have put some debugging printk() into fb_notifier_callback(), 
> and it turns out that on FB_EVENT_CONBLANK, there are two successive calls 
> to backlight_update_status(), second immediately following the first one:
> 
> Feb 26 15:11:14 thunder kernel: calling backlight_update_status() with bd->props.fb_blank == 1, bd->props.brightness == 0
> Feb 26 15:11:14 thunder kernel: calling backlight_update_status() with bd->props.fb_blank == 0, bd->props.brightness == 0
> 
> Is this really a right thing to do?

This should come from two calls to fbcon_generic_blank() in
drivers/video/console/fbcon.c with a different blank parameter and is
therefore in a way outside the scope of the backlight class.

It would be interesting to know why it decides to blank then immediately
unblank the display though. I've cc'd the fbdev-devel list.

Richard


