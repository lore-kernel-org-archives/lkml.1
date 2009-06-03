Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbZFCLms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbZFCLms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 07:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbZFCLml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 07:42:41 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44154 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbZFCLmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 07:42:40 -0400
Date: Wed, 3 Jun 2009 13:42:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-ID: <20090603114241.GN11363@kernel.dk>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <4A265A82.8060909@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A265A82.8060909@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03 2009, Artem Bityutskiy wrote:
> Jens Axboe wrote:
>> Here's the 9th version of the writeback patches. Changes since v8:
>>
>> - Fix a bdi_work on-stack allocation hang. I hope this fixes Ted's
>>   issue.
>> - Get rid of the explicit wait queues, we can just use wake_up_process()
>>   since it's just for that one task.
>> - Add separate "sync_supers" thread that makes sure that the dirty
>>   super blocks get written. We cannot safely do this from bdi_forker_task(),
>>   as that risks deadlocking on ->s_umount. Artem, I implemented this
>>   by doing the wake ups from a timer so that it would be easier for you
>>   to just deactivate the timer when there are no super blocks.
>
> I wonder if you would consider to work on top of the latest VFS changes:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git for-next
>
> For me the problem is that my original patches were created against
> the VFS tree, and they do not apply nicely to your tree. So what I've
> tried to do - I applied your patches on top of the VFS tree. But they
> did not apply cleanly either. I'm currently working on merging them,
> but I thought it is better to ask if you already did this.

Al, what's the time frame for submitting these vfs changes? I'm assuming
2.6.31 since it's called for-next. If that is the case, then it would be
for the best if I rebase on top of those.

So, to answer your other ping mail as well, my writeback changes will
then be based on top off the vfs tree and then your 0-17 patches. Then
we should have a joint base to work from.

-- 
Jens Axboe

