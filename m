Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbZFZUJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbZFZUJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 16:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbZFZUJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 16:09:23 -0400
Received: from mail-yx0-f204.google.com ([209.85.210.204]:45627 "EHLO
	mail-yx0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZFZUJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 16:09:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Qy2xpfdzWKB5vEF1wuIDZPyIg5J11yWINMPJE2VRHpxs1t6BVCBqAm94puO4X0BlpV
         yCG3xfT2fx1KCYUUnXJU3JRpdRTMzuPeY9fc4rVeeN6HGQnrkYBXsrRz3YSRtWco6+pg
         r1wUxhQc13/3NDYiW1ET8NOzrJtv1k3A6ZBxA=
MIME-Version: 1.0
Date: Fri, 26 Jun 2009 13:09:24 -0700
Message-ID: <dd18b0c30906261309x4455c406jc18c3d0d3d7c62cb@mail.gmail.com>
Subject: BUG kmalloc-1024: Poison overwritten
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this might of happened because I
shut the machine off half way during boot:


[    5.588728] =============================================================================
[    5.588730] BUG kmalloc-1024: Poison overwritten
[    5.588731] -----------------------------------------------------------------------------
[    5.588732]
[    5.588733] INFO: 0xf4fe90c0-0xf4fe9103. First byte 0x24 instead of 0x6b
[    5.588735] INFO: Slab 0xc1c8bd00 objects=15 used=4 fp=0xf4fe90c0
flags=0x400040c3
[    5.588737] INFO: Object 0xf4fe90c0 @offset=4288 fp=0xf4fe94f0
[    5.588737]
[    5.588739] Bytes b4 0xf4fe90b0:  74 8c 05 00 80 1a 06 00 1c c8 06
00 20 a1 07 00 t........È...¡..
[    5.588744]   Object 0xf4fe90c0:  24 b8 08 00 2b 2c 0a 00 00 35 0c
00 40 42 0f 00 $¸..+,...5..@B..
[    5.588748]   Object 0xf4fe90d0:  55 58 14 00 80 84 1e 00 15 16 05
00 74 8c 05 00 UX..........t...
[    5.588753]   Object 0xf4fe90e0:  80 1a 06 00 1c c8 06 00 20 a1 07
00 24 b8 08 00 .....È...¡..$¸..
[    5.588758]   Object 0xf4fe90f0:  2b 2c 0a 00 00 35 0c 00 40 42 0f
00 55 58 14 00 +,...5..@B..UX..
[    5.588763]   Object 0xf4fe9100:  80 84 1e 00 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b ....kkkkkkkkkkkk
[    5.588767]   Object 0xf4fe9110:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588772]   Object 0xf4fe9120:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588777]   Object 0xf4fe9130:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588781]   Object 0xf4fe9140:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588786]   Object 0xf4fe9150:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588791]   Object 0xf4fe9160:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588795]   Object 0xf4fe9170:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588800]   Object 0xf4fe9180:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588805]   Object 0xf4fe9190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588809]   Object 0xf4fe91a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588814]   Object 0xf4fe91b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588819]   Object 0xf4fe91c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588824]   Object 0xf4fe91d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588828]   Object 0xf4fe91e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588833]   Object 0xf4fe91f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588838]   Object 0xf4fe9200:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588842]   Object 0xf4fe9210:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588847]   Object 0xf4fe9220:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588852]   Object 0xf4fe9230:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588856]   Object 0xf4fe9240:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588861]   Object 0xf4fe9250:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588866]   Object 0xf4fe9260:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588870]   Object 0xf4fe9270:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588875]   Object 0xf4fe9280:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588880]   Object 0xf4fe9290:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588884]   Object 0xf4fe92a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588889]   Object 0xf4fe92b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588894]   Object 0xf4fe92c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588898]   Object 0xf4fe92d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588903]   Object 0xf4fe92e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588908]   Object 0xf4fe92f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588912]   Object 0xf4fe9300:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588917]   Object 0xf4fe9310:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588922]   Object 0xf4fe9320:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588926]   Object 0xf4fe9330:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588931]   Object 0xf4fe9340:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588936]   Object 0xf4fe9350:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588940]   Object 0xf4fe9360:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588945]   Object 0xf4fe9370:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588950]   Object 0xf4fe9380:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588954]   Object 0xf4fe9390:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588959]   Object 0xf4fe93a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588964]   Object 0xf4fe93b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588969]   Object 0xf4fe93c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588973]   Object 0xf4fe93d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588978]   Object 0xf4fe93e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588983]   Object 0xf4fe93f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588987]   Object 0xf4fe9400:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588992]   Object 0xf4fe9410:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.588997]   Object 0xf4fe9420:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.589001]   Object 0xf4fe9430:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.589004]   Object 0xf4fe9440:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.589004]   Object 0xf4fe9450:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.589004]   Object 0xf4fe9460:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.589004]   Object 0xf4fe9470:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.589004]   Object 0xf4fe9480:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.589004]   Object 0xf4fe9490:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.589004]   Object 0xf4fe94a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    5.589004]   Object 0xf4fe94b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
[    5.589004]  Redzone 0xf4fe94c0:  bb bb bb bb
              »»»»
