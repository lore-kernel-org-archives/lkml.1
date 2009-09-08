Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbZIHIiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbZIHIiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 04:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbZIHIiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 04:38:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55784 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbZIHIiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 04:38:06 -0400
Subject: Re: [PATCH 4/6] perf_counter: Add PERF_COUNTER_IOC_SET_FILTER ioctl
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AA5AA0F.4060104@cn.fujitsu.com>
References: <4AA4C04D.1050201@cn.fujitsu.com>
	 <4AA4C0B3.3070300@cn.fujitsu.com> <1252341871.7959.37.camel@laptop>
	 <20090907164852.GA6485@elte.hu> <1252342545.7959.42.camel@laptop>
	 <4AA5AA0F.4060104@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 08 Sep 2009 10:37:52 +0200
Message-Id: <1252399072.7746.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 08:49 +0800, Li Zefan wrote:
> Peter Zijlstra wrote:
> > On Mon, 2009-09-07 at 18:48 +0200, Ingo Molnar wrote:
> >> * Peter Zijlstra <peterz@infradead.org> wrote:
> >>
> >>> On Mon, 2009-09-07 at 16:13 +0800, Li Zefan wrote:
> >>>> Allow to set profile filter via ioctl.
> >>> Hrm,.. not at all sure about this.. what are the ABI implications?
> >> I think the ABI should be fine if it's always a sub-set of C syntax. 
> >> That would be C expressions initially. Hm?
> > 
> > Right, so I've no clue what filter expressions look like, and the
> > changelog doesn't help us at all. It doesn't mention its a well
> > considered decision to henceforth freeze the expression syntax.
> > 
> > Of course, since filters so far only work with tracepoint things, and
> > since you can only come by tracepoint things through debugfs, and since
> > anything debugfs is basically a free-for-all ABI-less world, we might be
> > good, but then this is a very ill-defined ioctl() indeed.
> > 
> > So please, consider this well -- there might not be a second chance.
> > 
> 
> Ok, the expressions are:
> 
>   1. S = opr1 op opr2	(op: ==, !=, <, <=, >, >=.
> 			 opr1 should be a field in the format file)
>   2. E = S1 op S2	(op: ||, &&)
>   3. E = E1 op E2	(op: ||, &&)
>   4. () can be used
> 
> I don't the syntax will be changed, but we may extend it, like
> adding not ! operator. Like, for a func ptr, besides "func==0xccee4400",
> we may want to allow "func==foo". Those extentions are ok for the
> ABI, right?

Sure, but my point is that you need to be aware that you're creating an
ABI and the changelog was virtually non-existent which didn't inspire
much confidence.
