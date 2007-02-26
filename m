Return-Path: <linux-kernel-owner+w=401wt.eu-S965085AbXBZMfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965085AbXBZMfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 07:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965235AbXBZMfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 07:35:53 -0500
Received: from twin.jikos.cz ([213.151.79.26]:60701 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965085AbXBZMfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 07:35:52 -0500
Date: Mon, 26 Feb 2007 13:35:48 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Richard Purdie <rpurdie@rpsys.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc1 dims my LCD
In-Reply-To: <1172490091.5824.30.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz>
 <1172490091.5824.30.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007, Richard Purdie wrote:

> > When I hit the keyboard, the brightness stays low (it's 50% of light 
> > or so, so I could read what's on the screen, but it's uncomfortably 
> > dim), and I have to manually raise the brightness on the LCD. Quite 
> > annoying :) I have bisected this to your commit 
> > 994efacdf9a087b52f71e620b58dfa526b0cf928
> Which framebuffer driver and backlight driver are you using?
> ("ls /sys/class/backlight/" will show which backlight it is)

It's IBM:

$ ll /sys/class/backlight/
drwxr-xr-x 2 root root 0 Feb 26 13:28 ibm

At the time the brightness goes low, there is '0' in 
/sys/class/backlight/ibm/actual_brightness and 
/sys/class/backlight/ibm/brightness

Echoing '7' into /sys/class/backlight/ibm/brightness gets the brightness 
back again to normal.

> Is the machine in active use when it dims or at idle and does the screen 
> blank at the same time it dims? If so, does the keypress unblank the 
> screen (but not change the brightness)?

It doesn't blank at the time it dims - it just decreases brightness. I 
will do some more tests, but it seemed on a first sight that it happens 
only when the machine is idle.

> Also, is this on a console or under something like X? 

I observed it only on console, but didn't experiment with it too much yet.

-- 
Jiri Kosina
