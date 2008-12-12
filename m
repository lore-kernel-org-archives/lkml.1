Return-Path: <linux-kernel-owner+w=401wt.eu-S1759328AbYLLQhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbYLLQhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 11:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757904AbYLLQhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 11:37:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57934 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757727AbYLLQhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 11:37:39 -0500
Message-ID: <494292D4.6090302@redhat.com>
Date: Fri, 12 Dec 2008 11:35:32 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jean Delvare <khali@linux-fr.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Fix LSF default inconsistency
References: <20081211202923.330F.KOSAKI.MOTOHIRO@jp.fujitsu.com>  <20081211113646.GI23742@kernel.dk>  <20081211204006.3312.KOSAKI.MOTOHIRO@jp.fujitsu.com>  <20081212075844.GH23742@kernel.dk> <49426C16.6040108@redhat.com> <2f11576a0812120711l130e07c3x94ff3b1e64959edf@mail.gmail.com> <Pine.LNX.4.64.0812121559220.19722@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0812121559220.19722@blonde.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Sat, 13 Dec 2008, KOSAKI Motohiro wrote:
>   
>> To move mlocked file cache page to unevictable list is useful although
>> swapless embedded device.
>>     
>
> Yes, I don't understand why Rik suggested CONFIG_SWAP for it either.
On swapless systems (with CONFIG_SWAP=n), we never scan
the anon lists, so we do not need to split out the mlocked pages from
the anon pages.

On a system with swap, we want to split out the mlocked pages
so that scan balancing always works right.  So whenever
CONFIG_SWAP is on, we want CONFIG_UNEVICTABLE_LRU
to be on as well.

That means we can replace CONFIG_UNEVICTABLE_LRU
with CONFIG_SWAP throughout the code, and get a kernel
with the desired behaviour either way.


