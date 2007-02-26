Return-Path: <linux-kernel-owner+w=401wt.eu-S1030268AbXBZOWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030268AbXBZOWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 09:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030275AbXBZOWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 09:22:09 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56989 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030268AbXBZOWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 09:22:08 -0500
X-Sasl-enc: GRLIZm3URsGXZ7G21VfH4pHzOhLQOmFgTGN79whQfWhY 1172499727
Date: Mon, 26 Feb 2007 11:21:57 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc1 dims my LCD
Message-ID: <20070226142157.GA2909@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz> <1172490091.5824.30.camel@localhost.localdomain> <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007, Jiri Kosina wrote:
> On Mon, 26 Feb 2007, Richard Purdie wrote:
> > > When I hit the keyboard, the brightness stays low (it's 50% of light 
> > > or so, so I could read what's on the screen, but it's uncomfortably 
> > > dim), and I have to manually raise the brightness on the LCD. Quite 
> > > annoying :) I have bisected this to your commit 
> > > 994efacdf9a087b52f71e620b58dfa526b0cf928
> > Which framebuffer driver and backlight driver are you using?
> > ("ls /sys/class/backlight/" will show which backlight it is)
> 
> It's IBM:

Please add me to the CC, then.  I noticed this thread by accident.

> $ ll /sys/class/backlight/
> drwxr-xr-x 2 root root 0 Feb 26 13:28 ibm
> 
> At the time the brightness goes low, there is '0' in 
> /sys/class/backlight/ibm/actual_brightness and 
> /sys/class/backlight/ibm/brightness

ibm-acpi does not implement display poweroff, so if a screen-saving function
on the kernel is trying to use it to shut the display off, it will either
fail to do anything, or if it ALSO sets brightness to zero, it will just dim
the display.

Richard, would you like a patch to -ENOSYS if a display power management
event reaches ibm-acpi?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
