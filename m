Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbZDXAwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbZDXAwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 20:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZDXAwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 20:52:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:12593 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZDXAwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 20:52:31 -0400
Message-ID: <49F10D49.5010604@gawab.com>
Date: Thu, 23 Apr 2009 17:52:25 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [.30-rc2 regression] garbled screen on video
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Summary:
After playing a video for a little bit, the screen gets garbled. The 
only way to fix it is to
switch to a virtual console and then back. The screen is fixed but 
unfortunately only for
less than a few minuets and the screen gets corrupted again.

Effected Version: 2.6.30-rc2+
Picture showing a corrupt screen: 
http://ecs.fullerton.edu/~cs351a15/badscreen.jpg

My System:
Ubuntu 9.4 with 943/940GML Express Integrated Graphics Controller 
[8086:27a2]
UXA/GEM/DRI2 enable. Full info at 
http://jdserver.homelinux.org/bugreports/004/

Syslog Messages:
None, but switching virtual consoles gives
[drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for 
disabled pipe 0
But I think that is another bug introduced with .30-rc1.

Bisecting gave me the following (verified) commit

280b713b5b0fd84cf2469098aee88acbb5de859c is first bad commit
commit 280b713b5b0fd84cf2469098aee88acbb5de859c
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Mar 12 16:56:27 2009 -0700

    drm/i915: Allow tiling of objects with bit 17 swizzling by the CPU.

    Save the bit 17 state of the pages when freeing the page list, and
    reswizzle them if necessary when rebinding the pages (in case they were
    swapped out).  Since we have userland with expectations that the swizzle
    enums let it pread and pwrite contents accurately, we can't expose a new
    swizzle enum for bit 17 (which it would have to GTT map to handle), 
so we
    handle it down in pread and pwrite by swizzling the copy when bit 17 
of the
    page address is set.

    Signed-off-by: Eric Anholt <eric@anholt.net>

:040000 040000 32f68f62b336326cee85e22f068d4410197994ef 
e820ef2a2fd3f9133960f390f27c79caa5ec83d2 M      drivers
:040000 040000 573ade35bd21d9c37c43f470d8ab718f728ef101 
32642903c265079acfa20b71d4ec2ee427a70c3a M      include

Justin Madru
