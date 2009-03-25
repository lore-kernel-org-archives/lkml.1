Return-Path: <linux-kernel-owner+w=401wt.eu-S1763411AbZCYQNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763411AbZCYQNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759168AbZCYQNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:13:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:39669 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbZCYQNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:13:45 -0400
Message-ID: <49CA582B.9080706@kernel.org>
Date: Thu, 26 Mar 2009 01:13:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Grant Grundler <grundler@google.com>
CC: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 02/10] ide-tape: use single continuous buffer
References: <1237990673-8358-1-git-send-email-tj@kernel.org>	 <1237990673-8358-3-git-send-email-tj@kernel.org> <da824cf30903250904n211b157eje2db99b0bdb1f33a@mail.gmail.com>
In-Reply-To: <da824cf30903250904n211b157eje2db99b0bdb1f33a@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 16:13:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Grant.

Grant Grundler wrote:
> On Wed, Mar 25, 2009 at 7:17 AM, Tejun Heo <tj@kernel.org> wrote:
>> Impact: simpler buffer allocation and handling, fix DMA transfers
> ...
>> +               atomic_set(&bh->b_count, bcount);
>>                if (atomic_read(&bh->b_count) == bh->b_size)
> ...
> 
> I'm failing to see why bh->b_count is an atomic_t.
> I always assumed tapes were exclusive access devices
> and would be serialized at a higher level.

Beats me.  I don't know.  The code is generally pretty over-engineered
but, well, it's an ancient piece of code with (probably too) rich
history.

>> -       ide_tape_kfree_buffer(tape);
>> -       return NULL;
>> +       bh->b_size = tape->buffer_size;
>> +       atomic_set(&bh->b_count, full ? bh->b_size : 0);
> 
> No one else could possibly be referencing bh->count at this
> point...I like that it's consistent though.

Yeah, this patch is just one of logical steps to remove bh, so it
doesn't make any other changes than described.  The whole bh stuff
will be removed later in the series.

> The use of atomic won't hurt correctness and this patch looks fine to me.
> Please add "Reviewed-by: Grant Grundler <grundler@google.com>"

Thanks.

-- 
tejun
