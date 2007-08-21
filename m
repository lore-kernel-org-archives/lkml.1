Return-Path: <linux-kernel-owner+w=401wt.eu-S1762475AbXHUPVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762475AbXHUPVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 11:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758846AbXHUPVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 11:21:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334AbXHUPVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 11:21:35 -0400
Message-ID: <46CB01B7.3050201@redhat.com>
Date: Tue, 21 Aug 2007 11:16:07 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC 0/7] Postphone reclaim laundry to write at high water marks
References: <20070820215040.937296148@sgi.com>
In-Reply-To: <20070820215040.937296148@sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:

> 1. First reclaiming non dirty pages. Dirty pages are deferred until reclaim
>    has reestablished the high marks. Then all the dirty pages (the laundry)
>    is written out.

That sounds like a horrendously bad idea.  While one process
is busy freeing all the non dirty pages, other processes can
allocate those pages, leaving you with no memory to free up
the dirty pages!

How exactly are you planning to prevent that problem?

Also, writing out all the dirty pages at once seems like it
could hurt latency quite badly, especially on large systems.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
