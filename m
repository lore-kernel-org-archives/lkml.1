Return-Path: <linux-kernel-owner+w=401wt.eu-S1030316AbXDCPLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030316AbXDCPLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 11:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030317AbXDCPLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 11:11:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:17328 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030316AbXDCPLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 11:11:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,366,1170662400"; 
   d="scan'208"; a="207419889:sNHT18823588"
Message-ID: <46126EAA.3050000@intel.com>
Date: Tue, 03 Apr 2007 08:11:38 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.10 (X11/20070311)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc5-mm4
References: <20070402224745.71a25af7.akpm@linux-foundation.org> <Pine.LNX.4.64.0704031455200.10589@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0704031455200.10589@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Apr 2007 15:11:39.0522 (UTC) FILETIME=[6125AE20:01C77602]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Mon, 2 Apr 2007, Andrew Morton wrote:
> 
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> 
> [proper CCs added]
> 
> On boot (e1000 compiled as module)

can you send me a full `lspci -vv`, `dmesg` as well? I've never seen this happen 
but it appears we did something bad.

Also, it would help a lot if you knew what kind of settings your init scripts 
are trying to configure. It seems that something is setting multicast or 
promiscuous mode. Do you happen to know which command is being executed by the 
shell?

Auke


> BUG: unable to handle kernel paging request at virtual address ffffffff
>  printing eip:
> ffffffff
> *pde = 00005067
> *pte = 00000000
> Oops: 0000 [#1]
> SMP
> last sysfs file: 
> devices/pci0000:00/0000:00:1c.0/0000:02:00.0/subsystem_device
> Modules linked in: cpufreq_conservative cpufreq_ondemand cpufreq_userspace 
> cpufreq_powersave acpi_cpufreq freq_table button battery ac loop dm_mod 
> usbhid fe
> CPU:    0
> EIP:    0060:[<ffffffff>]    Not tainted VLI
> EFLAGS: 00010002   (2.6.21-rc5-mm4-default #3)
> EIP is at 0xffffffff
> eax: 80080783   ebx: c242c794   ecx: 00000000   edx: c2371ac0
> esi: 00000007   edi: f8cc0000   ebp: 0000003c   esp: c3885ddc
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process ifplugd (pid: 3185, ti=c3884000 task=c3474070 task.ti=c3884000)
> Stack: f8c8a5ed 00000060 00000202 00000000 00000000 c2371ac0 f8c8648c 
> c242c794
>        c2371ac0 c242c000 f8c810b6 00000001 0000000f 00000000 00008002 
> c242c794
>        c2371ac0 c242c794 f8c9552c 00000001 0000000f c242c580 c242c000 
> c242c240
> Call Trace:
>  [<f8c8a5ed>] e1000_mc_addr_list_update_generic+0x87/0x146 [e1000]
>  [<f8c8648c>] e1000_mc_addr_list_update_82571+0x0/0x3c [e1000]
>  [<f8c810b6>] e1000_mc_addr_list_update+0x21/0x27 [e1000]
>  [<f8c9552c>] e1000_set_multi+0xe4/0x10c [e1000]
>  [<c0272d9f>] __dev_mc_upload+0x23/0x27
>  [<c0272ecc>] dev_mc_upload+0x27/0x3b
>  [<c027113f>] dev_open+0x4d/0x6d
>  [<c026f9c3>] dev_change_flags+0x50/0x104
>  [<c02ae726>] devinet_ioctl+0x259/0x57c
>  [<c01d8645>] copy_to_user+0x3c/0x53
>  [<c0265f4b>] sock_ioctl+0x1a4/0x1c7
>  [<c0265da7>] sock_ioctl+0x0/0x1c7
>  [<c0180617>] do_ioctl+0x1f/0x64
>  [<c018088d>] vfs_ioctl+0x231/0x244
>  [<c0267898>] sys_socketcall+0x7a/0x261
>  [<c01808ec>] sys_ioctl+0x4c/0x68
>  [<c0103dc8>] sysenter_past_esp+0x5d/0x99
>  =======================
> INFO: lockdep is turned off.
> Code:  Bad EIP value.
> EIP: [<ffffffff>] 0xffffffff SS:ESP 0068:c3885ddc
> Kernel panic - not syncing: Fatal exception in interrupt
> 
