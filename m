Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZEFIXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZEFIXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZEFIXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:23:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39053 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbZEFIXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:23:21 -0400
Date: Wed, 6 May 2009 04:23:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, jdike@addtoit.com,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 0/2] utrace/ptrace: simplify/cleanup ptrace attach
Message-ID: <20090506082300.GA16989@infradead.org>
References: <20090503185537.GA17071@redhat.com> <20090504184951.623CEFC32F@magilla.sf.frob.com> <20090504193016.GA17076@redhat.com> <20090504194348.BC0EBFC32F@magilla.sf.frob.com> <20090504163154.f3672a83.akpm@linux-foundation.org> <20090505230642.GA980@redhat.com> <20090506081225.GD8098@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506081225.GD8098@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 10:12:25AM +0200, Ingo Molnar wrote:
> Yes. But realize the fundamental reason for that: _without_ 
> ptrace-over-utrace the utrace core code is a big chunk of dead code 
> only used on the fringes. I see and agree with all the future uses 
> of utrace, but it's easy to be problem-free if a facility is not 
> used by anything significant.

The ptrace cleanups might be required for utrace, but they by
themselves don't make utrace any more useful without another
user.

> So a clean ptrace-over-utrace plugin is absolutely needed for utrace 
> to go upstream in v2.6.31. The ftrace plugin alone does not justify 
> it. The real prize here is a (much!) cleaner ptrace code. Once 
> ptrace is driven via utrace and it works, its value (and trust 
> level) will skyrocket.

There are two blockers for utrace:

 - first all architectures need to be converted to the ptrace world
   order with regsets, tracehooks and so on.  I hope we are on track
   to get this done now after I've pinged all arch maintainers.
 - we actually need a useful user of the utrace abstraction.  And just
   converting ptrace to make it slightly more complicated by using
   another abstraction just isn't it.  One useful bit that is in the
   queue is a in-kernel gdbstub for user process which would allow
   to get out of the ptrace and re-parenting mess for basic use
   cases.  But a really convincing user would be even better.

I don't think 2.6.31 is a very realistic target.  While a lot of arch
maintainers are working on their ptrace code 2.6.31 is just a too short
deadline, and I'm also not sure we'll have the ptrace code in shape
by then.  2.6.32 is much more realistic.
