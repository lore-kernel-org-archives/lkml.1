Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbZH0M5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbZH0M5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZH0M5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:57:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbZH0M5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:57:44 -0400
Subject: Re: [PATCH] allow disabling IMA at runtime
From: Eric Paris <eparis@redhat.com>
To: David Safford <david.safford@gmail.com>
Cc: zohar@us.ibm.com, Kyle McMartin <kyle@mcmartin.ca>,
       "'David Safford'" <safford@us.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <a788e9ca0908270530s50a7e7fdu5c48299403b80d9b@mail.gmail.com>
References: <a788e9ca0908270530s50a7e7fdu5c48299403b80d9b@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 08:57:29 -0400
Message-Id: <1251377849.2280.21.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 08:30 -0400, David Safford wrote:
> >Hey Mimi, I was going to get in touch with you today, I don't really
> >think this patch is necessary.  Kyle hacked it together because it was a
> >quick and dirty 'fix' for a memory leak that he didn't want to hunt down
> >and he knows I won't let him compile IMA out *smile*.  Intended to try
> >to track it down this morning, but I'm getting swamped already, maybe
> >you can try to figure out what's going on before I get a chance to come
> >back to it this afternoon?
> >
> >nfs_inode_cache       34     34   1824   17    8 : tunables    0    0    0 : slabdata      2      2      0
> >fuse_inode            22     22   1472   22    8 : tunables    0    0    0 : slabdata      1      1      0
> >rpc_inode_cache       40     40   1600   20    8 : tunables    0    0    0 : slabdata      2      2      0
> >btrfs_inode_cache  10622  10668   2328   14    8 : tunables    0    0    0 : slabdata    762    762      0
> >iint_cache        369714 369720    312   26    2 : tunables    0    0    0 : slabdata  14220  14220      0
> >mqueue_inode_cache     19     19   1664   19    8 : tunables    0    0    0 : slabdata      1      1      0
> >isofs_inode_cache      0      0   1288   25    8 : tunables    0    0    0 : slabdata      0      0      0
> >hugetlbfs_inode_cache     24     24   1312   24    8 : tunables    0    0    0 : slabdata      1      1      0
> >ext4_inode_cache       0      0   1864   17    8 : tunables    0    0    0 : slabdata      0      0      0
> >ext3_inode_cache      19     19   1656   19    8 : tunables    0    0    0 : slabdata      1      1      0
> >inotify_inode_mark_entry    253    255    240   17    1 : tunables    0    0    0 : slabdata     15     15      0
> >shmem_inode_cache   2740   3003   1560   21    8 : tunables    0    0    0 : slabdata    143    143      0
> >sock_inode_cache     902    920   1408   23    8 : tunables    0    0    0 : slabdata     40     40      0
> >proc_inode_cache    3060   3075   1288   25    8 : tunables    0    0    0 : slabdata    123    123      0
> >inode_cache         9943  10192   1240   26    8 : tunables    0    0    0 : slabdata    392    392      0
> >selinux_inode_security  27237  27838    264   31    2 : tunables    0    0    0 : slabdata    898    898      0
> >
> >So the iint_cache is a LOT larger than all of the inode caches put
> >together.  This is a 2.6.31-0.167.rc6.git6.fc12.x86_64 kernel without
> >any kernel options.
> >
> >-Eric
> >
> 
> Sorry about the delay - we had a major fiber cut in Hawthorne yesterday.
> I'm running 2.6.30.4, and here are my numbers, which look more reasonable.
> I'm guessing there may be a IMA free imbalance in btrfs, which we have
> not really tested. Are you getting imbalance messages?

I think I found it.
http://git.kernel.org/?p=linux/kernel/git/jmorris/security-testing-2.6.git;a=commitdiff;h=53a7197aff20e341487fca8575275056fe1c63e5

thanks!

-Eric

