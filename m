Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbZEKS4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbZEKS4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZEKS4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:56:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988AbZEKS4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:56:39 -0400
Date: Mon, 11 May 2009 11:51:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: chrisw@sous-sol.org, oleg@redhat.com, roland@redhat.com,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [patch 1/2] ptrace, security: rename ptrace_may_access =>
 ptrace_access_check
Message-Id: <20090511115122.2cf3e98d.akpm@linux-foundation.org>
In-Reply-To: <20090511133949.GA28533@elte.hu>
References: <20090507002133.02D05FC39E@magilla.sf.frob.com>
	<20090507063606.GA15220@redhat.com>
	<20090507082027.GD12285@elte.hu>
	<20090507083102.GA20125@redhat.com>
	<20090507083851.GA19133@elte.hu>
	<20090507085742.GB3036@sequoia.sous-sol.org>
	<20090507090459.GE19133@elte.hu>
	<20090507093124.GA355@elte.hu>
	<20090507094947.GA4911@elte.hu>
	<20090507125526.c257c23d.akpm@linux-foundation.org>
	<20090511133949.GA28533@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 15:39:49 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 7 May 2009 11:49:47 +0200
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > The ptrace_may_access() methods are named confusingly - some 
> > > variants return a bool, while the security subsystem methods have a 
> > > retval convention.
> > > 
> > > Rename it to ptrace_access_check, to reduce the confusion factor. A 
> > > followup patch eliminates the bool usage.
> > 
> > s/may_access/access_check/ is a poor change.  The new name conveys 
> > less information than the old one.
> > 
> > It's quite clear what the return value from "may_access" means.  
> 
> it isnt clear at all. In fact there's two variants: one that returns 
> 'int' and one that returns 'bool' - the two have inverted values.

Oh.  I was assuming this was a yesno-returning function.

> > It's less clear what the return value from a function called 
> > "access_check" means.
> >
> > Switching to something like ptrace_task_accessible() or 
> > ptrace_may_access_task() would be better.
> > 
> > This happens quite often.  The string "check" in the name of a 
> > predicate function is a red flag.
> 
> I disagree. To repeat the argument i made in this thread, the 'may' 
> suggests/attracts a logical value, i.e. yes or no, or boolean. But 
> that goes against the desire of actual call sites wanting a Linux 
> retval.
> 
> I.e. any function name that can be plain-English answered with: 
> 'yes' or 'no' is a red flag for a retval function.
> 
> You cannot answer ptrace_access_check() with 'yes' or 'no'. You 
> could if it was ptrace_access_ok() or ptrace_may_access.
> 

So what _are_ the semantics of the ptrace_may_access() return value?

<checks the code comments>

<stomps off in a huff>
