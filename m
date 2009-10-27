Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZJ0NZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZJ0NZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbZJ0NZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:25:45 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:60204 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbZJ0NZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:25:45 -0400
Date: Tue, 27 Oct 2009 14:25:49 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SHMEM question
Message-ID: <20091027132548.GD5585@boogie.lpds.sztaki.hu>
References: <200910261159.04995.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910261159.04995.gene.heskett@verizon.net>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 11:59:04AM -0400, Gene Heskett wrote:

> On looking at it:
> [root@coyote Download]# ls -l /dev/shm
> total 28
> -rw-r----- 1 root root     4096 2009-10-25 12:09 mono.10594
> -r-------- 1 root root 67108904 2009-10-24 00:28 pulse-shm-3880918577
> -rw-rw-rw- 1 root root       16 2009-10-24 01:17 sem.ADBE_ReadPrefs_root
> -rw-rw-rw- 1 root root       16 2009-10-24 01:17 sem.ADBE_REL_root
> -rw-rw-rw- 1 root root       16 2009-10-24 01:17 sem.ADBE_WritePrefs_root
> 
> On grepping for SHM in the .config, I find SHMEM set to y, but about an hours 
> worth of wandering around in a 'make xconfig' has failed to actually find it.

No wonder, it has nothing to do with the kernel. glibc uses /dev/shm to
implement POSIX shared memory, see shm_overview(7).

> That pulse-shm-3880918577 file at over 67 megabytes is all $00 till $04000000 
> into it, then there is 6 non-zero bytes and the rest is back to all balls.

If it bothers you then do not use pulseaudio.

> Is this some indicator of a new rootkit or WTF?

Not neccessarily. However since most people never look into /dev/shm,
it's not a bad place to hide data. But it will go away at reboot, so
it's not that useful for a rootkit.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
