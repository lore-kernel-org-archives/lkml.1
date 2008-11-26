Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbYKZKRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbYKZKRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 05:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYKZKQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 05:16:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:44328 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbYKZKQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 05:16:56 -0500
Message-ID: <492D2224.7000302@kernel.org>
Date: Wed, 26 Nov 2008 19:17:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, greg@kroah.com
Subject: Re: [PATCH 5/5 UPDATED] CUSE: implement CUSE - Character device in
 Userspace
References: <1227190983-5820-1-git-send-email-tj@kernel.org>	<1227190983-5820-6-git-send-email-tj@kernel.org> <20081121211607.49e0ec84.akpm@linux-foundation.org> <4927BC9A.3000001@kernel.org> <4927BDC7.8020905@kernel.org> <E1L5HDg-0001Ty-1u@pomaz-ex.szeredi.hu>
In-Reply-To: <E1L5HDg-0001Ty-1u@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 26 Nov 2008 10:16:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Miklos Szeredi wrote:
> Hi Tejun,
> 
> Apologies for the late review.

:-)

> On Sat, 22 Nov 2008, Tejun Heo wrote:
>> + * cuse_conn	: contains fuse_conn and serves as bonding structure
>> + * channel	: file handle connected to the userland CUSE server
>> + * cdev		: the implemented character device
>> + * mnt		: vfsmount which serves dentry and inode for cdev
> 
> Hmm, this mount thing seems rather pointless to me.  I understand the
> motivation: to let the unmodified fuse functions use
> get_fuse_conn(inode) and get_node_id(inode).  But I think we should
> really bite the bullet and reimplement these functions so that they
> take fuse_conn and node_id as arguments instead of the inode (and
> separate out those parts which do really need the inode for the
> memory mappings).
> 
> It's a bit more work on the fuse side, but overall it results in a
> much cleaner architecture, don't you think?

Yes, I agree.  I was mostly being lazy.  I'll try to rip off mnt
assumption from FUSE and make CUSE bypass the mnt thing.

>> +	worker = kthread_run(cuse_init_worker, cuse_conn_get(cc),
>> +			     "cuse-init-pid%d", current->pid);
> 
> This could be done without a kthread, by setting the ->end() callback
> for the INIT request, no?

Indeed.  Will switch to ->end().

Thanks.

-- 
tejun
