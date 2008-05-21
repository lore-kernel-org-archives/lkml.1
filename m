Return-Path: <linux-kernel-owner+w=401wt.eu-S935742AbYEUNup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935742AbYEUNup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933478AbYEUNug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:50:36 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:29927 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764843AbYEUNuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:50:35 -0400
In-Reply-To: <1211366932.6463.81.camel@lappy.programming.kicks-ass.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Subject: Re: [PATCH] consolidate all within() implementations
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFB0F9F059.CB24BBAD-ONC1257450.004B2B21-C1257450.004C05C8@de.ibm.com>
From: Peter 1 Oberparleiter <Peter.Oberparleiter@de.ibm.com>
Date: Wed, 21 May 2008 15:50:22 +0200
X-MIMETrack: Serialize by Router on D12ML066/12/M/IBM(Release 7.0.2FP2HF322 | September
 26, 2007) at 21/05/2008 15:50:32,
	Serialize complete at 21/05/2008 15:50:32
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> wrote on 21.05.2008 12:48:52:

> On Wed, 2008-05-21 at 12:33 +0200, Peter 1 Oberparleiter wrote:
> > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote on 21.05.2008 12:04:26:

> peter@lappy:~/tmp$ gcc -S -Os cmp*.c
> peter@lappy:~/tmp$ ls -la cmp*.o
> -rw-r--r-- 1 peter peter 752 2008-05-21 12:43 cmp2.o
> -rw-r--r-- 1 peter peter 743 2008-05-21 12:43 cmp.o

Yeah, but!

[oberpar@local cmp]$ gcc -c -O2 cmp*.c
[oberpar@local cmp]$ ls -la cmp*.o
-rw-r--r-- 1 oberpar oberpar 1352 May 21 15:40 cmp2.o
-rw-r--r-- 1 oberpar oberpar 1408 May 21 15:40 cmp.o

:)

> Also look at the .s output and notice mine doesn't have any additional
> branches ;-)

It really boils down to the question whether you want to trade
a bit of obviousness for a bit of efficiency/clever programming.
I vote for keeping the former.

> > > static inline int
> > > addr_within(const void *add, const void *start, const void *end)
> > > {
> > >    return addr_within_len(addr, start, 
> > >          (unsigned long)end - (unsigned long)start);
> > > }
> > 
> > For empty ranges (start > end), this produces different (less 
expected)
> > results than the previous version.
> 
> agreed, do we care about those?

Why not plan for the unexpected when it comes at little cost?


Regards,
  Peter
