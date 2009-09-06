Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbZIFNce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbZIFNce (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 09:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757745AbZIFNcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 09:32:31 -0400
Received: from ns.penguin.cz ([84.21.108.25]:53088 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757587AbZIFNc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 09:32:29 -0400
Subject: Re: zaurus c3000 aka spitz: fix resume
From: Stanislav Brabec <utx@penguin.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <20090906052840.GF1324@ucw.cz>
References: <20090906052840.GF1324@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 06 Sep 2009 15:32:18 +0200
Message-Id: <1252243938.4136.26.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> sharpsl_pm.c code tries to read battery state very early during
> resume, but those battery meters are connected on SPI and that's only
> resumed way later.
> 
> Replace the check with simple checking of battery fatal signal, that
> actually works at this stage.

Tested on:
- SL-C3200
- snapshot e07cccf4046978df10f2e13fe2b99b2f9b3a65db
- Reverted: 15bce40cb3133bcc07d548013df97e4653d363c1 (manual merge)
- Applied your patch.
- Config is here:
  http://www.penguin.cz/~utx/zaurus/feed/images/spitz/config-2.6.31-rc9-spitz

Here is a big progress:
- Zaurus goes from resume.

But some of symptoms are still not fixed:
- SPI errors on suspend
- serial does not work after resume

Here is suspend log with the no_console_suspend

apm-power: Requesting system suspend...
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.03 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
max1111 spi2.2: spi_sync failed with -108
max1111 spi2.2: spi_sync failed with -108
max1111 spi2.2: spi_sync failed with -108
max1111 spi2.2: spi_sync failed with -108
max1111 spi2.2: spi_sync failed with -108
sharpsl-pm sharpsl-pm: Error: AC check failed.
sharpsl-pm sharpsl-pm: Offline Charger: Error occurred.
sharpsl

Here the console went forever to sleep.

Unrelated problems:
﻿Angstrom did not gave me a login prompts. Removing of speech-dispatcher
and usb-gadget from the init scripts works-around this problem.

Stopping speech-dispatcher shows:
pxa_free_dma: trying to free channel 0 which is already freed


And next suspend attempt failed:

apm-power: Requesting system suspend...
PM: Syncing filesystems ... done.
pcmcia_socket pcmcia_socket1: pccard: card ejected from slot 1
attempt to access beyond end of device
hda1: rw=0, want=30282907696, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=30282940472, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=31675366312, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=31675366312, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=7320168, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=5767320, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=6353032, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=5767448, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=5767320, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=3001032, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=5767320, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=6959176, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=5767320, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=31675377560, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=30375411720, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=1342178056, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=30849204232, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=30510940168, limit=1954449
Alignment trap: hald-runner (1130) PC=0x400825f4 Instr=0xe5933000 Address=0x73796d61 FSR 0x0f3
attempt to access beyond end of device
hda1: rw=0, want=2365751368, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=2634252296, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=2365915200, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=2097160, limit=1954449
attempt to access beyond end of device
attempt to access beyond end of device
hda1: rw=0, want=1800095912, limit=1954449
hda1: rw=0, want=2365882456, limit=1954449
attempt to access beyond end of device
attempt to access beyond end of device
hda1: rw=0, want=2097160, limit=1954449
hda1: rw=0, want=3489661464, limit=1954449
attempt to access beyond end of device
attempt to access beyond end of device
hda1: rw=0, want=1800095912, limit=1954449
hda1: rw=0, want=31406949088, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=30864408592, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=30510940240, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=2593653000, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=1476394976, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=30510940168, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=1342177800, limit=1954449
attempt to access beyond end of device
Alignment trap: hald-addon-gene (1135) PC=0x400ce5f4 Instr=0xe5933000 Address=0x726b4f27 FSR 0x0f3
hda1: rw=0, want=30847664136, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=30511464712, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=2594177104, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=1800095912, limit=1954449
Freezing user space processes ... 
Freezing of tasks failed after 20.00 seconds (1 tasks refusing to freeze):
  task                PC stack   pid father
init          D c026b8e4     0     1      0 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
kthreadd      S c026b8e4     0     2      0 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c00544b8>] (kthreadd+0x78/0x138)
[<c00544b8>] (kthreadd+0x78/0x138) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
ksoftirqd/0   S c026b8e4     0     3      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c0041d68>] (ksoftirqd+0x60/0x160)
[<c0041d68>] (ksoftirqd+0x60/0x160) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
events/0      R running      0     4      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c004fef4>] (worker_thread+0xc4/0x2d4)
[<c004fef4>] (worker_thread+0xc4/0x2d4) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
khelper       S c026b8e4     0     5      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c004fef4>] (worker_thread+0xc4/0x2d4)
[<c004fef4>] (worker_thread+0xc4/0x2d4) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
async/mgr     S c026b8e4     0    10      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005b290>] (async_manager_thread+0xc8/0x104)
[<c005b290>] (async_manager_thread+0xc8/0x104) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
kblockd/0     S c026b8e4     0    99      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c004fef4>] (worker_thread+0xc4/0x2d4)
[<c004fef4>] (worker_thread+0xc4/0x2d4) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
kseriod       S c026b8e4     0   104      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c01d9924>] (serio_thread+0x370/0x40c)
[<c01d9924>] (serio_thread+0x370/0x40c) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
kmmcd         S c026b8e4     0   110      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c004fef4>] (worker_thread+0xc4/0x2d4)
[<c004fef4>] (worker_thread+0xc4/0x2d4) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
pccardd       S c026b8e4     0   130      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c01cefe8>] (pccardd+0x234/0x288)
[<c01cefe8>] (pccardd+0x234/0x288) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
pccardd       S c026b8e4     0   132      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c01cefe8>] (pccardd+0x234/0x288)
[<c01cefe8>] (pccardd+0x234/0x288) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
pdflush       S c026b8e4     0   142      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c0090d44>] (pdflush+0x10c/0x2dc)
[<c0090d44>] (pdflush+0x10c/0x2dc) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
pdflush       S c026b8e4     0   143      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c0090d44>] (pdflush+0x10c/0x2dc)
[<c0090d44>] (pdflush+0x10c/0x2dc) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
kswapd0       S c026b8e4     0   144      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c0095e00>] (kswapd+0xf8/0x590)
[<c0095e00>] (kswapd+0xf8/0x590) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
aio/0         S c026b8e4     0   145      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c004fef4>] (worker_thread+0xc4/0x2d4)
[<c004fef4>] (worker_thread+0xc4/0x2d4) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
kapmd         R running      0   226      2 0x00000002
[<c0025d68>] (unwind_backtrace+0x0/0xdc) from [<c0024e7c>] (show_stack+0x18/0x1c)
[<c0024e7c>] (show_stack+0x18/0x1c) from [<c0031860>] (sched_show_task+0xac/0xc8)
[<c0031860>] (sched_show_task+0xac/0xc8) from [<c0036268>] (show_state_filter+0x58/0xb8)
[<c0036268>] (show_state_filter+0x58/0xb8) from [<c006c190>] (try_to_freeze_tasks+0x1d0/0x308)
[<c006c190>] (try_to_freeze_tasks+0x1d0/0x308) from [<c006c2e8>] (freeze_processes+0x20/0xb8)
[<c006c2e8>] (freeze_processes+0x20/0xb8) from [<c006c628>] (enter_state+0x88/0xf4)
[<c006c628>] (enter_state+0x88/0xf4) from [<c006c6b8>] (pm_suspend+0x24/0x28)
[<c006c6b8>] (pm_suspend+0x24/0x28) from [<c01a46d8>] (kapmd+0x170/0x1d4)
[<c01a46d8>] (kapmd+0x170/0x1d4) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
mtdblockd     S c026b8e4     0   252      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c01c3f40>] (mtd_blktrans_thread+0xa4/0x360)
[<c01c3f40>] (mtd_blktrans_thread+0xa4/0x360) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
pxa2xx-spi.2  S c026b8e4     0   265      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c004fef4>] (worker_thread+0xc4/0x2d4)
[<c004fef4>] (worker_thread+0xc4/0x2d4) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
kjournald     S c026b8e4     0   302      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c0124ed4>] (kjournald+0x1e0/0x288)
[<c0124ed4>] (kjournald+0x1e0/0x288) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
udevd         D c026b8e4     0   343      1 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
ksuspend_usbd S c026b8e4     0   740      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c004fef4>] (worker_thread+0xc4/0x2d4)
[<c004fef4>] (worker_thread+0xc4/0x2d4) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
khubd         S c026b8e4     0   741      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<bf004cb8>] (hub_thread+0xf44/0x1048 [usbcore])
[<bf004cb8>] (hub_thread+0xf44/0x1048 [usbcore]) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
bluetooth     S c026b8e4     0   905      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c004fef4>] (worker_thread+0xc4/0x2d4)
[<c004fef4>] (worker_thread+0xc4/0x2d4) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
krfcommd      S c026b8e4     0   951      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<bf0c17a8>] (rfcomm_run+0x1a8/0x14dc [rfcomm])
[<bf0c17a8>] (rfcomm_run+0x1a8/0x14dc [rfcomm]) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
kjournald     S c026b8e4     0  1001      2 0x00000000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c0124ed4>] (kjournald+0x1e0/0x288)
[<c0124ed4>] (kjournald+0x1e0/0x288) from [<c00545fc>] (kthread+0x84/0x8c)
[<c00545fc>] (kthread+0x84/0x8c) from [<c00219c4>] (kernel_thread_exit+0x0/0x8)
portmap       D c026b8e4     0  1090      1 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
hald-addon-in D c026b8e4     0  1134      1 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
dropbear      D c026b8e4     0  1160      1 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
apmd          D c026b8e4     0  1165      1 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
syslogd       D c026b8e4     0  1177      1 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
klogd         D c026b8e4     0  1179      1 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
wwwoffled     D c026b8e4     0  1185      1 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
gpe-dm        D c026b8e4     0  1281      1 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
Xfbdev        D c026b8e4     0  1284   1281 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
run-parts     D c026b8e4     0  1285   1281 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
switchevd     D c026b8e4     0  1316      1 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
bash          D c026b8e4     0  1320      1 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
getty         D c026b8e4     0  1321      1 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
session       D c026b8e4     0  1403   1285 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
dbus-launch   D c026b8e4     0  1478      1 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
dbus-daemon   D c026b8e4     0  1479      1 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
gconfd-2      D c026b8e4     0  1488   1403 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
gpe-confd     D c026b8e4     0  1492   1403 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
ipaq-sleep    D c026b8e4     0  1497      1 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
keylaunch     D c026b8e4     0  1511   1403 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
matchbox-pane D c026b8e4     0  1519   1403 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
matchbox-desk D c026b8e4     0  1521   1403 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
matchbox-wind D c026b8e4     0  1525   1403 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
sleep         D c026b8e4     0  1527   1403 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
gnome-keyring D c026b8e4     0  1528      1 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
vte           D c026b8e4     0  1597   1519 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
gnome-pty-hel D c026b8e4     0  1598   1597 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
bash          D c026b8e4     0  1599   1597 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
apmd_proxy    D c026b8e4     0  1604   1165 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
run-parts     D c026b8e4     0  1606   1604 0x00020000
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c005c4c8>] (refrigerator+0x144/0x16c)
[<c005c4c8>] (refrigerator+0x144/0x16c) from [<c002327c>] (do_signal+0x48/0x500)
[<c002327c>] (do_signal+0x48/0x500) from [<c0023760>] (do_notify_resume+0x2c/0x30)
[<c0023760>] (do_notify_resume+0x2c/0x30) from [<c0020fcc>] (work_pending+0x1c/0x20)
pcmcia        D c026b8e4     0  1609   1606 0x000a0001
[<c026b8e4>] (schedule+0x4d4/0x57c) from [<c026bfac>] (schedule_timeout+0x20/0x19c)
[<c026bfac>] (schedule_timeout+0x20/0x19c) from [<c026be04>] (wait_for_common+0x100/0x1cc)
[<c026be04>] (wait_for_common+0x100/0x1cc) from [<c026bf60>] (wait_for_completion+0x18/0x1c)
[<c026bf60>] (wait_for_completion+0x18/0x1c) from [<c01b7a3c>] (__ide_port_unregister_devices+0x3c/0x58)
[<c01b7a3c>] (__ide_port_unregister_devices+0x3c/0x58) from [<c01b7c1c>] (ide_host_remove+0x64/0xf0)
[<c01b7c1c>] (ide_host_remove+0x64/0xf0) from [<c01bf2e4>] (ide_release+0x24/0x38)
[<c01bf2e4>] (ide_release+0x24/0x38) from [<c01bf320>] (ide_detach+0x28/0x58)
[<c01bf320>] (ide_detach+0x28/0x58) from [<c01d2bb8>] (pcmcia_device_remove+0x78/0x108)
[<c01d2bb8>] (pcmcia_device_remove+0x78/0x108) from [<c01ac79c>] (__device_release_driver+0x88/0xcc)
[<c01ac79c>] (__device_release_driver+0x88/0xcc) from [<c01ac8f0>] (device_release_driver+0x24/0x30)
[<c01ac8f0>] (device_release_driver+0x24/0x30) from [<c01abcd0>] (bus_remove_device+0xa8/0xc8)
[<c01abcd0>] (bus_remove_device+0xa8/0xc8) from [<c01a9f48>] (device_del+0x12c/0x1b0)
[<c01a9f48>] (device_del+0x12c/0x1b0) from [<c01a9fe4>] (device_unregister+0x18/0x24)
[<c01a9fe4>] (device_unregister+0x18/0x24) from [<c01d2458>] (pcmcia_card_remove+0xac/0xd0)
[<c01d2458>] (pcmcia_card_remove+0xac/0xd0) from [<c01d3b5c>] (ds_event+0x7c/0xb4)
[<c01d3b5c>] (ds_event+0x7c/0xb4) from [<c01ce194>] (send_event+0xc4/0xe4)
[<c01ce194>] (send_event+0xc4/0xe4) from [<c01ce42c>] (socket_shutdown+0x20/0x11c)
[<c01ce42c>] (socket_shutdown+0x20/0x11c) from [<c01ce6fc>] (socket_remove+0x38/0x40)
[<c01ce6fc>] (socket_remove+0x38/0x40) from [<c01ce758>] (pcmcia_eject_card+0x54/0x64)
[<c01ce758>] (pcmcia_eject_card+0x54/0x64) from [<c01d1894>] (pccard_store_eject+0x28/0x34)
[<c01d1894>] (pccard_store_eject+0x28/0x34) from [<c01a8e1c>] (dev_attr_store+0x28/0x2c)
[<c01a8e1c>] (dev_attr_store+0x28/0x2c) from [<c01016c4>] (sysfs_write_file+0x110/0x148)
[<c01016c4>] (sysfs_write_file+0x110/0x148) from [<c00b5b14>] (vfs_write+0xb4/0x160)
[<c00b5b14>] (vfs_write+0xb4/0x160) from [<c00b5c84>] (sys_write+0x44/0x70)
[<c00b5c84>] (sys_write+0x44/0x70) from [<c0020f80>] (ret_fast_syscall+0x0/0x2c)
Sched Debug Version: v0.09, 2.6.31-rc9 #3
now at 553178.819399 msecs
  .jiffies                                 : 25320
  .sysctl_sched_latency                    : 20.000000
  .sysctl_sched_min_granularity            : 4.000000
  .sysctl_sched_wakeup_granularity         : 5.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 113917

