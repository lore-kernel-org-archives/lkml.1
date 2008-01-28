Return-Path: <linux-kernel-owner+w=401wt.eu-S1762645AbYA1TQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762645AbYA1TQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762825AbYA1TMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:12:31 -0500
Received: from ns2.suse.de ([195.135.220.15]:53098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762818AbYA1TMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:12:30 -0500
Subject: Re: [PATCH] Allocate pnp resources dynamically via
	krealloc	-	working version - Addon patch 3
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, Jaroslav Kysela <perex@perex.cz>
In-Reply-To: <479E19C9.7020201@keyaccess.nl>
References: <1200772810.3708.42.camel@queen>
	 <84144f020801191623i2ad344a8t1c40969578793d13@mail.gmail.com>
	 <1201109917.20940.214.camel@queen.suse.de> <479CD935.3070906@keyaccess.nl>
	 <1201530103.20940.413.camel@queen.suse.de> <479DEE10.6060203@keyaccess.nl>
	 <1201536284.20940.424.camel@queen.suse.de>  <479E19C9.7020201@keyaccess.nl>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Mon, 28 Jan 2008 20:12:27 +0100
Message-Id: <1201547548.20940.435.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-28 at 19:07 +0100, Rene Herman wrote:
> On 28-01-08 17:04, Thomas Renninger wrote:
> 
> > Can you try these two "on top" patches pls.
> 
> Thought I could, but my machine begs to differ...
> 
> ===
> pnp: the driver 'cs4236_isapnp' has been registered
> cs4236_isapnp 01:01.00: driver attached
> cs4236_isapnp 01:01.02: driver attached
> cs4236_isapnp 01:01.03: driver attached
> BUG: unable to handle kernel NULL pointer dereference at virtual address 
> 0000000f
> printing eip: c10e5136 *pde = 00000000
> Oops: 0000 [#1] PREEMPT
> Modules linked in: snd_cs4236 snd_opl3_lib snd_hwdep snd_cs4236_lib 
> snd_mpu401_uart snd_rawmidi snd_seq_device snd_cs4231_lib snd_pcm snd_timer 
> snd_page_alloc snd soundcore nfsd lockd nfs_acl sunrpc exportfs
> 
> Pid: 1370, comm: modprobe Not tainted (2.6.24-local #5)
> EIP: 0060:[<c10e5136>] EFLAGS: 00010246 CPU: 0
> EIP is at pnp_assign_port+0x1d/0xd5
> EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000001
> ESI: ef8fe100 EDI: ef8f5800 EBP: 00000000 ESP: ed3b4e08
>   DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process modprobe (pid: 1370, ti=ed3b4000 task=ed35c000 task.ti=ed3b4000)
> Stack: ed3b4e34 c108ac94 ed3b4e34 ed3c1b10 00000000 efa4e360 c108b88b ef8fe100
>         00000000 ef8f5800 ef82ee40 c10e5360 00000001 ef8f5964 00000000 00000000
>         00000000 00000000 00000000 ef805ea0 ef8f5800 ef863c80 00000001 ed373400
> Call Trace:
>   [<c108ac94>] sysfs_addrm_start+0x36/0x81
>   [<c108b88b>] sysfs_create_link+0xd0/0x111
>   [<c10e5360>] pnp_assign_resources+0x172/0x23a
>   [<c10e548f>] pnp_auto_config_dev+0x67/0xa6
>   [<c10e373a>] pnp_request_card_device+0x9b/0xbe
>   [<c10e54e1>] pnp_activate_dev+0x13/0x3a
>   [<f0a4b559>] snd_cs423x_pnpc_detect+0xe4/0x35f [snd_cs4236]
>   [<c10e330d>] pnp_alloc+0xe/0x25
>   [<c10e3652>] card_probe+0xba/0x107
>   [<c10e3b75>] pnp_register_card_driver+0xa3/0xb3
>   [<f08de02f>] alsa_card_cs423x_init+0x2f/0x4f [snd_cs4236]
>   [<c103258a>] sys_init_module+0x1379/0x149b
>   [<c104773a>] unmap_region+0xe5/0x100
>   [<c1003d62>] syscall_call+0x7/0xb
>   =======================
> Code: ba 01 00 00 00 83 c4 1c 89 d0 5b 5e 5f c3 55 89 cd 57 89 c7 56 89 d6 
> ba 01 00 00 00 53 6b d9 1c 83 ec 1c 89 d8 03 87 64 01 00 00 <f6> 40 0f 40 0f 
> 84 a4 00 00 00 8b 00 8b 97 64 01 00 00 0f b6 4e
> EIP: [<c10e5136>] pnp_assign_port+0x1d/0xd5 SS:ESP 0068:ed3b4e08
> ---[ end trace d756fac577a9260d ]---
This was more a step backward, hopefully this one (on top), gets the
area bugfree?

Differ already accessed and newly set resource options

Signed-off-by: Thomas Renninger <trenn@suse.de>


---
 drivers/pnp/manager.c |   49 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

Index: linux-2.6.23/drivers/pnp/manager.c
===================================================================
--- linux-2.6.23.orig/drivers/pnp/manager.c
+++ linux-2.6.23/drivers/pnp/manager.c
@@ -344,12 +344,20 @@ static int pnp_assign_port(struct pnp_de
 	struct resource res;
 
 	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.port_resource[idx].flags & IORESOURCE_AUTO))
+	if (pnp_port_ok(dev, idx) && !(dev->res.port_resource[idx].flags & IORESOURCE_AUTO))
 		return 1;
 
-	res.start = dev->res.port_resource[idx].start;
-	res.end = dev->res.port_resource[idx].end;
-	res.flags = dev->res.port_resource[idx].flags;
+	if (pnp_port_ok(dev, idx)) {
+		/* This resource index already got some values assigned,
+		   take them as init */
+		res.start = dev->res.port_resource[idx].start;
+		res.end = dev->res.port_resource[idx].end;
+		res.flags = dev->res.port_resource[idx].flags;
+	} else
+		/* This index in the table does not exist, initialize the new
+		   resource and be carefuly to never access
+		   dev->res.port_resource[idx] */
+		pnp_init_io(&res);
 
 	/* set the initial values */
 	res.flags |= rule->flags | IORESOURCE_IO;
@@ -380,12 +388,15 @@ static int pnp_assign_mem(struct pnp_dev
 	struct resource res;
 
 	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.mem_resource[idx].flags & IORESOURCE_AUTO))
+	if (pnp_mem_ok(dev, idx) && !(dev->res.mem_resource[idx].flags & IORESOURCE_AUTO))
 		return 1;
 
-	res.start = dev->res.mem_resource[idx].start;
-	res.end = dev->res.mem_resource[idx].end;
-	res.flags = dev->res.mem_resource[idx].flags;
+	if (pnp_mem_ok(dev, idx)) {
+		res.start = dev->res.mem_resource[idx].start;
+		res.end = dev->res.mem_resource[idx].end;
+		res.flags = dev->res.mem_resource[idx].flags;
+	} else
+		pnp_init_mem(&res);
 
 	/* set the initial values */
 	res.flags |= rule->flags | IORESOURCE_MEM;
@@ -432,12 +443,15 @@ static int pnp_assign_irq(struct pnp_dev
 	};
 
 	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.irq_resource[idx].flags & IORESOURCE_AUTO))
