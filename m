Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbXDECoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbXDECoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 22:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXDECoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 22:44:06 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48956 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbXDECoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 22:44:03 -0400
Subject: Re: 2.6.21-rc5-mm4 (SLUB)
From: Badari Pulavarty <pbadari@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704041730470.22161@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	 <1175637332.6185.4.camel@dyn9047017100.beaverton.ibm.com>
	 <1175642398.6185.9.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031626020.12109@schroedinger.engr.sgi.com>
	 <1175643507.6185.12.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031638570.12109@schroedinger.engr.sgi.com>
	 <1175644314.6185.18.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031653060.12109@schroedinger.engr.sgi.com>
	 <1175698437.6185.21.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704040946370.24640@schroedinger.engr.sgi.com>
	 <1175709755.6185.34.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704041103060.26866@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0704041120250.793@schroedinger.engr.sgi.com>
	 <1175727185.5019.8.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704041556530.11769@schroedinger.engr.sgi.com>
	 <1175730157.5019.19.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704041730470.22161@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 19:44:06 -0700
Message-Id: <1175741046.13125.0.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 17:31 -0700, Christoph Lameter wrote:
> On Wed, 4 Apr 2007, Badari Pulavarty wrote:
> 
> > On Wed, 2007-04-04 at 15:59 -0700, Christoph Lameter wrote:
> > > On Wed, 4 Apr 2007, Badari Pulavarty wrote:
> > > 
> > > > Here is the slub_debug=FU output with the above patch.
> > > 
> > > Hmmm... Looks like the object is actually free. Someone writes beyond the 
> > > end of the earlier object. Setting Z should check overwrites but it 
> > > switched off merging. So set
> > > 
> > > slub_debug = FZ
> > > 
> > > Analoguos to the last patch you would need to take out redzoning from 
> > > the flags that stop merging. Then rerun. Maybe we can track it down this 
> > > way.
> > 
> > Hmm.. I did that and machine boots fine, with absolutely no
> > debug messages :(
> 
> Were the slabs merged? Look at /sys/slab and see if there are any symlinks 
> there.
> 

elm3b29:/sys/slab # ls -ltr
total 0
drwxr-xr-x 2 root root 0 Apr  4 17:40 sock_inode_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 skbuff_fclone_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 sigqueue
drwxr-xr-x 2 root root 0 Apr  4 17:40 shmem_inode_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 radix_tree_node
drwxr-xr-x 2 root root 0 Apr  4 17:40 proc_inode_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 ip_dst_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 file_lock_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 blkdev_requests
drwxr-xr-x 2 root root 0 Apr  4 17:40 blkdev_queue
drwxr-xr-x 2 root root 0 Apr  4 17:40 blkdev_ioc
drwxr-xr-x 2 root root 0 Apr  4 17:40 biovec-64
drwxr-xr-x 2 root root 0 Apr  4 17:40 biovec-256
drwxr-xr-x 2 root root 0 Apr  4 17:40 biovec-128
drwxr-xr-x 2 root root 0 Apr  4 17:40 bdev_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 TCP
drwxr-xr-x 2 root root 0 Apr  4 17:40 Acpi-State
drwxr-xr-x 2 root root 0 Apr  4 17:40 Acpi-ParseExt
drwxr-xr-x 2 root root 0 Apr  4 17:40 Acpi-Operand
drwxr-xr-x 2 root root 0 Apr  4 17:40 Acpi-Namespace
drwxr-xr-x 2 root root 0 Apr  4 17:40 vm_area_struct
drwxr-xr-x 2 root root 0 Apr  4 17:40 task_struct
drwxr-xr-x 2 root root 0 Apr  4 17:40 sysfs_dir_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 signal_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 sighand_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 pid
drwxr-xr-x 2 root root 0 Apr  4 17:40 names_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 mm_struct
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmem_cache_node
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-96
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-8192
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-8
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-65536
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-64
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-512
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-4096
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-32768
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-32
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-262144
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-256
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-2048
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-192
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-16384
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-16
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-131072
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-128
drwxr-xr-x 2 root root 0 Apr  4 17:40 kmalloc-1024
drwxr-xr-x 2 root root 0 Apr  4 17:40 inode_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 idr_layer_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 fs_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 filp
drwxr-xr-x 2 root root 0 Apr  4 17:40 dentry_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 buffer_head
drwxr-xr-x 2 root root 0 Apr  4 17:40 anon_vma
drwxr-xr-x 2 root root 0 Apr  4 17:40 dquot
drwxr-xr-x 2 root root 0 Apr  4 17:40 reiser_inode_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 nfs_inode_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 nfs_direct_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 mqueue_inode_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 minix_inode_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 journal_head
drwxr-xr-x 2 root root 0 Apr  4 17:40 isofs_inode_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 hugetlbfs_inode_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 ext3_xattr
drwxr-xr-x 2 root root 0 Apr  4 17:40 ext3_inode_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 ext2_xattr
drwxr-xr-x 2 root root 0 Apr  4 17:40 ext2_inode_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 cfq_pool
drwxr-xr-x 2 root root 0 Apr  4 17:40 cfq_ioc_pool
drwxr-xr-x 2 root root 0 Apr  4 17:40 UNIX
drwxr-xr-x 2 root root 0 Apr  4 17:40 rpc_inode_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 rpc_buffers
drwxr-xr-x 2 root root 0 Apr  4 17:40 revokefs_inode_cache
drwxr-xr-x 2 root root 0 Apr  4 17:40 TCPv6
drwxr-xr-x 2 root root 0 Apr  4 17:54 fat_inode_cache
drwxr-xr-x 2 root root 0 Apr  4 17:54 fat_cache
drwxr-xr-x 2 root root 0 Apr  4 17:54 sgpool-64
drwxr-xr-x 2 root root 0 Apr  4 17:54 sgpool-32
drwxr-xr-x 2 root root 0 Apr  4 17:54 sgpool-128
drwxr-xr-x 2 root root 0 Apr  4 17:54 scsi_io_context
drwxr-xr-x 2 root root 0 Apr  4 17:55 jbd_4k
lrwxrwxrwx 1 root root 0 Apr  4 20:46 scsi_cmd_cache -> ../slab/ip_dst_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 xfrm_dst_cache -> ../slab/ip_dst_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 utrace_engine_cache -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 utrace_cache -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 uid_cache -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 tw_sock_TCPv6 -> ../slab/filp
lrwxrwxrwx 1 root root 0 Apr  4 20:46 tw_sock_TCP -> ../slab/filp
lrwxrwxrwx 1 root root 0 Apr  4 20:46 tcp_bind_bucket -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 skbuff_head_cache -> ../slab/filp
lrwxrwxrwx 1 root root 0 Apr  4 20:46 shared_policy_node -> ../slab/kmem_cache_node
lrwxrwxrwx 1 root root 0 Apr  4 20:46 sgpool-8 -> ../slab/filp
lrwxrwxrwx 1 root root 0 Apr  4 20:46 sgpool-16 -> ../slab/skbuff_fclone_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 secpath_cache -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 rpc_tasks -> ../slab/ip_dst_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 revoke_table -> ../slab/kmalloc-8
lrwxrwxrwx 1 root root 0 Apr  4 20:46 revoke_record -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 request_sock_TCPv6 -> ../slab/filp
lrwxrwxrwx 1 root root 0 Apr  4 20:46 request_sock_TCP -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 qla2xxx_srbs -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 posix_timers_cache -> ../slab/kmalloc-128
lrwxrwxrwx 1 root root 0 Apr  4 20:46 numa_policy -> ../slab/kmalloc-16
lrwxrwxrwx 1 root root 0 Apr  4 20:46 nfs_write_data -> ../slab/signal_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 nfs_read_data -> ../slab/signal_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 nfs_page -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 ndisc_cache -> ../slab/filp
lrwxrwxrwx 1 root root 0 Apr  4 20:46 mnt_cache -> ../slab/filp
lrwxrwxrwx 1 root root 0 Apr  4 20:46 kioctx -> ../slab/ip_dst_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 kiocb -> ../slab/filp
lrwxrwxrwx 1 root root 0 Apr  4 20:46 journal_handle -> ../slab/kmalloc-16
lrwxrwxrwx 1 root root 0 Apr  4 20:46 ip_mrt_cache -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 ip_fib_hash -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 ip_fib_alias -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 ip6_dst_cache -> ../slab/ip_dst_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 inotify_watch_cache -> ../slab/Acpi-Operand
lrwxrwxrwx 1 root root 0 Apr  4 20:46 inotify_event_cache -> ../slab/Acpi-Namespace
lrwxrwxrwx 1 root root 0 Apr  4 20:46 inet_peer_cache -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 flow_cache -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 files_cache -> ../slab/signal_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 fib6_nodes -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 fasync_cache -> ../slab/kmalloc-16
lrwxrwxrwx 1 root root 0 Apr  4 20:46 eventpoll_pwq -> ../slab/Acpi-Operand
lrwxrwxrwx 1 root root 0 Apr  4 20:46 eventpoll_epi -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 dnotify_cache -> ../slab/Acpi-Namespace
lrwxrwxrwx 1 root root 0 Apr  4 20:46 dm_tio -> ../slab/kmalloc-16
lrwxrwxrwx 1 root root 0 Apr  4 20:46 dm_io -> ../slab/Acpi-Namespace
lrwxrwxrwx 1 root root 0 Apr  4 20:46 configfs_dir_cache -> ../slab/Acpi-State
lrwxrwxrwx 1 root root 0 Apr  4 20:46 biovec-4 -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 biovec-16 -> ../slab/filp
lrwxrwxrwx 1 root root 0 Apr  4 20:46 biovec-1 -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 bio -> ../slab/fs_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 arp_cache -> ../slab/filp
lrwxrwxrwx 1 root root 0 Apr  4 20:46 UDPv6 -> ../slab/mm_struct
lrwxrwxrwx 1 root root 0 Apr  4 20:46 UDPLITEv6 -> ../slab/mm_struct
lrwxrwxrwx 1 root root 0 Apr  4 20:46 UDP-Lite -> ../slab/signal_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 UDP -> ../slab/signal_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 RAWv6 -> ../slab/mm_struct
lrwxrwxrwx 1 root root 0 Apr  4 20:46 RAW -> ../slab/signal_cache
lrwxrwxrwx 1 root root 0 Apr  4 20:46 Acpi-Parse -> ../slab/Acpi-Namespace


