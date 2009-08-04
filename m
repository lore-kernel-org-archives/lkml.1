Return-Path: <linux-kernel-owner+w=401wt.eu-S933247AbZHDSXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247AbZHDSXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933184AbZHDSXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:23:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933131AbZHDSXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:23:50 -0400
Date: Tue, 4 Aug 2009 11:22:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Larry Woodman <lwoodman@redhat.com>, riel@redhat.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] tracing, page-allocator: Add a postprocessing
 script for page-allocator-related ftrace events
Message-Id: <20090804112246.4e6d0ab1.akpm@linux-foundation.org>
In-Reply-To: <1249409546-6343-5-git-send-email-mel@csn.ul.ie>
References: <1249409546-6343-1-git-send-email-mel@csn.ul.ie>
	<1249409546-6343-5-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Aug 2009 19:12:26 +0100 Mel Gorman <mel@csn.ul.ie> wrote:

> This patch adds a simple post-processing script for the page-allocator-related
> trace events. It can be used to give an indication of who the most
> allocator-intensive processes are and how often the zone lock was taken
> during the tracing period. Example output looks like
> 
> find-2840
>  o pages allocd            = 1877
>  o pages allocd under lock = 1817
>  o pages freed directly    = 9
>  o pcpu refills            = 1078
>  o migrate fallbacks       = 48
>    - fragmentation causing = 48
>      - severe              = 46
>      - moderate            = 2
>    - changed migratetype   = 7

The usual way of accumulating and presenting such measurements is via
/proc/vmstat.  How do we justify adding a completely new and different
way of doing something which we already do?
