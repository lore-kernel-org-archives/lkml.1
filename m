Return-Path: <linux-kernel-owner+w=401wt.eu-S1030305AbXBZPYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030305AbXBZPYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 10:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030307AbXBZPYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 10:24:55 -0500
Received: from twin.jikos.cz ([213.151.79.26]:41857 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030305AbXBZPYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 10:24:54 -0500
Date: Mon, 26 Feb 2007 16:24:47 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Richard Purdie <rpurdie@rpsys.net>
cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc1 dims my LCD
In-Reply-To: <1172501357.5824.91.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0702261617240.10496@twin.jikos.cz>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz> 
 <1172490091.5824.30.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz>  <20070226142157.GA2909@khazad-dum.debian.net>
 <1172501357.5824.91.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007, Richard Purdie wrote:

> Jiri: I've appended a patch that should already be queued, could you
> test and see if it solves the problem.

Thanks. In the meantime I have gone through the code and I can confirm 
that this is the root cause of what I am observing.

Now regarding the patch - at the time when the dim happened previously, 
currently there is a observable blink (after which the brightness is 
correct). I have put some debugging printk() into fb_notifier_callback(), 
and it turns out that on FB_EVENT_CONBLANK, there are two successive calls 
to backlight_update_status(), second immediately following the first one:

Feb 26 15:11:14 thunder kernel: calling backlight_update_status() with bd->props.fb_blank == 1, bd->props.brightness == 0
Feb 26 15:11:14 thunder kernel: calling backlight_update_status() with bd->props.fb_blank == 0, bd->props.brightness == 0

Is this really a right thing to do?

-- 
Jiri Kosina
