Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbYLPUqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbYLPUqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYLPUqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:46:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40159 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbYLPUqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:46:45 -0500
Date: Tue, 16 Dec 2008 21:46:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Alex Zeffertt <alex.zeffertt@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xen: add xenfs to allow usermode <-> Xen interaction
Message-ID: <20081216204616.GC14787@elte.hu>
References: <49480F39.2010102@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49480F39.2010102@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> [ Reviewers: This is in drivers/xen to keep it close to the code it is 
>   and will be using.  Would people prefer to see it in fs/xenfs? -J ]

> +config XENFS
> +	tristate "Xen filesystem"

there's about two dozen filesystems that live not in fs/*:

./net/socket.c:	register_filesystem(&sock_fs_type);
./net/sunrpc/rpc_pipe.c:	err = register_filesystem(&rpc_pipe_fs_type);
./security/selinux/selinuxfs.c:	err = register_filesystem(&sel_fs_type);
./security/inode.c:	retval = register_filesystem(&fs_type);
./security/smack/smackfs.c:	err = register_filesystem(&smk_fs_type);
./drivers/usb/core/inode.c:	retval = register_filesystem(&usb_fs_type);
./drivers/usb/gadget/inode.c:	status = register_filesystem (&gadgetfs_type);
./drivers/oprofile/oprofilefs.c:	return register_filesystem(&oprofilefs_type);
./drivers/misc/ibmasm/ibmasmfs.c:	return register_filesystem(&ibmasmfs_type);
./drivers/isdn/capi/capifs.c:	err = register_filesystem(&capifs_fs_type);
./drivers/infiniband/hw/ipath/ipath_fs.c:	return register_filesystem(&ipathfs_fs_type);
./drivers/infiniband/core/uverbs_main.c:	ret = register_filesystem(&uverbs_event_fs);
./mm/shmem.c:	error = register_filesystem(&tmpfs_fs_type);
./mm/tiny-shmem.c:	BUG_ON(register_filesystem(&tmpfs_fs_type) != 0);
./ipc/mqueue.c:	error = register_filesystem(&mqueue_fs_type);
./kernel/cpuset.c:	err = register_filesystem(&cpuset_fs_type);
./kernel/cgroup.c:	err = register_filesystem(&cgroup_fs_type);
./include/linux/fs.h:extern int register_filesystem(struct file_system_type *);
./arch/s390/hypfs/inode.c:	rc = register_filesystem(&hypfs_type);
./arch/ia64/kernel/perfmon.c:	int err = register_filesystem(&pfm_fs_type);
./arch/powerpc/platforms/cell/spufs/inode.c:	ret = register_filesystem(&spufs_type);

by the looks of it it wants to live in drivers/xen/. It's a minimalistic 
API-only filesystem.

Nevertheless it would be nice to have Acks from FS experts. Security, 
races, obsoleteness of approach, etc.

	Ingo
