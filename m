Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbXGVOFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbXGVOFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 10:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbXGVOFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 10:05:44 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:39390 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbXGVOFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 10:05:43 -0400
Date: Sun, 22 Jul 2007 16:05:34 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: MMC/SD Root filesystem suspend/resume problems
Message-ID: <20070722160534.3ccfc8f9@poseidon.drzeus.cx>
In-Reply-To: <1185110313.6819.8.camel@localhost.localdomain>
References: <1184860419.29634.10.camel@localhost.localdomain>
	<20070719190309.28708be8@poseidon.drzeus.cx>
	<1185110313.6819.8.camel@localhost.localdomain>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007 14:18:33 +0100
Richard Purdie <rpurdie@rpsys.net> wrote:

> 
> I enabled the MMC_UNSAFE_RESUME option and the problems I was seeing
> was "fixed". I think having this option is a bad idea (in its current
> form) as it doesn't actually stop filesystem corruption.
> 
> With the option disabled, if a filesystem is mounted when you suspend
> my tests show the filesystem is corrupted. At least if the option is
> enabled, the filesystem is only corrupted if you remove the card
> whilst suspended which is more preferable.
> 

I disagree. With this option you get silent corruption, without you get
noisy corruption. And I would always prefer the latter, even if it
increases the risk of it happening.

> I guess the solution would be to abort the suspend if mounted systems
> were detected and the option was disabled? Alternatively the option
> could be "auto" enabled only for mounted systems maybe with a printk
> warning?
> 

This is a general problem for all removable/hotpluggable storage. So
sticking it in the MMC block device would be the wrong layer IMO.

Until the filesystems can be made to store something sane on disk
before the suspend, I'd say this is best handled in user space. Let the
user space tools refuse to initiate the suspend as long as any
removable devices are mounted.

> Of course the best solution would be to have filesystems support
> suspend/resume requests since other subsystems like pcmcia also suffer
> this problem and would benefit from this but I accept that teaching
> filesystems this is more difficult.
> 

Doesn't mean we shouldn't do it. And if we keep papering over the
problems, you reduce the motivation of fixing this properly.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
