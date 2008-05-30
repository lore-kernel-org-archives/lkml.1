Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbYE3S3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbYE3S3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 14:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYE3S3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 14:29:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbYE3S3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 14:29:09 -0400
Date: Fri, 30 May 2008 14:21:26 -0400
From: Dave Jones <davej@redhat.com>
To: chucklever@gmail.com
Cc: Chuck Lever <chuck.lever@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: NFS oops in 2.6.26rc4
Message-ID: <20080530182126.GB32480@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, chucklever@gmail.com,
	Chuck Lever <chuck.lever@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Trond Myklebust <Trond.Myklebust@netapp.com>
References: <20080527190419.GA14577@redhat.com> <76bd70e30805301059v461e8f0eocc38b6fe36dd3b21@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76bd70e30805301059v461e8f0eocc38b6fe36dd3b21@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 01:59:12PM -0400, Chuck Lever wrote:

 > > When trying to mount an nfs export, I got this oops..
 > >
 > > BUG: unable to handle kernel paging request at f4569000
 > > IP: [<f8daac01>] :sunrpc:xdr_encode_opaque_fixed+0x2d/0x69
 > > *pde = 34c23163 *pte = 34569160
 > > Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
 > > Modules linked in: nfs nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc ext2 sg button via_rhine via_ircc pcspkr r8169 mii pata_sil680 irda crc_ccitt i2c_viapro i2c_core dm_snapshot dm_zero dm_mirror dm_log dm_mod pata_via ata_generic pata_acpi libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
 > > ...
 > > Code: e5 57 56 89 d6 53 83 ec 04 85 c9 89 45 f0 89 c8 74 4c 8d 59 03 c1 eb 02 8d 14 9d 00 00 00 00 29 ca 85 f6 74 11 c1 e9 02 8b 7d f0 <f3> a5 89 c1 83 e1 03 74 02 f3 a4 85 d2 74 1b 8b 7d f0 89 d1 c1
 > > EIP: [<f8daac01>] xdr_encode_opaque_fixed+0x2d/0x69 [sunrpc] SS:ESP 0068:f4566a68
 > > ---[ end trace a8a691a45122c25a ]---
 > > mount.nfs used greatest stack depth: 812 bytes left
 > 
 > The last line suggests you are trying this with 4KB kernel stacks.  I
 > have patches queued for .27 that provide some stack relief in this
 > code path.  If you hit this often, you might want to try with 8KB
 > stacks to see if that helps.

Yes, Fedora kernels have been using 4K stacks for some time.
>From the trace though, it doesn't look like we actually ran out of
stack space ? 

 > In the meantime, the traceback is a little funky, so I can't see
 > directly what the root cause is.  Can you provide the full command
 > line of the mount command that caused this?

mount point in the fstab is ..

gelk:/mnt/data      /mnt/nfs/gelk       nfs     nfsvers=3,tcp        0 0

 >  What "brand" of server were you trying to mount?

It's just another linux box. A no-name core2 duo, running 2.6.25.

 > How often can you reproduce this?

Seems to do it every time I ask it to.

	Dave

-- 
http://www.codemonkey.org.uk
