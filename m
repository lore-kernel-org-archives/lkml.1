Return-Path: <linux-kernel-owner+w=401wt.eu-S1764905AbZFQKG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764905AbZFQKG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 06:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZFQKGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 06:06:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51199 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZFQKGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 06:06:46 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 0/3] Fix malloc() stall in zone_reclaim() and bring behaviour more in line with expectations V3
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       fengguang.wu@intel.com, linuxram@us.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <alpine.DEB.1.10.0906161049180.26093@gentwo.org>
References: <20090616134423.GD14241@csn.ul.ie> <alpine.DEB.1.10.0906161049180.26093@gentwo.org>
Message-Id: <20090617190204.99C6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 17 Jun 2009 19:06:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 16 Jun 2009, Mel Gorman wrote:
> 
> > I don't have a particular workload in mind to be perfectly honest. I'm just not
> > convinced of the wisdom of trying to unmap pages by default in zone_reclaim()
> > just because the NUMA distances happen to be large.
> 
> zone reclaim = 1 is supposed to be light weight with minimal impact. The
> intend was just to remove potentially unused pagecache pages so that node
> local allocations can succeed again. So lets not unmap pages.

hm, At least major two zone reclaim developer disagree my patch. Thus I have to
agree with you, because I really don't hope to ignore other developer's opnion.

So, as far as I understand, the conclusion of this thread are
  - Drop my patch
  - instead, implement improvement patch of (may_unmap && page_mapped()) case
  - the documentation should be changed
  - it's my homework(?)

Can you agree this?



