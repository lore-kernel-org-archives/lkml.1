Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbXEFTA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbXEFTA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 15:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbXEFTA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 15:00:29 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:49888 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbXEFTA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 15:00:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fc6T2ymAWnRyDalLyGGrROnQ4QXrLIImA5OjCskcilIs+XRQBCdpk/JVSUENVOkxJJBA1Uec140fTsnW8tc9uz0y7XoCiGq+aPsbNg/qmiFgFdhnRM5YvI9Sq9kzEw3Wn8SHUlfX8+M2X1fUjG6V2wRBSVUtK2FZ4BFxzl9xX7g=
Date: Sun, 6 May 2007 23:00:39 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, clameter@sgi.com, airlied@linux.ie
Subject: 2.6.21-mm1: DRM does kmalloc(0) sometimes?
Message-ID: <20070506190039.GA24881@martell.zuzino.mipt.ru>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is this a sign of bug? The box is functioning OK, despite

	WARN_ON_ONCE(size == 0);
-------------------------------------------------------------
CONFIG_DRM=y
CONFIG_DRM_RADEON=y
X.org 7.1.1 as shipped with Gentoo
VGA compatible controller: ATI Technologies Inc RV350 AP [Radeon 9600]
-------------------------------------------------------------
	...
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 4x mode
eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
[drm] Setting GART location based on new memory map
[drm] Loading R300 Microcode
[drm] writeback test succeeded in 1 usecs
BUG: at include/linux/slub_def.h:88 kmalloc_index()
 [<c0147ed1>] get_slab+0x43/0x1c6
 [<c01480b3>] __kmalloc+0xc/0x2b
 [<c027c1e6>] drm_rmdraw+0x0/0x251
 [<c027c30f>] drm_rmdraw+0x129/0x251
 [<c027c1e6>] drm_rmdraw+0x0/0x251
 [<c027ce2f>] drm_ioctl+0x152/0x197
 [<c0153b0c>] do_ioctl+0x4c/0x64
 [<c0153d61>] vfs_ioctl+0x23d/0x250
 [<c01025e2>] sysenter_past_esp+0x8f/0x99
 [<c0153da7>] sys_ioctl+0x33/0x4c
 [<c01025b2>] sysenter_past_esp+0x5f/0x99
 =======================
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 4x mode
[drm] Setting GART location based on new memory map
[drm] Loading R300 Microcode
[drm] writeback test succeeded in 1 usecs
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 4x mode
[drm] Loading R300 Microcode
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 4x mode
[drm] Loading R300 Microcode
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 4x mode
[drm] Loading R300 Microcode
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 4x mode
[drm] Loading R300 Microcode
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 4x mode
[drm] Loading R300 Microcode
Clocksource tsc unstable (delta = 104013683 ns)
Time: pit clocksource has been installed.

