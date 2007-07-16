Return-Path: <linux-kernel-owner+w=401wt.eu-S1759785AbXGPTOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785AbXGPTOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 15:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXGPTOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 15:14:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:6069 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbXGPTOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 15:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=LxznKGckGvdDuv+KNTSTfizT8Q0j1ZZiQrv41/+H5OYR1oPwAsgtylIvtJm4M3IaTIcORBzwCMUPfUlUAtwbC51nwn1X/H7IDWJN0CJYWiSK0VieyfHkW88Mncy36doh4uF5BEW3XMjRUytNbKEWRvetlzvBfpOJ1S3S5Ch61o0=
Message-ID: <469BC34C.4080107@googlemail.com>
Date: Mon, 16 Jul 2007 21:13:16 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, gregkh@suse.de
Subject: Re: Oops while modprobing phy fixed module
References: <4698BF14.10807@googlemail.com>	 <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>	 <469A5C94.7030201@googlemail.com>	 <a781481a0707151414l3efcd2d0q93db88a32b90e344@mail.gmail.com>	 <469A9D5D.10509@googlemail.com> <469B61C8.8010902@googlemail.com> <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com> <469BB7B8.3060002@gmail.com> <469BB9CA.6090500@googlemail.com> <469BC2D6.5090008@googlemail.com>
In-Reply-To: <469BC2D6.5090008@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Gabriel C wrote:
>   
>> Tejun Heo wrote:
>>   
>>     
>>> Satyam Sharma wrote:
>>>   
>>>     
>>>       
>>>> On 7/16/07, Gabriel C <nix.or.die@googlemail.com> wrote:
>>>>     
>>>>       
>>>>         
>>>>> Here the bisect result:
>>>>>
>>>>> 3007e997de91ec59af39a3f9c91595b31ae6e08b is first bad commit
>>>>> commit 3007e997de91ec59af39a3f9c91595b31ae6e08b
>>>>> Author: Tejun Heo <htejun@gmail.com>
>>>>> Date:   Thu Jun 14 04:27:23 2007 +0900
>>>>>
>>>>>     sysfs: use sysfs_mutex to protect the sysfs_dirent tree
>>>>>       
>>>>>         
>>>>>           
>>> Hmmm... Weird.  The patch is supposed to make synchronization more
>>> strict not less unless I've forgotten locking at some place.  Gabriel,
>>> can you please choose SLAB and enable CONFIG_DEBUG_SLAB and
>>> DEBUG_SLAB_LEAK and see whether kernel complains about something?
>>>   
>>>     
>>>       
>> Sure , give me some minutes.
>>   
>>     
>
> With DEBUG_SLAB_LEAK set ( and a lot other DEBUG options ) I get on
> current HEAD
> ( abce891a10559343d8ac9f79b46d78afdba63a40 ) an Oops too now , just the
> box isn't died.
>
> Config and dmesg can be found there :
>
> http://194.231.229.228/2.6.22-gabce891a/
>
> Here it is :
>
> [  199.766878] Fixed PHY: Registered new driver
> [  199.768069] BUG: unable to handle kernel paging request at virtual address 6b6b6b87
> [  199.768081]  printing eip:
> [  199.768085] c01a0796
> [  199.768089] *pde = 00000000
> [  199.768098] Oops: 0000 [#1]
> [  199.768102] PREEMPT SMP DEBUG_PAGEALLOC
> [  199.768111] Modules linked in: fixed pc87360 hwmon_vid i2c_isa eeprom adm1021 uhci_hcd sr_mod shpchp pci_hotplug ohci_hcd iTCO_wdt iTCO_vendor_support intel_agp i82860_edac i2c_i801 ehci_hcd usbcore edac_mc cdrom agpgart 3c59x mii ext4dev jbd2 capability commoncap loop lp parport_pc parport
> [  199.768182] CPU:    1
> [  199.768184] EIP:    0060:[<c01a0796>]    Not tainted VLI
> [  199.768188] EFLAGS: 00210202   (2.6.22-gabce891a #27)
> [  199.768205] EIP is at __sysfs_remove_dir+0x20/0x64
> [  199.768213] eax: 00000000   ebx: de583e04   ecx: e5113728   edx: 6b6b6b6b
> [  199.768222] esi: e5113738   edi: e5113728   ebp: de583e20   esp: de583e04
> [  199.768230] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> [  199.768238] Process modprobe (pid: 2067, ti=de582000 task=d79174c0 task.ti=de582000)
> [  199.768246] Stack: e5113728 00000000 00000000 00000000 d96bcce0 e5113728 00000000 de583e30 
> [  199.768271]        c01a0810 d96bcce0 d96bcbf8 de583e3c c01db3eb d96bcce0 de583e50 c023e338 
> [  199.768298]        d96bcbf8 d96bcbf8 e0b3eef0 de583e5c c023e365 d96bcbf0 de583e9c e8c472e8 
> [  199.768327] Call Trace:
> [  199.768333]  [<c0104f86>] show_trace_log_lvl+0x1a/0x2f
> [  199.768348]  [<c0105036>] show_stack_log_lvl+0x9b/0xa3
> [  199.768359]  [<c010520c>] show_registers+0x1ce/0x2de
> [  199.768370]  [<c010543b>] die+0x11f/0x1f8
> [  199.768380]  [<c01137a9>] do_page_fault+0x438/0x507
> [  199.768392]  [<c031893a>] error_code+0x72/0x78
> [  199.768405]  [<c01a0810>] sysfs_remove_dir+0x2c/0x30
> [  199.768415]  [<c01db3eb>] kobject_del+0xf/0x19
> [  199.768429]  [<c023e338>] device_del+0x228/0x24a
> [  199.768442]  [<c023e365>] device_unregister+0xb/0x15
> [  199.768452]  [<e8c472e8>] fixed_mdio_register_device+0x1dc/0x208 [fixed]
> [  199.768467]  [<e8c4a01e>] fixed_init+0x1e/0x33 [fixed]
> [  199.768479]  [<c013d290>] sys_init_module+0x1589/0x1677
> [  199.768493]  [<c0103f16>] sysenter_past_esp+0x5f/0x99
> [  199.768503]  =======================
> [  199.768508] Code: e7 fd ff ff 83 c4 10 5b 5e 5d c3 55 89 e5 57 56 53 83 ec 10 89 c7 85 c0 74 4d 8d 5d e4 89 c2 89 d8 e8 1f fb ff ff 8d 77 10 eb 27 <8b> 42 1c 25 ff 00 00 00 74 1a 83 f8 02 74 15 8b 42 0c 89 06 c7 
> [  199.768675] EIP: [<c01a0796>] __sysfs_remove_dir+0x20/0x64 SS:ESP 0068:de583e04
>
>
>
>   

Damn I forgot to paste the gdb output =)


(gdb) l *__sysfs_remove_dir+0x20
0xc01a0796 is in __sysfs_remove_dir (fs/sysfs/dir.c:855).
850             sysfs_addrm_start(&acxt, dir_sd);
851             pos = &dir_sd->s_children;
852             while (*pos) {
853                     struct sysfs_dirent *sd = *pos;
854
855                     if (sysfs_type(sd) && sysfs_type(sd) != SYSFS_DIR) {
856                             *pos = sd->s_sibling;
857                             sd->s_sibling = NULL;
858                             sysfs_remove_one(&acxt, sd);
859                     } else