[    5.589004]  Padding 0xf4fe94e8:  5a 5a 5a 5a 5a 5a 5a 5a
              ZZZZZZZZ
[    5.589004] Pid: 265, comm: khubd Not tainted 2.6.31-rc1-00017-ga127d30 #2
[    5.589004] Call Trace:
[    5.589004]  [<c10a4309>] print_trailer+0xe2/0xea
[    5.589004]  [<c10a439d>] check_bytes_and_report+0x8c/0xaf
[    5.589004]  [<c10a4495>] check_object+0xa5/0x190
[    5.589004]  [<c10a59b2>] __slab_alloc+0x381/0x497
[    5.589004]  [<c10a5a2c>] ? __slab_alloc+0x3fb/0x497
[    5.589004]  [<c10a619a>] __kmalloc_track_caller+0xc4/0x141
[    5.589004]  [<c115b8d2>] ? kobject_uevent_env+0x242/0x352
[    5.589004]  [<c115b8d2>] ? kobject_uevent_env+0x242/0x352
[    5.589004]  [<c1274f62>] __alloc_skb+0x49/0x108
[    5.589004]  [<c115b8d2>] kobject_uevent_env+0x242/0x352
[    5.589004]  [<c13197ca>] ? mutex_unlock+0x8/0xa
[    5.589004]  [<c115b9ec>] kobject_uevent+0xa/0xc
[    5.589004]  [<c11d31ec>] device_add+0x32e/0x469
[    5.589004]  [<c1150030>] ? blk_start_queue+0x42/0x6f
[    5.589004]  [<c11d3339>] device_register+0x12/0x15
[    5.589004]  [<c1237742>] video_register_device_index+0x34b/0x3fa
[    5.589004]  [<c12377fb>] video_register_device+0xa/0xc
[    5.589004]  [<f932cf1d>] uvc_probe+0x956/0xa6b [uvcvideo]
[    5.589004]  [<c121d292>] usb_probe_interface+0xcc/0x11a
[    5.589004]  [<c11d4c5c>] driver_probe_device+0x79/0xed
[    5.589004]  [<c11d4d59>] __device_attach+0x2a/0x2e
[    5.589004]  [<c11d4440>] bus_for_each_drv+0x3d/0x67
[    5.589004]  [<c11d4dc3>] device_attach+0x47/0x5b
[    5.589004]  [<c11d4d2f>] ? __device_attach+0x0/0x2e
[    5.589004]  [<c11d42dd>] bus_attach_device+0x21/0x4b
[    5.589004]  [<c11d31f3>] device_add+0x335/0x469
[    5.589004]  [<c10a5d72>] ? kfree+0xa1/0xad
[    5.589004]  [<c121c19e>] ? usb_set_configuration+0x480/0x50a
[    5.589004]  [<c121c1ce>] usb_set_configuration+0x4b0/0x50a
[    5.589004]  [<c122246c>] ? usb_choose_configuration+0x123/0x172
[    5.589004]  [<c12224ff>] generic_probe+0x44/0x7d
[    5.589004]  [<c121c40a>] usb_probe_device+0x1e/0x20
[    5.589004]  [<c11d4c5c>] driver_probe_device+0x79/0xed
[    5.589004]  [<c11d4d59>] __device_attach+0x2a/0x2e
[    5.589004]  [<c11d4440>] bus_for_each_drv+0x3d/0x67
[    5.589004]  [<c11d4dc3>] device_attach+0x47/0x5b
[    5.589004]  [<c11d4d2f>] ? __device_attach+0x0/0x2e
[    5.589004]  [<c11d42dd>] bus_attach_device+0x21/0x4b
[    5.589004]  [<c11d31f3>] device_add+0x335/0x469
[    5.589004]  [<c121bd0f>] ? usb_cache_string+0xb4/0xc3
[    5.589004]  [<c1216e57>] ? usb_configure_device+0xba/0xcc
[    5.589004]  [<c1216ff1>] usb_new_device+0x52/0xa2
[    5.589004]  [<c12180e1>] hub_thread+0x7bf/0xbca
[    5.589004]  [<c1050f0d>] ? autoremove_wake_function+0x0/0x2f
[    5.589004]  [<c1032f67>] ? complete+0x34/0x3e
[    5.589004]  [<c1217922>] ? hub_thread+0x0/0xbca
[    5.589004]  [<c1050c8f>] kthread+0x66/0x6b
[    5.589004]  [<c1050c29>] ? kthread+0x0/0x6b
[    5.589004]  [<c1018b9f>] kernel_thread_helper+0x7/0x10
[    5.589004] FIX kmalloc-1024: Restoring 0xf4fe90c0-0xf4fe9103=0x6b
[    5.589004]
[    5.589004] FIX kmalloc-1024: Marking all objects used


-- 
Justin P. Mattock
