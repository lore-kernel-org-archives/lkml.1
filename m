Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbZDVQam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbZDVQam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 12:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZDVQad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 12:30:33 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36423 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZDVQad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 12:30:33 -0400
Date: Wed, 22 Apr 2009 18:30:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Wolfram Strepp <wstrepp@gmx.de>
Subject: Re: [BUG] rbtree bug with mmotm 2009-04-14-17-24
Message-ID: <20090422163032.GV4593@kernel.dk>
References: <20090421184223.GP19637@balbir.in.ibm.com> <49EE42CC.7070002@opengridcomputing.com> <20090422131703.GO4593@kernel.dk> <49EF2882.1020306@opengridcomputing.com> <49EF293F.4030504@opengridcomputing.com> <49EF2C32.4030409@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EF2C32.4030409@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22 2009, Steve Wise wrote:
>
>>>
>>> No there are a few patches applied that are heading upstream, but one 
>>> is in the NFS RDMA server which isn't loaded yet and the rest are in  
>>> iw_cxgb3 (iwarp driver) which also hasn't loaded at the time we  
>>> crash. NOTE:  Out of 4 power cycles, one booted up ok, 3 hit the 
>>> crash.
>>>
>>>
>>>
>>
>> By the way, this one looks different from the last one I saw.  So its  
>> not consistently crashing in the same spot.  The one I hit yesterday  
>> (which I don't have the OOPs dump for was in rb_erase().
>>
>> Steve.
>
> I'll start bisecting to isolate this.

Don't bother, I see what the bug is now. It's caused by commit
a36e71f996e25d6213f57951f7ae1874086ec57e and it's due to ->ioprio being
changed without the prio rb root being adjusted.

I'll provide a fix shortly.

-- 
Jens Axboe