cpu#0
  .nr_running                    : 3
  .load                          : 7266
  .nr_switches                   : 111444
  .nr_load_updates               : 25380
  .nr_uninterruptible            : 1
  .next_balance                  : 0.000000
  .curr->pid                     : 226
  .clock                         : 1028970.602044
  .cpu_load[0]                   : 7266
  .cpu_load[1]                   : 7266
  .cpu_load[2]                   : 7266
  .cpu_load[3]                   : 7266
  .cpu_load[4]                   : 7266
  .yld_count                     : 2526983
  .sched_switch                  : 0
  .sched_count                   : 2638808
  .sched_goidle                  : 27550
  .ttwu_count                    : 0
  .ttwu_local                    : 0
  .bkl_count                     : 492

cfs_rq[0]:
  .exec_clock                    : 188168.867221
  .MIN_vruntime                  : 98644.108327
  .min_vruntime                  : 98664.108327
  .max_vruntime                  : 98644.108327
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 3
  .load                          : 7266
  .nr_spread_over                : 4

rt_rq[0]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
        events/0     4     98644.108327      1512   115     98644.108327       890.996744    543628.799346
         pdflush   143     98644.108327       124   120     98644.108327       113.115050    549273.432945
R          kapmd   226    100633.289222       138   115    100633.289222     26232.675450    526194.720872

 pcmcia

Restarting tasks ... 
attempt to access beyond end of device
hda1: rw=0, want=6938824, limit=1954449
attempt to access beyond end of device
done.
hda1: rw=0, want=5767448, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=5827368, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=5767320, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=9898824, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=16777360, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=6382152, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=5767320, limit=1954449
attempt to access beyond end of device
hda1: rw=0, want=5959752, limit=1954449




________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx

