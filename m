Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbYGONRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbYGONRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 09:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbYGONRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 09:17:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285AbYGONRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 09:17:34 -0400
Date: Tue, 15 Jul 2008 09:16:52 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@devserv.devel.redhat.com
To: Andi Kleen <andi@firstfloor.org>
cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, davem@davemloft.net,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
In-Reply-To: <487C94CC.3090402@firstfloor.org>
Message-ID: <Pine.LNX.4.64.0807150913020.21598@devserv.devel.redhat.com>
References: <20080713.202035.172246136.davem@davemloft.net>
 <20080715024424R.fujita.tomonori@lab.ntt.co.jp>
 <Pine.LNX.4.64.0807141720350.30981@devserv.devel.redhat.com>
 <20080715114058A.fujita.tomonori@lab.ntt.co.jp>
 <Pine.LNX.4.64.0807150759430.12202@devserv.devel.redhat.com>
 <487C94CC.3090402@firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, Andi Kleen wrote:

> Mikulas Patocka wrote:
>>>> BTW. what should the block device driver do when it receives a mapping
>>>> error? (if it aborts the request and it was write request, there will be
>>>> data corruption).
>>>
>>> I'm not sure how a aborted request can corrupt data on disk.
>>
>> Writes are done by an async daemon and no one checks for their
>> completion status. If there are three writes to directory, inode table
>> and inode bitmap and one of these writes fail, there's no code to undo
>> the other two. So the filesystem will be corrupted on write failure.
>
> Normally journaling in ordered mode takes care of that. The transaction
> is not committed until all earlier data has been successfully written.

And if there was write error, then what happens? Retry? Blocking of any 
further updates?

> And even the other fs typically turn the file system read only
> on IO error to prevent further corruption.

There is no interface how filesystem could query that buffer marked with 
mark_buffer_dirty was not written. Or is there?

Mikulas
