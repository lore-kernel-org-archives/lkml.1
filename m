Return-Path: <linux-kernel-owner+w=401wt.eu-S932590AbZHZMSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbZHZMSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510AbZHZMST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:18:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417AbZHZMSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:18:18 -0400
Subject: Re: [PATCH] allow disabling IMA at runtime
From: Eric Paris <eparis@redhat.com>
To: Mimi Zohar <zohar@us.ibm.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Kyle McMartin <kyle@infradead.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       David Safford <David_Safford@watson.ibm.com>
In-Reply-To: <OF49FE725E.CE343CE0-ON8525761E.0041C9AD-8525761E.00429749@us.ibm.com>
References: <20090826021005.GD19494@bombadil.infradead.org>
	 <OF49FE725E.CE343CE0-ON8525761E.0041C9AD-8525761E.00429749@us.ibm.com>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 08:17:58 -0400
Message-Id: <1251289078.10206.7.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 08:07 -0400, Mimi Zohar wrote:
> Kyle McMartin <kyle@infradead.org> wrote on 08/25/2009 10:10:05 PM:
> 
> > From: Kyle McMartin <kyle@redhat.com>
> > 
> > Due to a memory leak in IMA that we're currently debugging in Fedora
> > rawhide, it would be nice to be able to disable that support at runtime.
> > Currently it's only able to be built in, and there's no toggle to avoid
> > initializing it.
> > 
> > Provide one, in order to enhance debuggability. If a user can reboot a
> > machine and edit its command line, one can do a far sight worse things
> > than disabling a security precaution.
> > 
> > Signed-off-by: Kyle McMartin <kyle@redhat.com>
> 
> Have you tried using Eric's patch
> "IMA: Minimal IMA policy and boot param for TCB IMA policy"
> (commit 5789ba3bd0a3cd20df5980ebf03358f2eb44fd67), which introduced
> the ima_tcb=1 command line option?  It wasn't backported to 2.6.30.

Hey Mimi, I was going to get in touch with you today, I don't really
think this patch is necessary.  Kyle hacked it together because it was a
quick and dirty 'fix' for a memory leak that he didn't want to hunt down
and he knows I won't let him compile IMA out *smile*.  Intended to try
to track it down this morning, but I'm getting swamped already, maybe
you can try to figure out what's going on before I get a chance to come
back to it this afternoon?

nfs_inode_cache       34     34   1824   17    8 : tunables    0    0    0 : slabdata      2      2      0
fuse_inode            22     22   1472   22    8 : tunables    0    0    0 : slabdata      1      1      0
rpc_inode_cache       40     40   1600   20    8 : tunables    0    0    0 : slabdata      2      2      0
btrfs_inode_cache  10622  10668   2328   14    8 : tunables    0    0    0 : slabdata    762    762      0
iint_cache        369714 369720    312   26    2 : tunables    0    0    0 : slabdata  14220  14220      0
mqueue_inode_cache     19     19   1664   19    8 : tunables    0    0    0 : slabdata      1      1      0
isofs_inode_cache      0      0   1288   25    8 : tunables    0    0    0 : slabdata      0      0      0
hugetlbfs_inode_cache     24     24   1312   24    8 : tunables    0    0    0 : slabdata      1      1      0
ext4_inode_cache       0      0   1864   17    8 : tunables    0    0    0 : slabdata      0      0      0
ext3_inode_cache      19     19   1656   19    8 : tunables    0    0    0 : slabdata      1      1      0
inotify_inode_mark_entry    253    255    240   17    1 : tunables    0    0    0 : slabdata     15     15      0
shmem_inode_cache   2740   3003   1560   21    8 : tunables    0    0    0 : slabdata    143    143      0
sock_inode_cache     902    920   1408   23    8 : tunables    0    0    0 : slabdata     40     40      0
proc_inode_cache    3060   3075   1288   25    8 : tunables    0    0    0 : slabdata    123    123      0
inode_cache         9943  10192   1240   26    8 : tunables    0    0    0 : slabdata    392    392      0
selinux_inode_security  27237  27838    264   31    2 : tunables    0    0    0 : slabdata    898    898      0

So the iint_cache is a LOT larger than all of the inode caches put
together.  This is a 2.6.31-0.167.rc6.git6.fc12.x86_64 kernel without
any kernel options.

-Eric

-Eric

