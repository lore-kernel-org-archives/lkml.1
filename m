Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbXHRMb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbXHRMb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 08:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbXHRMbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 08:31:20 -0400
Received: from main.gmane.org ([80.91.229.2]:34987 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496AbXHRMbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 08:31:19 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: Panic with XFS on RHEL5 (2.6.18-8.1.8.el5)
Date: Sat, 18 Aug 2007 13:31:07 +0100
Message-ID: <yw1xr6m1ja7o.fsf@thrashbarg.mansr.com>
References: <46C6C145.70506@abacustree.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: agrajag.inprovide.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (Double Solitaire, linux)
Cancel-Lock: sha1:4CFYqkBO371eBah2ZkqCxCSe51Y=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Boot <chris.boot@abacustree.com> writes:

> All,
>
> I've got a box running RHEL5 and haven't been impressed by ext3
> performance on it (running of a 1.5TB HP MSA20 using the cciss
> driver). I compiled XFS as a module and tried it out since I'm used to
> using it on Debian, which runs much more efficiently. However, every
> so often the kernel panics as below. Apologies for the tainted kernel,
> but we run VMware Server on the box as well.
>
> Does anyone have any hits/tips for using XFS on Red Hat? What's
> causing the panic below, and is there a way around this?
>
> BUG: unable to handle kernel paging request at virtual address b8af9d60
> printing eip:
> c0415974
> *pde = 00000000
> Oops: 0000 [#1]
> SMP last sysfs file: /block/loop7/dev
> Modules linked in: loop nfsd exportfs lockd nfs_acl iscsi_trgt(U)
> autofs4 hidp nls_utf8 cifs ppdev rfcomm l2cap bluetooth vmnet(U)
> vmmon(U) sunrpc ipv6 xfs(U) video sbs i2c_ec button battery asus_acpi
> ac lp st sg floppy serio_raw intel_rng pcspkr e100 mii e7xxx_edac
> i2c_i801 edac_mc i2c_core e1000 r8169 ide_cd cdrom parport_pc parport
> dm_snapshot dm_zero dm_mirror dm_mod cciss mptspi mptscsih
> scsi_transport_spi sd_mod scsi_mod mptbase ext3 jbd ehci_hcd ohci_hcd
> uhci_hcd
> CPU:    1
> EIP:    0060:[<c0415974>]    Tainted: P      VLI
> EFLAGS: 00010046   (2.6.18-8.1.8.el5 #1) EIP is at
> smp_send_reschedule+0x3/0x53
> eax: c213f000   ebx: c213f000   ecx: eef84000   edx: c213f000
> esi: 00001086   edi: f668c000   ebp: f4f2fce8   esp: f4f2fc8c
> ds: 007b   es: 007b   ss: 0068
> Process crond (pid: 3146, ti=f4f2f000 task=f51faaa0 task.ti=f4f2f000)
> Stack: 66d66b89 c041dc23 00000000 a9afbb0e fffffea5 01904500 00000000
> 0000000f     00000000 00000001 00000001 c200c6e0 00000100 00000000
> 00000069 00000180     018fc500 c200d240 00000003 00000292 f601efc0
> f6027e00 00000000 00000050 Call Trace:
> [<c041dc23>] try_to_wake_up+0x351/0x37b
> [<f936884e>] xfsbufd_wakeup+0x28/0x49 [xfs]
> [<c04572f9>] shrink_slab+0x56/0x13c
> [<c0457c0c>] try_to_free_pages+0x162/0x23e
> [<c0454064>] __alloc_pages+0x18d/0x27e
> [<c045214e>] find_or_create_page+0x53/0x8c
> [<c046c7b1>] __getblk+0x162/0x270
> [<c0475be0>] do_lookup+0x53/0x157
> [<f889138f>] ext3_getblk+0x7c/0x233 [ext3]
> [<f88913fe>] ext3_getblk+0xeb/0x233 [ext3]
> [<c048215c>] mntput_no_expire+0x11/0x6a
> [<f889226e>] ext3_bread+0x13/0x69 [ext3]
> [<f8895606>] htree_dirblock_to_tree+0x22/0x113 [ext3]
> [<f889574f>] ext3_htree_fill_tree+0x58/0x1a0 [ext3]
> [<c047828b>] do_path_lookup+0x20e/0x25f
> [<c046b987>] get_empty_filp+0x99/0x15e
> [<f889d611>] ext3_permission+0x0/0xa [ext3]
> [<f888eaa3>] ext3_readdir+0x1ce/0x59b [ext3]
> [<c047a0dd>] filldir+0x0/0xb9
> [<c0472973>] sys_fstat64+0x1e/0x23
> [<c047a1f9>] vfs_readdir+0x63/0x8d
> [<c047a0dd>] filldir+0x0/0xb9
> [<c047a447>] sys_getdents+0x5f/0x9c
> [<c0403eff>] syscall_call+0x7/0xb
> =======================

Your Redhat kernel is probably built with 4k stacks and XFS+loop+ext3
seems to be enough to overflow it.

-- 
Måns Rullgård
mans@mansr.com

