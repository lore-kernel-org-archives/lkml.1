Return-Path: <linux-kernel-owner+w=401wt.eu-S1756410AbXHROrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbXHROrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 10:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbXHROrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 10:47:05 -0400
Received: from baldrick.fusednetworks.co.uk ([83.142.228.48]:39073 "EHLO
	baldrick.fusednetworks.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754005AbXHROrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 10:47:03 -0400
X-Greylist: delayed 1751 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Aug 2007 10:47:02 EDT
Message-ID: <46C6FF93.4040509@bootc.net>
Date: Sat, 18 Aug 2007 15:17:55 +0100
From: Chris Boot <bootc@bootc.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Panic with XFS on RHEL5 (2.6.18-8.1.8.el5)
References: <46C6C145.70506@abacustree.com> <yw1xr6m1ja7o.fsf@thrashbarg.mansr.com>
In-Reply-To: <yw1xr6m1ja7o.fsf@thrashbarg.mansr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Måns Rullgård wrote:
> Chris Boot <chris.boot@abacustree.com> writes:
>
>   
>> All,
>>
>> I've got a box running RHEL5 and haven't been impressed by ext3
>> performance on it (running of a 1.5TB HP MSA20 using the cciss
>> driver). I compiled XFS as a module and tried it out since I'm used to
>> using it on Debian, which runs much more efficiently. However, every
>> so often the kernel panics as below. Apologies for the tainted kernel,
>> but we run VMware Server on the box as well.
>>
>> Does anyone have any hits/tips for using XFS on Red Hat? What's
>> causing the panic below, and is there a way around this?
>>
>> BUG: unable to handle kernel paging request at virtual address b8af9d60
>> printing eip:
>> c0415974
>> *pde = 00000000
>> Oops: 0000 [#1]
>> SMP last sysfs file: /block/loop7/dev
>> Modules linked in: loop nfsd exportfs lockd nfs_acl iscsi_trgt(U)
>> autofs4 hidp nls_utf8 cifs ppdev rfcomm l2cap bluetooth vmnet(U)
>> vmmon(U) sunrpc ipv6 xfs(U) video sbs i2c_ec button battery asus_acpi
>> ac lp st sg floppy serio_raw intel_rng pcspkr e100 mii e7xxx_edac
>> i2c_i801 edac_mc i2c_core e1000 r8169 ide_cd cdrom parport_pc parport
>> dm_snapshot dm_zero dm_mirror dm_mod cciss mptspi mptscsih
>> scsi_transport_spi sd_mod scsi_mod mptbase ext3 jbd ehci_hcd ohci_hcd
>> uhci_hcd
>> CPU:    1
>> EIP:    0060:[<c0415974>]    Tainted: P      VLI
>> EFLAGS: 00010046   (2.6.18-8.1.8.el5 #1) EIP is at
>> smp_send_reschedule+0x3/0x53
>> eax: c213f000   ebx: c213f000   ecx: eef84000   edx: c213f000
>> esi: 00001086   edi: f668c000   ebp: f4f2fce8   esp: f4f2fc8c
>> ds: 007b   es: 007b   ss: 0068
>> Process crond (pid: 3146, ti=f4f2f000 task=f51faaa0 task.ti=f4f2f000)
>> Stack: 66d66b89 c041dc23 00000000 a9afbb0e fffffea5 01904500 00000000
>> 0000000f     00000000 00000001 00000001 c200c6e0 00000100 00000000
>> 00000069 00000180     018fc500 c200d240 00000003 00000292 f601efc0
>> f6027e00 00000000 00000050 Call Trace:
>> [<c041dc23>] try_to_wake_up+0x351/0x37b
>> [<f936884e>] xfsbufd_wakeup+0x28/0x49 [xfs]
>> [<c04572f9>] shrink_slab+0x56/0x13c
>> [<c0457c0c>] try_to_free_pages+0x162/0x23e
>> [<c0454064>] __alloc_pages+0x18d/0x27e
>> [<c045214e>] find_or_create_page+0x53/0x8c
>> [<c046c7b1>] __getblk+0x162/0x270
>> [<c0475be0>] do_lookup+0x53/0x157
>> [<f889138f>] ext3_getblk+0x7c/0x233 [ext3]
>> [<f88913fe>] ext3_getblk+0xeb/0x233 [ext3]
>> [<c048215c>] mntput_no_expire+0x11/0x6a
>> [<f889226e>] ext3_bread+0x13/0x69 [ext3]
>> [<f8895606>] htree_dirblock_to_tree+0x22/0x113 [ext3]
>> [<f889574f>] ext3_htree_fill_tree+0x58/0x1a0 [ext3]
>> [<c047828b>] do_path_lookup+0x20e/0x25f
>> [<c046b987>] get_empty_filp+0x99/0x15e
>> [<f889d611>] ext3_permission+0x0/0xa [ext3]
>> [<f888eaa3>] ext3_readdir+0x1ce/0x59b [ext3]
>> [<c047a0dd>] filldir+0x0/0xb9
>> [<c0472973>] sys_fstat64+0x1e/0x23
>> [<c047a1f9>] vfs_readdir+0x63/0x8d
>> [<c047a0dd>] filldir+0x0/0xb9
>> [<c047a447>] sys_getdents+0x5f/0x9c
>> [<c0403eff>] syscall_call+0x7/0xb
>> =======================
>>     
>
> Your Redhat kernel is probably built with 4k stacks and XFS+loop+ext3
> seems to be enough to overflow it.
>   
Thanks, that explains a lot. However, I don't have any XFS filesystems 
mounted over loop devices on ext3. Earlier in the day I had iso9660 on 
loop on xfs, could that have caused the issue? It was unmounted and 
deleted when this panic occurred.

I'll probably just try and recompile the kernel with 8k stacks and see 
how it goes. Screw the support, we're unlikely to get it anyway. :-P

Many thanks,
Chris

