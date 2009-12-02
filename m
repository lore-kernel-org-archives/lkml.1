Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZLBCFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZLBCFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 21:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbZLBCFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 21:05:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbZLBCFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 21:05:44 -0500
Message-ID: <4B15CB48.6000509@redhat.com>
Date: Tue, 01 Dec 2009 21:04:56 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] high system time & lock contention running large mixed
 workload
References: <1259618429.2345.3.camel@dhcp-100-19-198.bos.redhat.com> <20091201100444.GN30235@random.random> <20091201212357.5C3A.A69D9226@jp.fujitsu.com> <20091201124619.GO30235@random.random>
In-Reply-To: <20091201124619.GO30235@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> I taken number 7 purely as mentioned by Larry about old code, but I
> don't mind what is the actual breakpoint level where we start to send
> the ipi flood to destroy all userland tlbs mapping the page so the
> young bit can be set by the cpu on the old pte. If you agree with me
> at the lowest priority we shouldn't flood ipi and destroy tlb when
> there's plenty of clean unmapped clean cache, we already agree ;). If
> that's 7 or DEV_PRIORITY-1, that's ok. All I care is that it escalates
> gradually, first clean cache and re-activate mapped pages, then when
> we're low on clean cache we start to check ptes and unmap whatever is
> not found referenced.
>    
>
The code already does what you propose.

It takes a heavy AIM7 run for Larry to run into the
lock contention issue.  I suspect that the page cache
was already very small by the time the lock contention
issue was triggered.

Larry, do you have any more info on the state of the
VM when you see the lock contention?

Also, do you have the latest patches to shrink_list()
by Kosaki and me applied?
