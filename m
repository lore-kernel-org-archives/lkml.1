Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbXGVOxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbXGVOxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 10:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbXGVOxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 10:53:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:56538 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbXGVOxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 10:53:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Pwg+WfXyLk7rmHqaYquhOhHgeWbB+ttk+vNbP/+N/gVW1DvQTFsUTCWse+/ZTfKHhlpt2DIT/5j4oc4vb3GIqw5VhcXFDTW9MaXsZVFsxRHhqrjc1Pay82veZ3oHAZoECFjYcrGuWw6zHVLOdfE8UAyoneDiTzdXdiHpJ3FmL/0=
Message-ID: <a781481a0707220753q2754f3cfy47941405f92c833d@mail.gmail.com>
Date: Sun, 22 Jul 2007 20:23:20 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [bug] pcwd_init_module(): WARNING: at lib/kref.c:33 kref_get()
Cc: linux-kernel@vger.kernel.org, "Wim Van Sebroeck" <wim@iguana.be>,
       "Greg KH" <gregkh@suse.de>, cornelia.huck@de.ibm.com
In-Reply-To: <20070722124224.GA20382@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070722124224.GA20382@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/22/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> enabling CONFIG_PCWATCHDOG=y crashes bzImage bootup, see below. Tested
> on latest -git.
>
>         Ingo
>
> ------------------->
> Calling initcall 0xc1e81f8c: pcwd_init_module+0x0/0x14()
> WARNING: at lib/kref.c:33 kref_get()
>  [<c0105f6e>] show_trace_log_lvl+0x19/0x2e
>  [<c0106067>] show_trace+0x12/0x14
>  [<c010607d>] dump_stack+0x14/0x16
>  [<c051aa54>] kref_get+0x37/0x40
>  [<c0519dfe>] kobject_get+0x12/0x17
>  [<c06fd12a>] get_bus+0x11/0x21
>  [<c06fd729>] bus_add_driver+0x18/0x16b
>  [<c06fe45a>] driver_register+0x66/0x6b
>  [<c0702575>] isa_register_driver+0x27/0x126
>  [<c1e81f9e>] pcwd_init_module+0x12/0x14
>  [<c1e50838>] kernel_init+0x15a/0x2df
>  [<c0105d87>] kernel_thread_helper+0x7/0x10
>  =======================

Trying to kref_get() isa_driver.device_driver.bus->subsys.kobj.kref
but it hasn't even been kref_init()'ed yet/already.

> WARNING: at lib/kref.c:33 kref_get()
>  [<c0105f6e>] show_trace_log_lvl+0x19/0x2e
>  [<c0106067>] show_trace+0x12/0x14
>  [<c010607d>] dump_stack+0x14/0x16
>  [<c051aa54>] kref_get+0x37/0x40
>  [<c0519dfe>] kobject_get+0x12/0x17
>  [<c051a429>] kobject_init+0x32/0x43
>  [<c051a4c3>] kobject_register+0x15/0x31
>  [<c06fd76d>] bus_add_driver+0x5c/0x16b
>  [<c06fe45a>] driver_register+0x66/0x6b
>  [<c0702575>] isa_register_driver+0x27/0x126
>  [<c1e81f9e>] pcwd_init_module+0x12/0x14
>  [<c1e50838>] kernel_init+0x15a/0x2df
>  [<c0105d87>] kernel_thread_helper+0x7/0x10
>  =======================

Trying to kref_get() isa_driver.device_driver.kobj.kset->kobj.kref
but it hasn't even been kref_init()'ed yet/already.

> BUG: spinlock bad magic on CPU#0, swapper/1
>  lock: c1b6a888, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
>  [<c0105f6e>] show_trace_log_lvl+0x19/0x2e
>  [<c0106067>] show_trace+0x12/0x14
>  [<c010607d>] dump_stack+0x14/0x16
>  [<c052b0be>] spin_bug+0xa1/0xa9
>  [<c052b289>] _raw_spin_lock+0x1e/0x104
>  [<c1385f7e>] _spin_lock+0x54/0x62
>  [<c051a026>] kobject_shadow_add+0x84/0x171
>  [<c051a11d>] kobject_add+0xa/0xc
>  [<c051a4ca>] kobject_register+0x1c/0x31
>  [<c06fd76d>] bus_add_driver+0x5c/0x16b
>  [<c06fe45a>] driver_register+0x66/0x6b
>  [<c0702575>] isa_register_driver+0x27/0x126
>  [<c1e81f9e>] pcwd_init_module+0x12/0x14
>  [<c1e50838>] kernel_init+0x15a/0x2df
>  [<c0105d87>] kernel_thread_helper+0x7/0x10
>  =======================

Trying to spin_lock() isa_driver.device_driver.kobj.kset->list_lock
but it hasn't even been spin_lock_init()'ed already.

Greg/Cornelia, any idea when/why would such errors normally occur?

Thanks,
Satyam
