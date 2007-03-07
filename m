Return-Path: <linux-kernel-owner+w=401wt.eu-S965225AbXCGM6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965225AbXCGM6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 07:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965236AbXCGM6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 07:58:01 -0500
Received: from nz-out-0506.google.com ([64.233.162.238]:32867 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965225AbXCGM6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 07:58:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=ECpi9WtNJqC7nAXDzfD8bYO35qe3Ryy7iFAZizFDoYIN9XG19+u1YU2T8CjnY1Z5eZIkyo+/vpsZRGcx00bo7VkgtTKPXg+4d+zmLC4d9vryv5H0SUVlRlOv9wwxipSBzY/62Aqqhzo3aAri1w8u5Vy7zVEuw0V8iHM9KtMONCE=
Message-ID: <45EEB66C.9090901@googlemail.com>
Date: Wed, 07 Mar 2007 13:56:12 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux v2.6.21-rc3
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Linus Torvalds napisał(a):
> We've finally hopefully started to put a dent in the regressions, 
> especially the suspend/resume problems introduced since 2.6.20.

I get this while
echo shutdown > /sys/power/disk; echo disk > /sys/power/state

BUG: using smp_processor_id() in preemptible [00000001] code: swsusp_shutdown/3359
caller is check_tsc_sync_source+0x1b/0xef
 [<c010503d>] show_trace_log_lvl+0x1a/0x2f
 [<c0105724>] show_trace+0x12/0x14
 [<c01057d6>] dump_stack+0x16/0x18
 [<c01f835e>] debug_smp_processor_id+0xa2/0xb4
 [<c0113cc5>] check_tsc_sync_source+0x1b/0xef
 [<c011367d>] __cpu_up+0x136/0x158
 [<c0141aec>] _cpu_up+0x74/0xbf
 [<c0141b5d>] cpu_up+0x26/0x38
 [<c0141bbc>] enable_nonboot_cpus+0x4d/0x9a
 [<c0146ae0>] pm_suspend_disk+0x11c/0x210
 [<c014597e>] enter_state+0x50/0x1d0
 [<c0145b84>] state_store+0x86/0x9c
 [<c01a53d0>] subsys_attr_store+0x20/0x25
 [<c01a54ea>] sysfs_write_file+0xc1/0xe9
 [<c017199b>] vfs_write+0xaf/0x138
 [<c0171f65>] sys_write+0x3d/0x61
 [<c0104064>] syscall_call+0x7/0xb
 =======================

l *check_tsc_sync_source+0x1b/0xef
0xc0113caa is in check_tsc_sync_source (/mnt/md0/devel/linux-git/arch/i386/kernel/../../x86_64/kernel/tsc_sync.c:99).
94      /*
95       * Source CPU calls into this - it waits for the freshly booted
96       * target CPU to arrive and then starts the measurement:
97       */
98      void __cpuinit check_tsc_sync_source(int cpu)
99      {
100             int cpus = 2;
101
102             /*
103              * No need to check if we already know that the TSC is not

echo platform > /sys/power/disk; echo disk > /sys/power/state
doesn't work (as always).

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc3/boot.log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc3/git-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
