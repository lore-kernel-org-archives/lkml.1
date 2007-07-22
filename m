Return-Path: <linux-kernel-owner+w=401wt.eu-S1761752AbXGVO7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761752AbXGVO7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 10:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbXGVO7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 10:59:30 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:46450 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323AbXGVO73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 10:59:29 -0400
Date: Sun, 22 Jul 2007 16:59:26 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: MMC/SD Root filesystem suspend/resume problems
Message-ID: <20070722165926.54caeca5@poseidon.drzeus.cx>
In-Reply-To: <1185114480.6819.24.camel@localhost.localdomain>
References: <1184860419.29634.10.camel@localhost.localdomain>
	<20070719190309.28708be8@poseidon.drzeus.cx>
	<1185110313.6819.8.camel@localhost.localdomain>
	<20070722160534.3ccfc8f9@poseidon.drzeus.cx>
	<1185114480.6819.24.camel@localhost.localdomain>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007 15:28:00 +0100
Richard Purdie <rpurdie@rpsys.net> wrote:

> 
> Corruption is corruption and it shouldn't happen if we can avoid it.
> It happens with complete certainty in one case and only happens in the
> other if the user does something which is a fairly obvious bad idea
> (which is documented as such).
> 

The corruption will only occur if the filesystem is dirty. Granted, the
mount will be dead and useless, but I wouldn't call that corruption.

Anyway, this behaviour was selected after seeing the long discussion
about how USB should handle the same problem. It was decided that it
was best to play it safe and remove any devices that couldn't be
determined to have remained in the slot. We also have the USB_PERSIST
option these days, which does the same thing as MMC_UNSAFE_RESUME.

> 
> Given I can suspend the device with "echo mem > /sys/power/state",
> that implies we need to fix echo? ;-)
> 

Or that direct usage of /sys/power/state is only for those who know
what they are doing (and have umounted their filesystems beforehand).

> 
> > And if we keep papering over the problems, you reduce the motivation
> > of fixing this properly.
> 
> Maybe although I don't like existing functionality being broken even
> if its less than ideal.
> 

I am of the opinion that it was more broken before I touched it. Silent
corruption is never acceptable in my book. But if it is in yours, just
enable MMC_UNSAFE_RESUME and you'll have the old behaviour.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
