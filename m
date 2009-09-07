Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbZIGQek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbZIGQek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 12:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbZIGQej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 12:34:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbZIGQei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 12:34:38 -0400
Message-ID: <4AA537E9.8030800@redhat.com>
Date: Mon, 07 Sep 2009 19:42:17 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/3] ksm: unmerge is an origin of OOMs
References: <Pine.LNX.4.64.0909052219580.7381@sister.anvils> <Pine.LNX.4.64.0909052222430.7387@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909052222430.7387@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Just as the swapoff system call allocates many pages of RAM to various
> processes, perhaps triggering OOM, so "echo 2 >/sys/kernel/mm/ksm/run"
> (unmerge) is liable to allocate many pages of RAM to various processes,
> perhaps triggering OOM; and each is normally run from a modest admin
> process (swapoff or shell), easily repeated until it succeeds.
>
> So treat unmerge_and_remove_all_rmap_items() in the same way that we
> treat try_to_unuse(): generalize PF_SWAPOFF to PF_OOM_ORIGIN, and
> bracket both with that, to ask the OOM killer to kill them first,
> to prevent them from spawning more and more OOM kills.
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
>   

Acked-by: Izik Eidus <ieidus@redhat.com>
