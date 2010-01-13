Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303Ab0AMUV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab0AMUV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 15:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826Ab0AMUV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 15:21:56 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:36033 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab0AMUV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 15:21:56 -0500
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.33-rc4, boot regression still exists
Date: Wed, 13 Jan 2010 15:21:35 -0500
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4; KDE/4.3.3; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
In-reply-to: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
MIME-version: 1.0
Content-type: Text/Plain; charset=utf-8
Content-transfer-encoding: 7bit
Message-id: <201001131521.35503.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 January 2010, Linus Torvalds wrote:
>Hmm. Odd release. Something like 40% of the patches are in DRM (mostly
>nouveau and radeon, both staging, so it's a bit less scary than it sounds.
>But there's a noticeable i915 component too). That's all pretty unusual,
>afaik.
>
>There's some boot loader compression updates too that have already turned
>out to be a bit painful on non-x86/arm platforms (but we'll sort it out),
>various arch updates (mips, arm, mn10300), networking, and filesystems.
>
>Go forth and compile,
>
>		Linus
I did, twice.  I use a couple of scripts to do the building, and I am still 
required to add
--------------
echo now we have find the /lib/firmware/amd-ucode and copy it
mkdir -p firmware/amd-ucode
cp -f -R /lib/firmware/amd-ucode/ ./firmware/
-------------
to my buildit26 script, and to add:
---------------------
CONFIG_EXTRA_FIRMWARE="amd-ucode/microcode_amd.bin"
--------------------

To my .config, else it hangs for 60 seconds, about .65 seconds into the boot, 
requesting the firmware amd-ucode/microcode_amb.bin and can't find it.

With the above additions, it appears to be running nominally here.  glxgears 
was, at 2.6.32, about 275 fps, and its about 400 now so that is welcomed.

Thank you.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)

Straw?  No, too stupid a fad.  I put soot on warts.
