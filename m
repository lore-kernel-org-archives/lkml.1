Return-Path: <linux-kernel-owner+w=401wt.eu-S933565AbXCKMwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565AbXCKMwO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 08:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933566AbXCKMwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 08:52:14 -0400
Received: from smtp.osdl.org ([65.172.181.24]:46351 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933565AbXCKMwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 08:52:13 -0400
Date: Sun, 11 Mar 2007 04:51:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kirill Korotaev <dev@sw.ru>
Cc: xemul@sw.ru, menage@google.com, vatsa@in.ibm.com, balbir@in.ibm.com,
       devel@openvz.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [RFC][PATCH 2/7] RSS controller core
Message-Id: <20070311045111.62d3e9f9.akpm@linux-foundation.org>
In-Reply-To: <45F3F581.9030503@sw.ru>
References: <45ED7DEC.7010403@sw.ru>
	<45ED80E1.7030406@sw.ru>
	<20070306140036.4e85bd2f.akpm@linux-foundation.org>
	<45F3F581.9030503@sw.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 11 Mar 2007 15:26:41 +0300 Kirill Korotaev <dev@sw.ru> wrote:
> Andrew Morton wrote:
> > On Tue, 06 Mar 2007 17:55:29 +0300
> > Pavel Emelianov <xemul@sw.ru> wrote:
> > 
> > 
> >>+struct rss_container {
> >>+	struct res_counter res;
> >>+	struct list_head page_list;
> >>+	struct container_subsys_state css;
> >>+};
> >>+
> >>+struct page_container {
> >>+	struct page *page;
> >>+	struct rss_container *cnt;
> >>+	struct list_head list;
> >>+};
> > 
> > 
> > ah.  This looks good.  I'll find a hunk of time to go through this work
> > and through Paul's patches.  It'd be good to get both patchsets lined
> > up in -mm within a couple of weeks.  But..
> > 
> > We need to decide whether we want to do per-container memory limitation via
> > these data structures, or whether we do it via a physical scan of some
> > software zone, possibly based on Mel's patches.
> i.e. a separate memzone for each container?

Yep.  Straightforward machine partitioning.  An attractive thing is that it
100% reuses existing page reclaim, unaltered.

> imho memzone approach is inconvinient for pages sharing and shares accounting.
> it also makes memory management more strict, forbids overcommiting
> per-container etc.

umm, who said they were requirements?

> Maybe you have some ideas how we can decide on this?

We need to work out what the requirements are before we can settle on an
implementation.

Sigh.  Who is running this show?   Anyone?

You can actually do a form of overcommittment by allowing multiple
containers to share one or more of the zones.  Whether that is sufficient
or suitable I don't know.  That depends on the requirements, and we haven't
even discussed those, let alone agreed to them.  

