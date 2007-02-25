Return-Path: <linux-kernel-owner+w=401wt.eu-S932518AbXBYIcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbXBYIcF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 03:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932956AbXBYIcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 03:32:05 -0500
Received: from mail.gmx.net ([213.165.64.20]:45079 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932518AbXBYIcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 03:32:04 -0500
X-Provags-ID: V01U2FsdGVkX1/H6BllXx/HZEWZZmqyJCxA49V5UTM55tVmvu75dz
	wk/A==
Subject: [patch] Re: linux-2.6.today: rtc_cmos init oops/panic in
	rtc_sysfs_remove_device()
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>, a.zummo@towertech.it
In-Reply-To: <1171967177.6939.10.camel@Homer.simpson.net>
References: <1171967177.6939.10.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Sun, 25 Feb 2007 09:31:53 +0100
Message-Id: <1172392313.6888.23.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-20 at 11:26 +0100, Mike Galbraith wrote:
> Kernel I captured this from is dirty, but virgin source does exactly the
> same.  gzipped config attached.
> 
> 
> [   32.211999] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> [   32.227226] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000018
> [   32.245198]  printing eip:
> [   32.257172] c03c7cc8
> [   32.268434] *pde = 00000000
> [   32.280222] Oops: 0000 [#1]
> [   32.291997] PREEMPT SMP 
> [   32.303352] Modules linked in:
> [   32.315009] CPU:    0
> [   32.315010] EIP:    0060:[<c03c7cc8>]    Not tainted VLI
> [   32.315011] EFLAGS: 00010202   (2.6.20-smp-g575d5e72-dirty #25)
> [   32.353865] EIP is at rtc_sysfs_remove_device+0x18/0x4b
> [   32.367596] eax: 00000000   ebx: dfef0454   ecx: c03c7cb0   edx: c064212c
> [   32.383044] esi: dfef0454   edi: c19c5f00   ebp: c18ede3c   esp: c18ede38
> [   32.398590] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> [   32.413219] Process swapper (pid: 1, ti=c18ed000 task=c18eca50 task.ti=c18ed000)
> [   32.420821] Stack: c064212c c18ede5c c0350b5e c19c5e74 00000000 c19c5f08 dfef0454 dfef050c 
> [   32.438377]        c1997244 c18ede68 c0350c21 dfef0454 c18ede78 c03c752f fffffff0 c199741c 
> [   32.456025]        c18edea8 c03c931d 00000000 00000020 00000004 c04f8c60 00000008 00000000 
> [   32.473692] Call Trace:
> [   32.493941]  [<c0105146>] show_trace_log_lvl+0x1a/0x30
> [   32.508144]  [<c0105201>] show_stack_log_lvl+0xa5/0xca
> [   32.522210]  [<c0105422>] show_registers+0x1fc/0x341
> [   32.536006]  [<c0105683>] die+0x11c/0x22b
> [   32.548692]  [<c011cb3b>] do_page_fault+0x160/0x575
> [   32.562185]  [<c04cea7c>] error_code+0x7c/0x84
> [   32.575029]  [<c0350b5e>] class_device_del+0x72/0x12a
> [   32.588332]  [<c0350c21>] class_device_unregister+0xb/0x15
> [   32.601816]  [<c03c752f>] rtc_device_unregister+0x2c/0x30
> [   32.615146]  [<c03c931d>] cmos_pnp_probe+0x147/0x1ee
> [   32.627927]  [<c03200fc>] pnp_device_probe+0x4c/0xa0
> [   32.640614]  [<c03501f3>] really_probe+0x5c/0x163
> [   32.652999]  [<c0350397>] driver_probe_device+0x9d/0xa9
> [   32.665800]  [<c03504bc>] __driver_attach+0x84/0x86
> [   32.678364]  [<c034f7e3>] bus_for_each_dev+0x44/0x62
> [   32.690966]  [<c03500bf>] driver_attach+0x19/0x1b
> [   32.703177]  [<c034fb0a>] bus_add_driver+0x6a/0x185
> [   32.715467]  [<c0350659>] driver_register+0x54/0x84
> [   32.727547]  [<c031fef1>] pnp_register_driver+0x17/0x19
> [   32.739810]  [<c067f648>] cmos_init+0xd/0xf
> [   32.751078]  [<c066358c>] init+0x114/0x23c
> [   32.762285]  [<c0104dbb>] kernel_thread_helper+0x7/0x1c
> [   32.774782]  =======================
> [   32.785651] Code: 8b 45 f0 e8 0a 5a 10 00 89 f8 83 c4 04 5b 5e 5f 5d c3 90 55 89 e5 53 89 c3 8b 40 6c f6 80 2c 01 00 00 01 74 0d 8b 83 b4 00 00 00 <8b> 40 18 85 c0 75 10 8d 43 08 ba 48 21 64 c0 e8 75 e4 de ff 5b 
> [   32.830191] EIP: [<c03c7cc8>] rtc_sysfs_remove_device+0x18/0x4b SS:ESP 0068:c18ede38
> [   32.846381] Kernel panic - not syncing: Attempted to kill init!

I took a look at it this morning.  If CONFIG_PNPACPI is set, and
request_resource() fails in cmos_do_probe(), rtc_does_wakealarm()
dereferences rtc->ops which we NULLed in rtc_device_unregister().

Fix NULL pointer dereference in cmos_rtc registration failure path.

Signed-off-by: Mike Galbraith <efault@gmx.de>

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 7a0d8ee..9201786 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -113,10 +113,10 @@ EXPORT_SYMBOL_GPL(rtc_device_register);
  */
 void rtc_device_unregister(struct rtc_device *rtc)
 {
+	class_device_unregister(&rtc->class_dev);
 	mutex_lock(&rtc->ops_lock);
 	rtc->ops = NULL;
 	mutex_unlock(&rtc->ops_lock);
-	class_device_unregister(&rtc->class_dev);
 }
 EXPORT_SYMBOL_GPL(rtc_device_unregister);
 


