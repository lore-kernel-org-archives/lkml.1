Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZCAKjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZCAKjD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 05:39:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbZCAKiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 05:38:52 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54153 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbZCAKiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 05:38:51 -0500
Date: Sun, 1 Mar 2009 19:37:38 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 20/20] Get rid of the concept of hot/cold page freeing
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       penberg@cs.helsinki.fi, riel@redhat.com, hannes@cmpxchg.org,
       linux-kernel@vger.kernel.org, ming.m.lin@intel.com,
       yanmin_zhang@linux.intel.com
In-Reply-To: <20090227113813.GB21296@wotan.suse.de>
References: <20090226171549.GH32756@csn.ul.ie> <20090227113813.GB21296@wotan.suse.de>
Message-Id: <20090301193624.6FDE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Feb 26, 2009 at 05:15:49PM +0000, Mel Gorman wrote:
> > On Thu, Feb 26, 2009 at 12:00:22PM -0500, Christoph Lameter wrote:
> > > I tried the general use of a pool of zeroed pages back in 2005. Zeroing
> > > made sense only if the code allocating the page did not immediately touch
> > > the cachelines of the page.
> > 
> > Any feeling as to how often this was the case?
> 
> IMO background zeroing or anything like that is only going to
> become less attractive. Heat and energy considerations are
> relatively increasing, so doing speculative work in the kernel
> is going to become relatively more costly. 

IMHO..

In general, the value of any speculative approach depend on
forecast hitting rate.

e.g. readahead is very effective to sequential read workload, but 
no effective to random access workload.

zerod pages is always used from page_alloc(GFP_ZERO), it's valuable 
although nowadays. but it's impossible.

Then, (IMHO) rest problem is
  - What stastics is better mesurement for the forecast of future zero page
    demanding?
  - How implement it?


I have no idea yet..


> Especially in this
> case where you use nontemporal stores or otherwise reduce the
> efficiency of the CPU caches (and increase activity on bus and
> memory).



