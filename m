Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbYLCNqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbYLCNqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 08:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbYLCNqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 08:46:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41105 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbYLCNqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 08:46:38 -0500
Message-ID: <49368DAF.9060206@redhat.com>
Date: Wed, 03 Dec 2008 08:46:23 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [PATCH] vmscan: improve reclaim throuput to bail out patch
References: <49316CAF.2010006@redhat.com> <20081130150849.8140.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081203140419.1D44.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081203140419.1D44.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi
> 
> I evaluate rvr bailout and skip-freeing patch in this week conteniously.
> I'd like to dump first output here.
> 
> 
> 
> Rik, could you please review following?
> ==
> vmscan bail out patch move nr_reclaimed variable to struct scan_control.
> Unfortunately, indirect access can easily happen cache miss.
> More unfortunately, Some architecture (e.g. ia64) don't access global
> variable so fast.

That is amazing.  Especially considering that the scan_control
is a local variable on the stack.

> if heavy memory pressure happend, that's ok.
> cache miss already plenty. it is not observable.
> 
> but, if memory pressure is lite, performance degression is obserbable.

> about 4-5% degression.
> 
> Then, this patch introduce temporal local variable.

> OK. the degression is disappeared.

I can't argue with the numbers, though :)

Maybe all the scanning we do ends up evicting the cache lines
with the scan_control struct in it from the fast part of the
CPU cache?

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
