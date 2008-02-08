Return-Path: <linux-kernel-owner+w=401wt.eu-S933712AbYBHIxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712AbYBHIxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 03:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbYBHIxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 03:53:10 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:39508 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbYBHIxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 03:53:09 -0500
Date: Fri, 8 Feb 2008 09:53:05 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: why kexec insists on syncing with recent kernels?
In-Reply-To: <47AB120A.1000600@wpkg.org>
Message-ID: <Pine.LNX.4.64.0802080949470.18242@anakin>
References: <47AB120A.1000600@wpkg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008, Tomasz Chmielewski wrote:
> According to kernel/kexec.c:
> 
>  * kexec does not sync, or unmount filesystems so if you need
>  * that to happen you need to do that yourself.
> 
> 
> I saw this was true with 2.6.18 kernel (i.e., it didn't sync), but kexec syncs
> with recent kernels (I checked 2.6.23.14 and 2.6.24):
> 
> # kexec -e
> md: stopping all md devices
> sd 2:0:0:0: [sdb] Synchronizing SCSI cache
> 
> 
> With kexec on 2.6.18 it was executing a loaded kernel immediately.
> 
> 
> Generally, it's a good thing to sync before jumping into a new kernel, but it
> breaks my setup here after upgrading from 2.6.18 to 2.6.24.
> 
> Why?
>
> I have a couple of diskless (iSCSI-boot) machines with a buggy BIOS (old
> Supermicro P4SBR/P4SBE) which randomly freeze after rebooting (the machine
> shuts down just fine, but instead of booting again, showing BIOS bootup
> messages etc. you can just see blank screen).
> 
> Therefore, I use kexec as a workaround for this rebooting problem.
> 
> The way kexec works now makes rebooting unreliable again:
> - network interfaces are brought down,
> - kernel tries to sync - it never will, as we're booted off network, which is
> down
> 
> Any ideas why kexec insists on syncing?

kexec calls device_shutdown(), so ->shutdown() will be called for all
devices.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
