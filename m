Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbYIEJTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbYIEJTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 05:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYIEJTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 05:19:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43461 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbYIEJTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 05:19:39 -0400
To: hamid.jahanjou@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VM: Implements the swap-out page-clustering technique
From: Andi Kleen <andi@firstfloor.org>
References: <48BFCECE.90103@gmail.com>
Date: Fri, 05 Sep 2008 11:19:38 +0200
In-Reply-To: <48BFCECE.90103@gmail.com> (Hamid R. Jahanjou's message of "Thu, 04 Sep 2008 15:34:30 +0330")
Message-ID: <87iqtbuez9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Hamid R. Jahanjou" <hamid.jahanjou@gmail.com> writes:

> From: Hamid R. Jahanjou
>
> Implements the idea of swap-out page clustering from *BSD for
> Linux. Each time a candidate page is to be swapped out,
> virtually-nearby pages are scanned to find eligible pages to be
> swapped out too as a cluster. This technique increases the likelihood of
> bringing in related data on a page fault and decreases swap space
> fragmentation in the long run. Currently, Linux searches only
> physically-nearby pages which is not optimal since, over time, physically-
> adjacent pages may become unrelated.
>
> The code can be statically tuned. No benchmarks. I'm not sure whether
> the added complexity is acceptable.

Just some general comments:

First I think virtual swap clustering is a great idea in theory and
long overdue.  Hopefully the numbers will agree.

In general the code would be much nicer if you didn't pass around 
all that much in a structure (which is just a fancy way to have
a function with lots of arguments) Perhaps try to restructure
it a bit to make this smaller? Ideally clustering_info should disappear
or at least get much smaller.

Then continue_search seems to be only set to one value so it 
can be eliminated? Perhaps there is more like this.

I didn't quite understand the "adjust the value of our search by
the allocation order". The allocation order should be normally 0.
I think having a tunable for the cluster sizes would be a good idea.
At some point they might be even device dependent (e.g. on a flash
device you would like to have them roughly erase block sized) 

-Andi


-- 
ak@linux.intel.com
