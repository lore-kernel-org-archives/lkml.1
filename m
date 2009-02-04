Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbZBDPgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbZBDPgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbZBDPgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:36:45 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:60333 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753170AbZBDPgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:36:45 -0500
Date: Wed, 4 Feb 2009 18:36:43 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: =?utf8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 3/3] tracing: Tracers that use CALLER_ADDR macros
	should select FRAME_POINTER
Message-ID: <20090204153643.GA16681@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru> <20090204150840.GC30027@oksana.dev.rtsoft.ru> <c62985530902040726x34aeee7fr3b2937d898d3061e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530902040726x34aeee7fr3b2937d898d3061e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 04:26:15PM +0100, Frédéric Weisbecker wrote:
[...]
> > @@ -136,6 +138,7 @@ config SCHED_TRACER
> >        select TRACING
> >        select CONTEXT_SWITCH_TRACER
> >        select TRACER_MAX_TRACE
> > +       select FRAME_POINTER
> >        help
> >          This tracer tracks the latency of the highest priority task
> >          to be scheduled in, starting from the point it has woken up.
> > --
> 
> 
> Looks right.
> 
> BTW, how behaves builtin_return_address in case of !FRAME_POINTERS ?
> I guess it would only work with the first caller builtin_return_address(0)

It depends on the architecture. On PowerPC we always have frame pointers,
thus __builtin_return_address(1..) will always work. On x86 it won't work
that way.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
