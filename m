Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbZGAES4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbZGAES4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 00:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZGAESl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 00:18:41 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:32943 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbZGAESk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 00:18:40 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@gmail.com>
Subject: Re: Found the commit that causes the OOMs
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       David Howells <dhowells@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
In-Reply-To: <20090701040649.GA12832@localhost>
References: <4A4AD07E.2040508@redhat.com> <20090701040649.GA12832@localhost>
Message-Id: <20090701131734.85D9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Jul 2009 13:18:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jun 30, 2009 at 10:57:02PM -0400, Rik van Riel wrote:
> > KOSAKI Motohiro wrote:
> >
> >>> [ 1522.019259] Active_anon:11 active_file:6 inactive_anon:0
> >>> [ 1522.019260]  inactive_file:0 unevictable:0 dirty:0 writeback:0 unstable:0
> >>> [ 1522.019261]  free:1985 slab:44399 mapped:132 pagetables:61830 bounce:0
> >>> [ 1522.019262]  isolate:69817
> >>
> >> OK. thanks.
> >> I plan to submit this patch after small more tests. it is useful for OOM analysis.
> >
> > It is also useful for throttling page reclaim.
> >
> > If more than half of the inactive pages in a zone are
> > isolated, we are probably beyond the point where adding
> > additional reclaim processes will do more harm than good.
> 
> There are probably more problems in this case. For example,
> followed is the vmstat after first (successful) run of msgctl11.
> 
> The question is: Why kswapd reclaims are absent here?

if direct reclaim isolate all pages, kswapd can't reclaim any pages.

I believe Rik's idea solve this problem.


