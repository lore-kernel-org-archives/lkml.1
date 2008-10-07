Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbYJGSEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbYJGSEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 14:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbYJGSEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 14:04:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbYJGSEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 14:04:23 -0400
Date: Tue, 7 Oct 2008 11:04:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH, RFC] percpu_counters: make fbc->count read atomic on 32
 bit architecture
Message-Id: <20081007110407.f22b92e1.akpm@linux-foundation.org>
In-Reply-To: <1223373347.26330.19.camel@lappy.programming.kicks-ass.net>
References: <E1KmetO-00053M-5u@closure.thunk.org>
	<20081006232322.c383fac5.akpm@linux-foundation.org>
	<1223373347.26330.19.camel@lappy.programming.kicks-ass.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Oct 2008 11:55:47 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2008-10-06 at 23:23 -0700, Andrew Morton wrote:
> > On Sun, 05 Oct 2008 21:28:10 -0400 "Theodore Ts'o" <tytso@mit.edu> wrote:
> > 
> > > The following patch has been sitting in the ext4 patch queue for about
> > > six weeks.  It was there it was a suspected cause for block allocation
> > > bug.  As I recall, it we found the true root cause since then, but this
> > > has stuck around since it's a potential problem.  Andrew has expressed
> > > concerns that this patch might have performance impacts.
> > 
> > Performace impacts I guess we'll just have to put up with.  iirc I was
> > thinking that this implementation should be pushed down to a kernel-wide
> > atomic64_t and then the percpu_counters would just use that type.
> 
> something like so?

We should think about and document the contexts in which these things
can be used.  Possibly add runtime checks too.  afaict they shouldn't be used in
hard IRQs, and that's pretty unusual for an atomic type.


