Return-Path: <linux-kernel-owner+w=401wt.eu-S1765091AbZAONnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765091AbZAONnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:43:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758790AbZAONmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:42:52 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:46717 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219AbZAONmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:42:51 -0500
Date: Thu, 15 Jan 2009 14:42:49 +0100
To: linux-kernel@vger.kernel.org
Subject: dri /dev node disappeared with 2.6.29-rc1
Message-ID: <20090115134249.GP28392@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, 

(please Cc, and sorry, don't know where to cross post that one)

switching from 2.6.28-rc9 to 2.6.29-rc1 my /dev/dri/* entries got lost.
Hardware is intel GM45:
[    1.225368] agpgart-intel 0000:00:00.0: Intel Mobile Intel® GM45 Express Chipset
[    1.230650] agpgart-intel 0000:00:00.0: detected 65532K stolen memory
[    1.239716] PM: Adding info for No Bus:agpgart
[    1.239844] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    1.240093] PM: Adding info for No Bus:tpm0
[    1.564241] [drm] Initialized drm 1.1.0 20060810

but X tells me:
(II) intel(0): Kernel reported 1264128 total, 1 used
(II) intel(0): I830CheckAvailableMemory: 5056508 kB available
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is -1, (No such device)
drmOpenDevice: open result is -1, (No such device)
drmOpenDevice: Open failed
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is -1, (No such device)
drmOpenDevice: open result is -1, (No such device)
drmOpenDevice: Open failed
[drm] failed to load kernel module "i915"

...

I see the post 
	[PATCH] drm/i915: why does kconfig hate?
but using that patch I still get:
	drivers/gpu/drm/Kconfig:8:error: found recursive dependency: DRM
-> <choice> -> DRM_I915 -> FB -> FB_I810 -> AGP -> DRM

Any chance to fix that, or some suggestion?

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
The major difference between a thing that might go wrong
and a thing that cannot possibly go wrong is that when a
thing that cannot possibly go wrong goes wrong it usually
turns out to be impossible to get at or repair.
                 --- One of the laws of computers and programming revealed.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
