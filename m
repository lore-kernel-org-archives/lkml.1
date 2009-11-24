Return-Path: <linux-kernel-owner+w=401wt.eu-S933725AbZKXRuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933725AbZKXRuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 12:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757660AbZKXRun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 12:50:43 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:20934 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933700AbZKXRun convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 12:50:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JTjxrhybq7eysot7Xn3HNDWLSy7k13EwxeO8qbomSsp6HWr/2lnVObjjs0HPmztN+U
         mBZ7/u4kO+8dESGNUpJHdgqIDBmsDZiu0O/L6ceprJj64eYxSmHjBAOVglqTrb39814m
         f3P1udUCz59TgLM2qp5Koj89ClER9V+GNhTbw=
MIME-Version: 1.0
In-Reply-To: <4B0BBB83.2020604@klingt.org>
References: <4B0BBB83.2020604@klingt.org>
Date: Tue, 24 Nov 2009 12:50:48 -0500
Message-ID: <73c1f2160911240950u7256feedqc475fa915dda43ca@mail.gmail.com>
Subject: Re: [PATCH 0/5] branch hint tweaks
From: Brian Gerst <brgerst@gmail.com>
To: Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 5:54 AM, Tim Blechmann <tim@klingt.org> wrote:
> hi all,
>
> doing some branch hint profiling of 2.6.31 on my nehalem machine showed
> a few
> incorrect branch hints.
> these patches remove or change the branch hints
>
> Tim Blechmann (5):
>  process_64: remove branch hint
>  sched.c: change branch hint
>  slab.c: remove branch hint
>  sched_fair.c: remove branch hint
>  workqueue.c: remove branch hint
>
>  arch/x86/kernel/process_64.c |    4 ++--
>  kernel/sched.c               |    4 ++--
>  kernel/sched_fair.c          |    2 +-
>  kernel/workqueue.c           |    2 +-
>  mm/slab.c                    |    2 +-
>  5 files changed, 7 insertions(+), 7 deletions(-)

Did you run profiling tests again after making these changes to see if
they had any effect?  likely() and unlikely() are only hints.  GCC
doesn't have to follow them, or it could be broken in recent GCC
versions.

I'm not sure what version of GCC added this, but I wonder if this
option will fix the problem:

-fno-guess-branch-probability
    Do not guess branch probabilities using heuristics.

    GCC will use heuristics to guess branch probabilities if they are
not provided by profiling feedback (-fprofile-arcs). These heuristics
are based on the control flow graph. If some branch probabilities are
specified by `__builtin_expect', then the heuristics will be used to
guess branch probabilities for the rest of the control flow graph,
taking the `__builtin_expect' info into account. The interactions
between the heuristics and `__builtin_expect' can be complex, and in
some cases, it may be useful to disable the heuristics so that the
effects of `__builtin_expect' are easier to understand.

    The default is -fguess-branch-probability at levels -O, -O2, -O3, -Os.

--
Brian Gerst
