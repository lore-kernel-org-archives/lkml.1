Return-Path: <linux-kernel-owner+w=401wt.eu-S933849AbZHEDHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849AbZHEDHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 23:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933421AbZHEDHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 23:07:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33658 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933833AbZHEDHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 23:07:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] tracing, page-allocator: Add a postprocessing script for page-allocator-related ftrace events
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Larry Woodman <lwoodman@redhat.com>, riel@redhat.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
In-Reply-To: <20090804112246.4e6d0ab1.akpm@linux-foundation.org>
References: <1249409546-6343-5-git-send-email-mel@csn.ul.ie> <20090804112246.4e6d0ab1.akpm@linux-foundation.org>
Message-Id: <20090805113207.5B9C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  5 Aug 2009 12:07:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Tue,  4 Aug 2009 19:12:26 +0100 Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > This patch adds a simple post-processing script for the page-allocator-related
> > trace events. It can be used to give an indication of who the most
> > allocator-intensive processes are and how often the zone lock was taken
> > during the tracing period. Example output looks like
> > 
> > find-2840
> >  o pages allocd            = 1877
> >  o pages allocd under lock = 1817
> >  o pages freed directly    = 9
> >  o pcpu refills            = 1078
> >  o migrate fallbacks       = 48
> >    - fragmentation causing = 48
> >      - severe              = 46
> >      - moderate            = 2
> >    - changed migratetype   = 7
> 
> The usual way of accumulating and presenting such measurements is via
> /proc/vmstat.  How do we justify adding a completely new and different
> way of doing something which we already do?

I think this approach have following merit.

 - It can collect per-process information.
   (Of cource, ftrace event filter can filter more various condtion)
 - It can integrate perf-counter easily.
 -




