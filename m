Return-Path: <linux-kernel-owner+w=401wt.eu-S1030327AbXBZRBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030327AbXBZRBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030332AbXBZRBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:01:40 -0500
Received: from tim.rpsys.net ([194.106.48.114]:42255 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030327AbXBZRBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:01:39 -0500
Subject: Re: 2.6.21-rc1 dims my LCD
From: Richard Purdie <rpurdie@rpsys.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <20070226160354.GC2909@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz>
	 <1172490091.5824.30.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz>
	 <20070226142157.GA2909@khazad-dum.debian.net>
	 <1172501357.5824.91.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0702261617240.10496@twin.jikos.cz>
	 <20070226160354.GC2909@khazad-dum.debian.net>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 17:01:11 +0000
Message-Id: <1172509271.5824.108.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-26 at 13:03 -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 26 Feb 2007, Jiri Kosina wrote:
> > Now regarding the patch - at the time when the dim happened previously, 
> > currently there is a observable blink (after which the brightness is 
> > correct). I have put some debugging printk() into fb_notifier_callback(), 
> > and it turns out that on FB_EVENT_CONBLANK, there are two successive calls 
> > to backlight_update_status(), second immediately following the first one:
> > 
> > Feb 26 15:11:14 thunder kernel: calling backlight_update_status() with bd->props.fb_blank == 1, bd->props.brightness == 0
> > Feb 26 15:11:14 thunder kernel: calling backlight_update_status() with bd->props.fb_blank == 0, bd->props.brightness == 0
> 
> This should cause *no* blink. It is setting brightness to zero anyway, which
> is all ibm-acpi cares about (without a patch I will be sending in soon).
> And ibm-acpi doesn't issue hardware calls that would not change the
> brightness value.

I'm assuming this was a paste from before your patch was applied and
that bd->props.brightness has a positive value when these calls were
made afterwards. Since the ibm backlight currently ignores fb_blank, it
shouldn't blink the backlight.

The screen still probably blinks since the framebuffer driver will see
the blank request too.

Richard

