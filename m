Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbXJEKpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbXJEKpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 06:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbXJEKo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 06:44:56 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:47749 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751918AbXJEKoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 06:44:55 -0400
Message-ID: <391581094.26735@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 5 Oct 2007 18:44:50 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
Subject: Re: BUG on unloading the fuse module
Message-ID: <20071005104450.GA10259@mail.ustc.edu.cn>
References: <391574553.18064@ustc.edu.cn> <E1Idjd8-0002rY-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Idjd8-0002rY-00@dorka.pomaz.szeredi.hu>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 11:37:58AM +0200, Miklos Szeredi wrote:
> > In 2.6.23-rc8-mm2, the fuse module always bugs on unloading.
> 
> It's fixed in Greg's patch queue.
> 
> This patch against -mm will also fix it.

Oh no, it panics:

[    2.602060] general protection fault: 0000 [1] SMP
[    2.603334] last sysfs file:
[    2.604063] CPU 0
[    2.604587] Modules linked in:
[    2.605397] Pid: 1, comm: swapper Not tainted 2.6.23-rc8-mm2 #27
[    2.606841] RIP: 0010:[<ffffffff810a5e0d>]  [<ffffffff810a5e0d>] kfree+0x3d/0x110
[    2.608613] RSP: 0000:ffff8100029dbac0  EFLAGS: 00000203
[    2.609897] RAX: 0284087ebd278440 RBX: 0284087ebd278440 RCX: 000000000000003f
[    2.611681] RDX: ffff81000000b000 RSI: ffff8100029e0830 RDI: 0006b6bea6b6b6b6
[    2.613414] RBP: ffff8100029dbaf0 R08: ffffffff8152cb00 R09: 0000000000000000
[    2.615135] R10: 0000000000000001 R11: 0000000000000008 R12: 6b6b6b6b6b6b6b6b
[    2.616867] R13: ffff810002ab4e70 R14: ffffffff814f3360 R15: ffffffff813cc069
[    2.618602] FS:  0000000000000000(0000) GS:ffffffff81512000(0000) knlGS:0000000000000000
[    2.620134] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    2.621188] CR2: 0000000000000000 CR3: 0000000001001000 CR4: 00000000000006e0
[    2.622485] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    2.623596] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[    2.624818] Process swapper (pid: 1, threadinfo ffff8100029da000, task ffff8100029e0000)
[    2.626781] last branch before last exception/interrupt
[    2.628033]  from  [<0000000000000000>]
[    2.629009]  to  [<0000000000000000>]
[    2.629925] Stack:  ffffffff814f3360 ffff810003eb3958 ffffffff814f5c00 ffff810002ab4e70
[    2.631979]  ffffffff814f3360 ffffffff813cc069 ffff8100029dbb20 ffffffff81155422
[    2.633851]  ffff8100029bb9a8 ffff810003eb3960 ffffffff81155460 ffff8100029bb9a8
[    2.635700] Call Trace:
[    2.636427]  [<ffffffff81155422>] kobject_cleanup+0x42/0x80
[    2.636851]  [<ffffffff8115546d>] kobject_release+0xd/0x10
[    2.637076]  [<ffffffff811565a3>] kref_put+0x43/0x80
[    2.637291]  [<ffffffff811553d9>] kobject_put+0x19/0x20
[    2.637510]  [<ffffffff811c0c25>] put_device+0x15/0x20
[    2.637725]  [<ffffffff811c1459>] device_unregister+0x19/0x20
[    2.637958]  [<ffffffff811c1519>] device_destroy+0xb9/0xd0
[    2.638187]  [<ffffffff8119e9e1>] tty_unregister_device+0x21/0x30
[    2.638434]  [<ffffffff811b84eb>] uart_remove_one_port+0x9b/0x120
[    2.638680]  [<ffffffff811bddc9>] serial8250_register_port+0x69/0x110
[    2.638938]  [<ffffffff811befd0>] serial_pnp_probe+0xf0/0x170
[    2.639168]  [<ffffffff81195ca2>] pnp_device_probe+0x82/0xe0
[    2.639408]  [<ffffffff811c3cb1>] driver_probe_device+0xa1/0x1c0
[    2.639650]  [<ffffffff811c3fa5>] __driver_attach+0xe5/0xf0
[    2.639877]  [<ffffffff811c2e93>] bus_for_each_dev+0x53/0x80
[    2.640109]  [<ffffffff811c3aec>] driver_attach+0x1c/0x20
[    2.640331]  [<ffffffff811c32b5>] bus_add_driver+0xa5/0x210
[    2.640560]  [<ffffffff811c41ed>] driver_register+0x4d/0x80
[    2.640788]  [<ffffffff811959e8>] pnp_register_driver+0x38/0x40
[    2.641030]  [<ffffffff81561b50>] serial8250_pnp_init+0x10/0x20
[    2.641273]  [<ffffffff8154078b>] kernel_init+0x15b/0x340
[    2.641467]  [<ffffffff8100d248>] child_rip+0xa/0x12
[    2.641641]
[    2.641706] INFO: lockdep is turned off.
[    2.641838]
[    2.641844] Code: 48 8b 00 25 00 40 02 00 48 3d 00 40 02 00 0f 84 a5 00 00 00
[    2.642408] RIP  [<ffffffff810a5e0d>] kfree+0x3d/0x110
[    2.642598]  RSP <ffff8100029dbac0>
[    2.643388] Kernel panic - not syncing: Attempted to kill init!

Thank you,
Fengguang

> ---
> 
> Index: linux/lib/kobject.c
> ===================================================================
> --- linux.orig/lib/kobject.c	2007-10-02 17:20:04.000000000 +0200
> +++ linux/lib/kobject.c	2007-10-03 13:58:42.000000000 +0200
> @@ -498,18 +498,17 @@ void kobject_cleanup(struct kobject * ko
>  	struct kobj_type * t = get_ktype(kobj);
>  	struct kset * s = kobj->kset;
>  	struct kobject * parent = kobj->parent;
> -	const char *k_name = kobj->k_name;
>  
>  	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
> -	kobj->k_name = NULL;
> -	if (t && t->release)
> +	if (t && t->release) {
>  		t->release(kobj);
> -	else
> +		kfree(kobj->k_name);
> +		kobj->k_name = NULL;
> +	} else
>  		pr_debug("kobject '%s' does not have a release() function, "
>  			"if this is not a directory kobject, it is broken "
>  			"and must be fixed.\n",
> -			k_name);
> -	kfree(k_name);
> +			kobj->k_name);
>  	if (s)
>  		kset_put(s);
>  	kobject_put(parent);

