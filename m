Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbZHDMv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbZHDMv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 08:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbZHDMv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 08:51:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51085 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397AbZHDMv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 08:51:57 -0400
Message-ID: <4A782FDF.40908@redhat.com>
Date: Tue, 04 Aug 2009 15:55:59 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 7/12] ksm: fix endless loop on oom
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils> <Pine.LNX.4.64.0908031315200.16754@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908031315200.16754@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> break_ksm has been looping endlessly ignoring VM_FAULT_OOM: that should
> only be a problem for ksmd when a memory control group imposes limits
> (normally the OOM killer will kill others with an mm until it succeeds);
> but in general (especially for MADV_UNMERGEABLE and KSM_RUN_UNMERGE) we
> do need to route the error (or kill) back to the caller (or sighandling).
>
> Test signal_pending in unmerge_ksm_pages, which could be a lengthy
> procedure if it has to spill into swap: returning -ERESTARTSYS so that
> trivial signals will restart but fatals will terminate (is that right?
> we do different things in different places in mm, none exactly this).
>
> unmerge_and_remove_all_rmap_items was forgetting to lock when going
> down the mm_list: fix that.  Whether it's successful or not, reset
> ksm_scan cursor to head; but only if it's successful, reset seqnr
> (shown in full_scans) - page counts will have gone down to zero.
>
> This patch leaves a significant OOM deadlock, but it's a good step
> on the way, and that deadlock is fixed in a subsequent patch.
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
>
>
>   
Better than before for sure, And I dont have in mind better and yet 
simple solution for the "failing to break the pages" then to just wait 
and catch them in the next scan, so ACK.

Acked-by: Izik Eidus <ieidus@redhat.com>

