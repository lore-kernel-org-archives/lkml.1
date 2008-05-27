Return-Path: <linux-kernel-owner+w=401wt.eu-S1759092AbYE0TLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092AbYE0TLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 15:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757842AbYE0TLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 15:11:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757762AbYE0TLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 15:11:06 -0400
Date: Tue, 27 May 2008 15:04:20 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: NFS oops in 2.6.26rc4
Message-ID: <20080527190419.GA14577@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Trond Myklebust <Trond.Myklebust@netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to mount an nfs export, I got this oops..

BUG: unable to handle kernel paging request at f4569000
IP: [<f8daac01>] :sunrpc:xdr_encode_opaque_fixed+0x2d/0x69
*pde = 34c23163 *pte = 34569160 
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
Modules linked in: nfs nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc ext2 sg button via_rhine via_ircc pcspkr r8169 mii pata_sil680 irda crc_ccitt i2c_viapro i2c_core dm_snapshot dm_zero dm_mirror dm_log dm_mod pata_via ata_generic pata_acpi libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]

Pid: 2046, comm: mount.nfs Not tainted (2.6.26-0.33.rc4.fc10.i686 #1)
EIP: 0060:[<f8daac01>] EFLAGS: 00210212 CPU: 0
EIP is at xdr_encode_opaque_fixed+0x2d/0x69 [sunrpc]
EAX: 0000f455 EBX: 00003d16 ECX: 0000349c EDX: 00000003
ESI: f4569000 EDI: f4d2e450 EBP: f4566a78 ESP: f4566a68
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process mount.nfs (pid: 2046, ti=f4566000 task=f4580000 task.ti=f4566000)
Stack: f4d2c26c 55f40000 f4e740c0 f4e740c0 f4566a84 f8daac4f 0000f455 f4566a94 
       f8e7ec28 00000000 f4d00600 f4566aac f8da4db8 f8e7ec12 f4e740c0 f4e740c0 
       f4d00600 f4566acc f8d9ea9d f4d2c268 f4566e1a f8e7ec12 f4d00600 00000000 
Call Trace:
 [<f8daac4f>] ? xdr_encode_opaque+0x12/0x15 [sunrpc]
 [<f8e7ec28>] ? nfs3_xdr_fhandle+0x16/0x25 [nfs]
 [<f8da4db8>] ? rpcauth_wrap_req+0x66/0x77 [sunrpc]
 [<f8e7ec12>] ? nfs3_xdr_fhandle+0x0/0x25 [nfs]
 [<f8d9ea9d>] ? call_transmit+0x18a/0x1eb [sunrpc]
 [<f8e7ec12>] ? nfs3_xdr_fhandle+0x0/0x25 [nfs]
 [<f8da4450>] ? __rpc_execute+0x69/0x1e1 [sunrpc]
 [<f8da45e3>] ? rpc_execute+0x1b/0x1e [sunrpc]
 [<f8d9f260>] ? rpc_run_task+0x43/0x49 [sunrpc]
 [<f8d9f368>] ? rpc_call_sync+0x43/0x5e [sunrpc]
 [<f8e7cf05>] ? nfs3_rpc_wrapper+0x17/0x4d [nfs]
 [<f8e7d014>] ? nfs3_proc_fsinfo+0x5e/0x80 [nfs]
 [<f8e6c64c>] ? nfs_probe_fsinfo+0x75/0x462 [nfs]
 [<f8d9f3c4>] ? rpc_ping+0x41/0x4b [sunrpc]
 [<f8d9f7c7>] ? rpc_bind_new_program+0x5b/0x71 [sunrpc]
 [<f8e6de14>] ? nfs_create_server+0x451/0x5fd [nfs]
 [<f8d9f4ef>] ? rpc_free_auth+0x33/0x36 [sunrpc]
 [<c05025e5>] ? kref_put+0x39/0x44
 [<f8d9f415>] ? rpc_release_client+0x47/0x4c [sunrpc]
 [<f8d9f5a6>] ? rpc_shutdown_client+0xb4/0xbc [sunrpc]
 [<f8e7cd39>] ? nfs_mount+0x12b/0x131 [nfs]
 [<f8e74eb8>] ? nfs_get_sb+0x599/0x830 [nfs]
 [<c04887c7>] ? check_object+0x134/0x18b
 [<c0489995>] ? __slab_alloc+0x45c/0x4ea
 [<c048a3a0>] ? __kmalloc+0xbc/0xfb
 [<c044788f>] ? trace_hardirqs_on+0xe9/0x10a
 [<c04a280c>] ? alloc_vfsmnt+0xe3/0x10a
 [<c048f6b1>] ? vfs_kern_mount+0x82/0xf5
 [<c048f768>] ? do_kern_mount+0x32/0xba
 [<c04a2520>] ? do_new_mount+0x42/0x6c
 [<c04a2fa0>] ? do_mount+0x199/0x1b7
 [<c04a1626>] ? copy_mount_options+0x79/0xf9
 [<c04a3024>] ? sys_mount+0x66/0x9e
 [<c0404c3a>] ? syscall_call+0x7/0xb
 =======================
Code: e5 57 56 89 d6 53 83 ec 04 85 c9 89 45 f0 89 c8 74 4c 8d 59 03 c1 eb 02 8d 14 9d 00 00 00 00 29 ca 85 f6 74 11 c1 e9 02 8b 7d f0 <f3> a5 89 c1 83 e1 03 74 02 f3 a4 85 d2 74 1b 8b 7d f0 89 d1 c1 
EIP: [<f8daac01>] xdr_encode_opaque_fixed+0x2d/0x69 [sunrpc] SS:ESP 0068:f4566a68
---[ end trace a8a691a45122c25a ]---
mount.nfs used greatest stack depth: 812 bytes left


-- 
http://www.codemonkey.org.uk
