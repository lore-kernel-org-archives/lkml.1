Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbZDBHvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbZDBHvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZDBHv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:51:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:50359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbZDBHv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:51:27 -0400
Message-ID: <49D46E72.7030301@kernel.org>
Date: Thu, 02 Apr 2009 16:51:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 08/17] bio: reimplement bio_copy_user_iov()
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-9-git-send-email-tj@kernel.org> <49D38D4B.7020701@panasas.com> <49D41729.4030407@kernel.org> <49D46A8E.2090002@panasas.com>
In-Reply-To: <49D46A8E.2090002@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 07:51:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> On 04/02/2009 04:38 AM, Tejun Heo wrote:
>> Hello, Boaz.
>>
>> Boaz Harrosh wrote:
>>> Please consider that this code-path is used by me, in exofs and
>>> pNFS-objcets in a very very hot path, where memory pressure is a
>>> common scenario.
>> One quick question.  Don't the above paths map kernel pages to a
>> request?
>>
> 
> Well vfs-page-cache pages. Any ideas?

In that case it would go through blk_rq_map_kern_sg(), so unless you
wanna change the blk_rq_map_kern_sg() interface such that it uses
bvec, the sgl overhead doesn't matter anyway.  Of course, if it has
been buidling bios directly, that is a different story.

Thanks.

-- 
tejun
