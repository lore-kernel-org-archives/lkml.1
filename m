Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbYLYKbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbYLYKbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 05:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYLYKbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 05:31:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59395 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbYLYKbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 05:31:14 -0500
Date: Thu, 25 Dec 2008 11:30:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.28] V4L/DVB fixes
Message-ID: <20081225103050.GA553@elte.hu>
References: <20081224121252.7560391e@caramujo.chehab.org> <20081225081907.GA4628@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225081907.GA4628@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> 
> > For a few last time driver fixes:
> > 
> >    - drivers/media Kconfig fix (bugzilla #12204)
> 
> FYI, v2.6.28 still fails to build with certain configs:
> 
>  drivers/media/dvb/built-in.o: In function `dib7000p_set_gpio':
>  (.text+0x3f242): multiple definition of `dib7000p_set_gpio'
>  drivers/media/video/built-in.o:(.text+0xb8c1e): first defined here
>  drivers/media/dvb/built-in.o: In function `dib7000p_i2c_enumeration':
>  (.text+0x3f282): multiple definition of `dib7000p_i2c_enumeration'
>  drivers/media/video/built-in.o:(.text+0xb8c3e): first defined here
>  drivers/media/dvb/built-in.o: In function `dib7000p_set_wbd_ref':
>  (.text+0x3f1c1): multiple definition of `dib7000p_set_wbd_ref'
>  drivers/media/video/built-in.o:(.text+0xb8bfe): first defined here
>    LD      drivers/net/built-in.o
>  make[2]: *** [drivers/media/built-in.o] Error 1
> 
> Config attached. The patch below works it around in tip/master. Can test 
> any patch for this bug.

Correction: i also needed the patch below.

	Ingo

--------------->
>From 62595544017bd8865adba84f7dd0796b5acc9794 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 25 Dec 2008 11:27:22 +0100
Subject: [PATCH] dvb/usb: work around this crash for now:

[    8.585448] calling  opera1_module_init+0x0/0x40
[    8.592370] usbcore: registered new interface driver opera1
[    8.597879] initcall opera1_module_init+0x0/0x40 returned 0 after 5 msecs
[    8.602341] calling  af9005_usb_module_init+0x0/0xb0
[    8.609143] usbcore: registered new interface driver dvb_usb_af9005
[    8.613625] BUG: unable to handle kernel paging request at ff100000
[    8.619858] IP: [<c0c21b02>] af9005_usb_module_init+0x92/0xb0
[    8.619858] *pdpt = 0000000000c6b001 *pde = 0000000000000000
[    8.623858] Oops: 0000 [#1] SMP
[    8.623858]
[    8.623858] Pid: 1, comm: swapper Not tainted (2.6.26-rc6-tip-00382-g5bf10cd-dirty #8770)
[    8.623858] EIP: 0060:[<c0c21b02>] EFLAGS: 00010286 CPU: 1
[    8.623858] EIP is at af9005_usb_module_init+0x92/0xb0
[    8.623858] EAX: ff100000 EBX: 00000000 ECX: 00000000 EDX: f6c55ee8
[    8.623858] ESI: 00000000 EDI: 00000000 EBP: f6c55f60 ESP: f6c55f54
[    8.623858]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    8.623858] Process swapper (pid: 1, ti=f6c54000 task=f6c538a0 task.ti=f6c54000)
[    8.623858] Stack: 00000005 00000000 00000005 f6c55fe0 c0bef7f4 c0a2e531 00000000 00000005
[    8.623858]        00000000 f6c54000 00d25d95 00000002 c0c50d8c c0c21a70 00000000 6f727200
[    8.623858]        6f632072 2d206564 00203232 f6c53490 f6c55fac c0125568 f6c57fc0 c0103c66
[    8.623858] Call Trace:
[    8.623858]  [<c0bef7f4>] ? kernel_init+0x1a4/0x2b0
[    8.623858]  [<c0c21a70>] ? af9005_usb_module_init+0x0/0xb0
[    8.623858]  [<c0125568>] ? schedule_tail+0x18/0x50
[    8.623858]  [<c0103c66>] ? ret_from_fork+0x6/0x20
[    8.623858]  [<c0bef650>] ? kernel_init+0x0/0x2b0
[    8.623858]  [<c0bef650>] ? kernel_init+0x0/0x2b0
[    8.623858]  [<c0104fa7>] ? kernel_thread_helper+0x7/0x10
[    8.623858]  =======================
[    8.623858] Code: c3 89 44 24 04 c7 04 24 60 72 ae c0 e8 28 8e 50 ff 89 d8 83 c4 08 5b 5d c3 b8 00 00 10 ff 85 c0 74 c1 b8 00 00 10 ff 85 c0 74 b8 <a1> 00 00 10 ff c7 05 b4 96 b9 c0 00 00 10 ff a3 b8 96 b9 c0 eb
[    8.635859] EIP: [<c0c21b02>] af9005_usb_module_init+0x92/0xb0 SS:ESP 0068:f6c55f54
[    8.635859] Kernel panic - not syncing: Fatal exception
[    8.635859] Pid: 1, comm: swapper Tainted: G      D   2.6.26-rc6-tip-00382-g5bf10cd-dirty #8770
[    8.635859]  [<c0129cfb>] panic+0x4b/0x110
[    8.635859]  [<c01059b5>] die+0x115/0x180
[    8.635859]  [<c0118cfc>] do_page_fault+0x2ac/0x880
[    8.635859]  [<c01d5abb>] ? sysfs_addrm_finish+0x1b/0x1c0
[    8.635859]  [<c0118a50>] ? do_page_fault+0x0/0x880
[    8.635859]  [<c08d1212>] error_code+0x72/0x80
[    8.635859]  [<c0c21b02>] ? af9005_usb_module_init+0x92/0xb0
[    8.635859]  [<c0bef7f4>] kernel_init+0x1a4/0x2b0
[    8.635859]  [<c0c21a70>] ? af9005_usb_module_init+0x0/0xb0
[    8.635859]  [<c0125568>] ? schedule_tail+0x18/0x50
[    8.635859]  [<c0103c66>] ? ret_from_fork+0x6/0x20

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/dvb/dvb-usb/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index 1d1b3c2..448d42b 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -236,6 +236,7 @@ config DVB_USB_OPERA1
 config DVB_USB_AF9005
 	tristate "Afatech AF9005 DVB-T USB1.1 support"
 	depends on DVB_USB && EXPERIMENTAL
+	depends on BROKEN
 	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMIZE
 	select MEDIA_TUNER_QT1010 if !MEDIA_TUNER_CUSTOMIZE
 	help
