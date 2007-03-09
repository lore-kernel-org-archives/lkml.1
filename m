Return-Path: <linux-kernel-owner+w=401wt.eu-S1767393AbXCIQs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767393AbXCIQs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767395AbXCIQs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:48:58 -0500
Received: from MAIL.13thfloor.at ([213.145.232.33]:35140 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767393AbXCIQs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:48:56 -0500
Date: Fri, 9 Mar 2007 17:48:55 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelianov <xemul@sw.ru>, Kirill@smtp.osdl.org, Linux@smtp.osdl.org,
       containers@lists.osdl.org, Paul Menage <menage@google.com>,
       List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/7] RSS controller core
Message-ID: <20070309164855.GB3647@MAIL.13thfloor.at>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Pavel Emelianov <xemul@sw.ru>, Kirill@smtp.osdl.org,
	Linux@smtp.osdl.org, containers@lists.osdl.org,
	Paul Menage <menage@google.com>,
	List <linux-kernel@vger.kernel.org>
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru> <20070306140036.4e85bd2f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306140036.4e85bd2f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 02:00:36PM -0800, Andrew Morton wrote:
> On Tue, 06 Mar 2007 17:55:29 +0300
> Pavel Emelianov <xemul@sw.ru> wrote:
> 
> > +struct rss_container {
> > +	struct res_counter res;
> > +	struct list_head page_list;
> > +	struct container_subsys_state css;
> > +};
> > +
> > +struct page_container {
> > +	struct page *page;
> > +	struct rss_container *cnt;
> > +	struct list_head list;
> > +};
> 
> ah. This looks good. I'll find a hunk of time to go through this work
> and through Paul's patches. It'd be good to get both patchsets lined
> up in -mm within a couple of weeks. But..

doesn't look so good for me, mainly becaus of the 
additional per page data and per page processing

on 4GB memory, with 100 guests, 50% shared for each
guest, this basically means ~1mio pages, 500k shared
and 1500k x sizeof(page_container) entries, which
roughly boils down to ~25MB of wasted memory ...

increase the amount of shared pages and it starts
getting worse, but maybe I'm missing something here

> We need to decide whether we want to do per-container memory
> limitation via these data structures, or whether we do it via a
> physical scan of some software zone, possibly based on Mel's patches.

why not do simple page accounting (as done currently
in Linux) and use that for the limits, without
keeping the reference from container to page?

best,
Herbert

> _______________________________________________
> Containers mailing list
> Containers@lists.osdl.org
> https://lists.osdl.org/mailman/listinfo/containers
