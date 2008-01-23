Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbYAWWHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbYAWWHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbYAWWGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:06:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59311 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755136AbYAWWGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:06:41 -0500
Date: Wed, 23 Jan 2008 14:06:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miguel Ojeda" <maxextreme@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [WARNING -rc8] at fs/sysfs/dir.c:424 sysfs_add_one(), related
 with processor (ACPI)
Message-Id: <20080123140643.b56ea8eb.akpm@linux-foundation.org>
In-Reply-To: <653402b90801210953u71a85f91udce9e382d588af09@mail.gmail.com>
References: <653402b90801210953u71a85f91udce9e382d588af09@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 21 Jan 2008 18:53:18 +0100 "Miguel Ojeda" <maxextreme@gmail.com> wrote:
> Booting 2.6.24-rc8 I get this:
> 
> 
> sysfs: duplicate filename 'fan' can not be created
> WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> Pid: 819, comm: modprobe Not tainted 2.6.24-rc8 #2
>  [<c01b18ff>] sysfs_add_one+0x9f/0xe0
>  [<c01b1e38>] create_dir+0x48/0x90
>  [<c01b1ea9>] sysfs_create_dir+0x29/0x50
>  [<c024873f>] kobject_get+0xf/0x20
>  [<c0248bff>] kobject_add+0x8f/0x1b0
>  [<c0248db1>] kobject_register+0x21/0x50
>  [<c02dc6f1>] bus_add_driver+0x71/0x1e0
>  [<f886402f>] acpi_fan_init+0x2f/0x4d [fan]
>  [<c0148986>] sys_init_module+0x126/0x19b0
>  [<c024af87>] rb_insert_color+0xb7/0xe0
>  [<c029dc8d>] acpi_bus_register_driver+0x0/0x38
>  [<c0104286>] syscall_call+0x7/0xb
>  =======================
> kobject_add failed for fan with -EEXIST, don't try to register things
> with the same name in the same directory.
> Pid: 819, comm: modprobe Not tainted 2.6.24-rc8 #2
>  [<c0248c81>] kobject_add+0x111/0x1b0
>  [<c0248db1>] kobject_register+0x21/0x50
>  [<c02dc6f1>] bus_add_driver+0x71/0x1e0
>  [<f886402f>] acpi_fan_init+0x2f/0x4d [fan]
>  [<c0148986>] sys_init_module+0x126/0x19b0
>  [<c024af87>] rb_insert_color+0xb7/0xe0
>  [<c029dc8d>] acpi_bus_register_driver+0x0/0x38
>  [<c0104286>] syscall_call+0x7/0xb
>  =======================
> processor: exports duplicate symbol acpi_processor_set_thermal_limit
> (owned by kernel)
> 
> 
> 
> After that, there are five more traces. Attached dmesg output and .config.
> 

Cc linux-acpi.  If nothing happens (not uncommon) then please raise a
report agaisnt acpi at bugzilla.kernel.org, thanks.

