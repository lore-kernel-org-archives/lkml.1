Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab0CKXmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 18:42:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455Ab0CKXmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 18:42:03 -0500
Date: Thu, 11 Mar 2010 15:41:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Avoid the use of congestion_wait under zone
 pressure
Message-Id: <20100311154124.e1e23900.akpm@linux-foundation.org>
In-Reply-To: <1268048904-19397-1-git-send-email-mel@csn.ul.ie>
References: <1268048904-19397-1-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  8 Mar 2010 11:48:20 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> Under memory pressure, the page allocator and kswapd can go to sleep using
> congestion_wait(). In two of these cases, it may not be the appropriate
> action as congestion may not be the problem.

clear_bdi_congested() is called each time a write completes and the
queue is below the congestion threshold.

So if the page allocator or kswapd call congestion_wait() against a
non-congested queue, they'll wake up on the very next write completion.

Hence the above-quoted claim seems to me to be a significant mis-analysis and
perhaps explains why the patchset didn't seem to help anything?
