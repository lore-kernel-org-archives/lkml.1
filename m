Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbYFBWdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbYFBWdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 18:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYFBWdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 18:33:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57029 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbYFBWdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 18:33:11 -0400
Subject: Re: Kernel marker has no performance impact on ia64.
From: Peter Zijlstra <peterz@infradead.org>
To: Hideo AOKI <haoki@redhat.com>
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <48447052.3030300@redhat.com>
References: <48447052.3030300@redhat.com>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 00:32:45 +0200
Message-Id: <1212445965.6269.22.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-02 at 18:12 -0400, Hideo AOKI wrote:
> Hello,
> 
> I evaluated overhead of kernel marker using linux-2.6-sched-fixes
> git tree, which includes several markers for LTTng, using an ia64
> server.
> 
> While the immediate trace mark feature isn't implemented on ia64,
> there is no major performance regression. So, I think that we 
> don't have any issues to propose merging marker point patches 
> into Linus's tree from the viewpoint of performance impact.

Performance is atm the least of the concerns regarding this work.

I'm still convinced markers are too ugly to live.

I also worry greatly about the fact that its too easy to expose too much
to user-space. There are no clear rules and the free form marker format
just begs for an inconsistent mess to arise.

IMHO the current free-form trace_mark() should be removed from the tree
- its great for ad-hoc debugging but its a disaster waiting to happen
for anything else. Anybody doing ad-hoc debugging can patch it in
themselves if needed.

Regular trace points can be custom made; this has the advantages that it
raises the implementation barrier and hopefully that encourages some
thought in the process. It also avoid the code from growing into
something that looks like someone had a long night of debugging.




