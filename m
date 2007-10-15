Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbXJOVqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbXJOVqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbXJOVp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:45:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37224 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759024AbXJOVpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:45:55 -0400
Date: Mon, 15 Oct 2007 14:43:49 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davej@redhat.com
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Message-ID: <20071015144349.2e31f98a@laptopd505.fenrus.org>
In-Reply-To: <20071015210737.GA15293@khazad-dum.debian.net>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com>
	<20071015210737.GA15293@khazad-dum.debian.net>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 19:07:37 -0200
Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Mon, 15 Oct 2007, Jeremy Katz wrote:
> > There are standard keycodes for brightness and volume; map the
> > events to emit them so that things work properly
> 
> NAK.  It is the completely wrong thing to do for IBM thinkpads which
> process volume and brightness completely in firmware.
> 
> And the input subsystem maintainer has made it extremely clear in
> various threads that the input devices are *not* to be used as a
> notification service for on-screen-display or other such stuff.  If
> you send volume and brightness *key* events to userspace, it is
> supposed to act on them and raise/lower brightness/volume, which is
> the wrong thing to do on thinkpads. Never mind that HAL is ignoring
> the input maintainer's directions and violating this.
> 
> We should fix the backlight class to be more useful and support
> poll() or somesuch, for userspace to track the backlight level in a
> resource-friendly way for OSD (the only sane thing to do on an IBM
> thinkpad with such events). And an ALSA mixer to provide a proper
> path to the thinkpad-acpi volume functionality is also in my schedule
> for 2.6.25.
> 

there is a huge problem with this though: Depending on your graphics
chip, it's the graphics driver, not the bios, that does the backlight
control......  in fact the trend in hardware (this is what windows
does) is have the OS take over the control of all of this as soon as
possible...

Linux should do this with software control as well for that reason; the
other approach just isn't going to be possible in the long term ;(