+	if (pnp_irq_ok(dev, idx) && !(dev->res.irq_resource[idx].flags & IORESOURCE_AUTO))
 		return 1;
 
-	res.start = dev->res.irq_resource[idx].start;
-	res.end = dev->res.irq_resource[idx].end;
-	res.flags = dev->res.irq_resource[idx].flags;
+	if (pnp_irq_ok(dev, idx)) {
+		res.start = dev->res.irq_resource[idx].start;
+		res.end = dev->res.irq_resource[idx].end;
+		res.flags = dev->res.irq_resource[idx].flags;
+	} else
+		pnp_init_irq(&res);
 
 	/* set the initial values */
 	res.flags |= rule->flags | IORESOURCE_IRQ;
@@ -477,12 +491,15 @@ static void pnp_assign_dma(struct pnp_de
 	};
 
 	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.dma_resource[idx].flags & IORESOURCE_AUTO))
+	if (pnp_dma_ok(dev, idx) && !(dev->res.dma_resource[idx].flags & IORESOURCE_AUTO))
 		return;
 
-	res.start = dev->res.dma_resource[idx].start;
-	res.end = dev->res.dma_resource[idx].end;
-	res.flags = dev->res.dma_resource[idx].flags;
+	if (pnp_dma_ok(dev, idx)) {
+		res.start = dev->res.dma_resource[idx].start;
+		res.end = dev->res.dma_resource[idx].end;
+		res.flags = dev->res.dma_resource[idx].flags;
+	} else
+		pnp_init_dma(&res);
 
 	/* set the initial values */
 	res.flags |= rule->flags | IORESOURCE_DMA;


