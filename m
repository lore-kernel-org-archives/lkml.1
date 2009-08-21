Return-Path: <linux-kernel-owner+w=401wt.eu-S932580AbZHUUMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbZHUUMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932569AbZHUUMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:12:36 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:49104 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932371AbZHUUMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:12:35 -0400
Message-ID: <4A8EFFB2.4040100@suse.de>
Date: Sat, 22 Aug 2009 00:12:34 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       len.brown@intel.com
Subject: Re: BUG: scheduling while atomic in acpi_ps_complete_op
References: <1250873707.2168.38.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1250873707.2168.38.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
This should be handled by abe1dfab60e1839d115930286cb421f5a5b193f3.

Regards,
Alex.

Eric Paris пишет:
> Looks like 8bd108d14604d9c95 added ACPI_PREEMPTION_POINT() in
> acpi_ps_complete_op().  But now on boot in linux-next I get streams of
> BUG() like below (always seems to be with swapper)
> 
> This is a linux-next kernel from Aug 21 on vmware server 2.0.
> 
> -Eric
> 
> [    4.241159] BUG: scheduling while atomic: swapper/0/0x10000002
> [    4.242308] no locks held by swapper/0.
> [    4.243011] Modules linked in:
> [    4.245012] Pid: 0, comm: swapper Not tainted 2.6.31-rc6-next-20090821 #45
> [    4.246018] Call Trace:
> [    4.247015]  [<ffffffff81058635>] __schedule_bug+0xa5/0xb0
> [    4.248018]  [<ffffffff8152f0e5>] thread_return+0x794/0x93f
> [    4.249015]  [<ffffffff812d77da>] ? acpi_os_release_object+0x1c/0x34
> [    4.250020]  [<ffffffff815334e0>] ? error_exit+0x30/0xb0
> [    4.251014]  [<ffffffff812d77da>] ? acpi_os_release_object+0x1c/0x34
> [    4.252014]  [<ffffffff81061f66>] __cond_resched+0x26/0x50
> [    4.253015]  [<ffffffff8152f42a>] _cond_resched+0x4a/0x60
> [    4.254020]  [<ffffffff812fb4d1>] acpi_ps_complete_op+0x239/0x25b
> [    4.255014]  [<ffffffff812fbbc6>] acpi_ps_parse_loop+0x6d3/0x89d
> [    4.256014]  [<ffffffff812fad3b>] acpi_ps_parse_aml+0xab/0x32d
> [    4.257014]  [<ffffffff812e8d5a>] ? acpi_ds_init_aml_walk+0x10f/0x12e
> [    4.258020]  [<ffffffff812f9989>] acpi_ns_one_complete_parse+0xf9/0x128
> [    4.259014]  [<ffffffff81802140>] ? early_idt_handler+0x0/0x71
> [    4.260014]  [<ffffffff812f99e7>] acpi_ns_parse_table+0x2f/0x60
> [    4.261014]  [<ffffffff812f6339>] acpi_ns_load_table+0x59/0xb8
> [    4.262021]  [<ffffffff812fe60d>] acpi_load_tables+0x80/0x161
> [    4.263014]  [<ffffffff8183eef0>] acpi_early_init+0x71/0x11d
> [    4.264015]  [<ffffffff81802f6a>] start_kernel+0x39a/0x4a0
> [    4.265014]  [<ffffffff818022e1>] x86_64_start_reservations+0xc1/0x100
> [    4.266020]  [<ffffffff81802428>] x86_64_start_kernel+0x108/0x150
> 
> 

