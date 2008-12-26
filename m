Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYLZQKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYLZQKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 11:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYLZQKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 11:10:24 -0500
Received: from [84.77.67.98] ([84.77.67.98]:2743 "EHLO ventoso.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbYLZQKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 11:10:23 -0500
X-Greylist: delayed 1897 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Dec 2008 11:10:23 EST
Date: Fri, 26 Dec 2008 16:38:35 +0100
From: Luca Olivetti <luca@ventoso.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.28] V4L/DVB fixes
Message-ID: <20081226163835.2595af50@noname>
In-Reply-To: <20081226110833.7e61bb20@caramujo.chehab.org>
References: <20081224121252.7560391e@caramujo.chehab.org>
	<20081225081907.GA4628@elte.hu>
	<20081225103050.GA553@elte.hu>
	<20081226110833.7e61bb20@caramujo.chehab.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.10.12; arm-unknown-linux-gnueabi)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 26 Dec 2008 11:08:33 -0200
Mauro Carvalho Chehab <mchehab@infradead.org> escribió:
> Luca,
> 
> Could you please verify this issue?

No, I don't have 2.6.28, but I guess that maybe once usb_register is
called the dvb-usb subsystem asynchronously (is that an smp system?)
starts polling the remote before the rc_decode function pointer has been
initialized.
Could you try to initialize it to NULL before calling usb_register?

Bye
Luca

> 
> Ingo,
> What .config you used to get this error?
> 
> Cheers,
> Mauro.
> 
> On Thu, 25 Dec 2008 11:30:50 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > i also needed the patch below.
> > 
> > 	Ingo
> > --------------->
> > From 62595544017bd8865adba84f7dd0796b5acc9794 Mon Sep 17 00:00:00
> > 2001 From: Ingo Molnar <mingo@elte.hu>
> > Date: Thu, 25 Dec 2008 11:27:22 +0100
> > Subject: [PATCH] dvb/usb: work around this crash for now:
> > 
> > [    8.585448] calling  opera1_module_init+0x0/0x40
> > [    8.592370] usbcore: registered new interface driver opera1
> > [    8.597879] initcall opera1_module_init+0x0/0x40 returned 0
> > after 5 msecs [    8.602341] calling
> > af9005_usb_module_init+0x0/0xb0 [    8.609143] usbcore: registered
> > new interface driver dvb_usb_af9005 [    8.613625] BUG: unable to
> > handle kernel paging request at ff100000 [    8.619858] IP:
> > [<c0c21b02>] af9005_usb_module_init+0x92/0xb0 [    8.619858] *pdpt
> > = 0000000000c6b001 *pde = 0000000000000000 [    8.623858] Oops:
> > 0000 [#1] SMP [    8.623858]
> > [    8.623858] Pid: 1, comm: swapper Not tainted
> > (2.6.26-rc6-tip-00382-g5bf10cd-dirty #8770) [    8.623858] EIP:
> > 0060:[<c0c21b02>] EFLAGS: 00010286 CPU: 1 [    8.623858] EIP is at
> > af9005_usb_module_init+0x92/0xb0 [    8.623858] EAX: ff100000 EBX:
> > 00000000 ECX: 00000000 EDX: f6c55ee8 [    8.623858] ESI: 00000000
> > EDI: 00000000 EBP: f6c55f60 ESP: f6c55f54 [    8.623858]  DS: 007b
> > ES: 007b FS: 00d8 GS: 0000 SS: 0068 [    8.623858] Process swapper
> > (pid: 1, ti=f6c54000 task=f6c538a0 task.ti=f6c54000) [    8.623858]
> > Stack: 00000005 00000000 00000005 f6c55fe0 c0bef7f4 c0a2e531
> > 00000000 00000005 [    8.623858]        00000000 f6c54000 00d25d95
> > 00000002 c0c50d8c c0c21a70 00000000 6f727200 [    8.623858]
> > 6f632072 2d206564 00203232 f6c53490 f6c55fac c0125568 f6c57fc0
> > c0103c66 [    8.623858] Call Trace: [    8.623858]  [<c0bef7f4>] ?
> > kernel_init+0x1a4/0x2b0 [    8.623858]  [<c0c21a70>] ?
> > af9005_usb_module_init+0x0/0xb0 [    8.623858]  [<c0125568>] ?
> > schedule_tail+0x18/0x50 [    8.623858]  [<c0103c66>] ?
> > ret_from_fork+0x6/0x20 [    8.623858]  [<c0bef650>] ?
> > kernel_init+0x0/0x2b0 [    8.623858]  [<c0bef650>] ?
> > kernel_init+0x0/0x2b0 [    8.623858]  [<c0104fa7>] ?
> > kernel_thread_helper+0x7/0x10 [    8.623858]
> > ======================= [    8.623858] Code: c3 89 44 24 04 c7 04
> > 24 60 72 ae c0 e8 28 8e 50 ff 89 d8 83 c4 08 5b 5d c3 b8 00 00 10
> > ff 85 c0 74 c1 b8 00 00 10 ff 85 c0 74 b8 <a1> 00 00 10 ff c7 05 b4
> > 96 b9 c0 00 00 10 ff a3 b8 96 b9 c0 eb [    8.635859] EIP:
> > [<c0c21b02>] af9005_usb_module_init+0x92/0xb0 SS:ESP 0068:f6c55f54
> > [    8.635859] Kernel panic - not syncing: Fatal exception
> > [    8.635859] Pid: 1, comm: swapper Tainted: G      D
> > 2.6.26-rc6-tip-00382-g5bf10cd-dirty #8770 [    8.635859]
> > [<c0129cfb>] panic+0x4b/0x110 [    8.635859]  [<c01059b5>]
> > die+0x115/0x180 [    8.635859]  [<c0118cfc>]
> > do_page_fault+0x2ac/0x880 [    8.635859]  [<c01d5abb>] ?
> > sysfs_addrm_finish+0x1b/0x1c0 [    8.635859]  [<c0118a50>] ?
> > do_page_fault+0x0/0x880 [    8.635859]  [<c08d1212>]
> > error_code+0x72/0x80 [    8.635859]  [<c0c21b02>] ?
> > af9005_usb_module_init+0x92/0xb0 [    8.635859]  [<c0bef7f4>]
> > kernel_init+0x1a4/0x2b0 [    8.635859]  [<c0c21a70>] ?
> > af9005_usb_module_init+0x0/0xb0 [    8.635859]  [<c0125568>] ?
> > schedule_tail+0x18/0x50 [    8.635859]  [<c0103c66>] ?
> > ret_from_fork+0x6/0x20
> > 
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  drivers/media/dvb/dvb-usb/Kconfig |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/dvb/dvb-usb/Kconfig
> > b/drivers/media/dvb/dvb-usb/Kconfig index 1d1b3c2..448d42b 100644
> > --- a/drivers/media/dvb/dvb-usb/Kconfig
> > +++ b/drivers/media/dvb/dvb-usb/Kconfig
> > @@ -236,6 +236,7 @@ config DVB_USB_OPERA1
> >  config DVB_USB_AF9005
> >  	tristate "Afatech AF9005 DVB-T USB1.1 support"
> >  	depends on DVB_USB && EXPERIMENTAL
> > +	depends on BROKEN
> >  	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMIZE
> >  	select MEDIA_TUNER_QT1010 if !MEDIA_TUNER_CUSTOMIZE
> >  	help
> 
> 
> 
> 
> Cheers,
> Mauro

