Return-Path: <linux-kernel-owner+w=401wt.eu-S1757145AbZHGIAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbZHGIAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbZHGIAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:00:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55666 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187AbZHGIAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:00:49 -0400
Date: Fri, 7 Aug 2009 10:00:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 4/6] tracing, page-allocator: Add a postprocessing
	script for page-allocator-related ftrace events
Message-ID: <20090807080018.GD20292@elte.hu>
References: <1249574827-18745-1-git-send-email-mel@csn.ul.ie> <1249574827-18745-5-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249574827-18745-5-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mel@csn.ul.ie> wrote:

> This patch adds a simple post-processing script for the 
> page-allocator-related trace events. It can be used to give an 
> indication of who the most allocator-intensive processes are and 
> how often the zone lock was taken during the tracing period. 
> Example output looks like

Note, this script hard-codes certain aspects of the output format:

+my $regex_traceevent =
+'\s*([a-zA-Z0-9-]*)\s*(\[[0-9]*\])\s*([0-9.]*):\s*([a-zA-Z_]*):\s*(.*)';
+my $regex_fragdetails = 'page=([0-9a-f]*) pfn=([0-9]*) alloc_order=([0-9]*)
+fallback_order=([0-9]*) pageblock_order=([0-9]*) alloc_migratetype=([0-9]*)
+fallback_migratetype=([0-9]*) fragmenting=([0-9]) change_ownership=([0-9])';
+my $regex_statname = '[-0-9]*\s\((.*)\).*';
+my $regex_statppid = '[-0-9]*\s\(.*\)\s[A-Za-z]\s([0-9]*).*';

the proper appproach is to parse /debug/tracing/events/mm/*/format. 
That is why we emit a format string - to detach tools and reduce the 
semi-ABI effect.

	Ingo
