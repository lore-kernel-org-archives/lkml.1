Return-Path: <linux-kernel-owner+w=401wt.eu-S933177Ab0AFXzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177Ab0AFXzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933144Ab0AFXzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:55:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933171Ab0AFXzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:55:12 -0500
Date: Thu, 7 Jan 2010 00:55:11 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Gene Heskett <gene.heskett@verizon.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33-rc3, rc2 regression at boot
In-Reply-To: <201001061602.44133.gene.heskett@verizon.net>
Message-ID: <alpine.LRH.2.00.1001070053390.15694@twin.jikos.cz>
References: <alpine.LFD.2.00.1001051838410.3630@localhost.localdomain> <201001052355.29640.gene.heskett@verizon.net> <201001061602.44133.gene.heskett@verizon.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010, Gene Heskett wrote:

> >[    0.558368] Unpacking initramfs...
> >[    0.648644] Freeing initrd memory: 3431k freed
> >[    0.651635] platform microcode: firmware: requesting
> > amd-ucode/microcode_amd.bin [   60.646738] microcode: failed to load file
> > amd-ucode/microcode_amd.bin [   60.646858] microcode: CPU0:
> > patch_level=0x1000065
> >[   60.646977] microcode: CPU1: patch_level=0x1000065
> >[   60.647099] microcode: CPU2: patch_level=0x1000065
> >[   60.647218] microcode: CPU3: patch_level=0x1000065
> >
> >Note the time, it kills quite close to a whole minute there, which at first
> >would appear to be because there is not yet a mounted /lib filesystem to
> > suck it from.  I didn't build an rc1, but rc2 also suffers from this.
> > 2.6.32.2 does not do this although its firmware request takes place at the
> > same point. So it doesn't look like it is the lack of a mounted filesystem
> > after all.
> >
> >FWIW, because it was a hot reboot, the patch_level reported is the correct
> >level.
> >
> >I am also seeing some complaints about my Audigy2 sound card, but what I
> > saw during the boot, never made it to the messages log.  Something about
> > guessing at the proper config, but I did hear kde sign on when x started.
> >
> >Thanks Linus.
> >
> Update, I edited the .config by hand and added the full path in
> CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware/"
> which was just 'firmware', and rebuilt.  No difference.  I still get the 60 
> second hang.  FWIW, this particular setting isn't visible in a make xconfig.

As this is already at the stage when userspace exists and init has been 
started, it might well be delay of some userspace stuff, not directly 
kernel.

Does alt-sysrq-t at the time it is stuck give any clue?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

