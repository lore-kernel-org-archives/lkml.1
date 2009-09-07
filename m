Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZIGQzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZIGQzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 12:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbZIGQzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 12:55:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:54448 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZIGQzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 12:55:54 -0400
Subject: Re: [PATCH 4/6] perf_counter: Add PERF_COUNTER_IOC_SET_FILTER ioctl
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090907164852.GA6485@elte.hu>
References: <4AA4C04D.1050201@cn.fujitsu.com>
	 <4AA4C0B3.3070300@cn.fujitsu.com> <1252341871.7959.37.camel@laptop>
	 <20090907164852.GA6485@elte.hu>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 18:55:45 +0200
Message-Id: <1252342545.7959.42.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 18:48 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, 2009-09-07 at 16:13 +0800, Li Zefan wrote:
> > > Allow to set profile filter via ioctl.
> > 
> > Hrm,.. not at all sure about this.. what are the ABI implications?
> 
> I think the ABI should be fine if it's always a sub-set of C syntax. 
> That would be C expressions initially. Hm?

Right, so I've no clue what filter expressions look like, and the
changelog doesn't help us at all. It doesn't mention its a well
considered decision to henceforth freeze the expression syntax.

Of course, since filters so far only work with tracepoint things, and
since you can only come by tracepoint things through debugfs, and since
anything debugfs is basically a free-for-all ABI-less world, we might be
good, but then this is a very ill-defined ioctl() indeed.

So please, consider this well -- there might not be a second chance.

