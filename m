Return-Path: <linux-kernel-owner+w=401wt.eu-S932649AbXCTM2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbXCTM2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 08:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932672AbXCTM2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 08:28:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932649AbXCTM2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 08:28:04 -0400
Message-ID: <45FFD34F.10809@redhat.com>
Date: Tue, 20 Mar 2007 08:27:59 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] split file and anonymous page queues #2
References: <45FF3052.0@redhat.com> <45FF7B3A.70709@yahoo.com.au>
In-Reply-To: <45FF7B3A.70709@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Rik van Riel wrote:

>> We apply pressure to each of sets of the pageout queues based on:
>> - the size of each queue
>> - the fraction of recently referenced pages in each queue,
>>    not counting used-once file pages
>> - swappiness (file IO is more efficient than swap IO)

> This ignores whether a file page is mapped, doesn't it?

> Even so, it could be a good approach anyway.

It does, but once it gets the file list down to the size
where it finds that a fair number of the pages were
referenced, it will back off the pressure automatically.

Also, we do not apply the used-once algorithm to mapped
pages, meaning that mapped pages with the accessed bit
set always get rotated back onto the active list, while
unmapped pages do not.

> There are a couple of little nice improvements you have there, such as
> treating shmem pages in the same class as anon pages. We found that we
> needed something similar, so some of those things should go upstream
> on their own.

It will be hard to merge that "on its own" without the
split queues.  I can't really think of a good way to
split this patch up into multiple functional bits...

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
