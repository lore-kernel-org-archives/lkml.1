Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbZFCLNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbZFCLNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 07:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZFCLM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 07:12:57 -0400
Received: from smtp.nokia.com ([192.100.122.230]:24336 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbZFCLM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 07:12:56 -0400
Message-ID: <4A265A82.8060909@nokia.com>
Date: Wed, 03 Jun 2009 14:12:02 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Jun 2009 11:12:10.0169 (UTC) FILETIME=[23826A90:01C9E43C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Here's the 9th version of the writeback patches. Changes since v8:
> 
> - Fix a bdi_work on-stack allocation hang. I hope this fixes Ted's
>   issue.
> - Get rid of the explicit wait queues, we can just use wake_up_process()
>   since it's just for that one task.
> - Add separate "sync_supers" thread that makes sure that the dirty
>   super blocks get written. We cannot safely do this from bdi_forker_task(),
>   as that risks deadlocking on ->s_umount. Artem, I implemented this
>   by doing the wake ups from a timer so that it would be easier for you
>   to just deactivate the timer when there are no super blocks.

I wonder if you would consider to work on top of the latest VFS changes:

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git for-next

For me the problem is that my original patches were created against
the VFS tree, and they do not apply nicely to your tree. So what I've
tried to do - I applied your patches on top of the VFS tree. But they
did not apply cleanly either. I'm currently working on merging them,
but I thought it is better to ask if you already did this.
                                                                                              
-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
