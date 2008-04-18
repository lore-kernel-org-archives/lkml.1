Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbYDRKIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbYDRKIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 06:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbYDRKI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 06:08:29 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:29029 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbYDRKI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 06:08:28 -0400
X-Greylist: delayed 2124 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Apr 2008 06:08:27 EDT
Date: Fri, 18 Apr 2008 11:33:01 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
In-Reply-To: <20080417185158.GA26603@elte.hu>
Message-ID: <Pine.BSO.4.63.0804181059090.2102@rudy.mif.pg.gda.pl>
References: <20080416202338.GA6007@elte.hu> <20080417002552.5742ad65.akpm@linux-foundation.org>
 <84144f020804170045s24cbb802u3358ec6b5d391a10@mail.gmail.com>
 <20080417012051.ed56f4ab.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0804171130090.4929@sbz-30.cs.Helsinki.FI>
 <84144f020804170134k4c98f022xc247442592fb1a44@mail.gmail.com>
 <20080417014217.ab0453a9.akpm@linux-foundation.org> <20080417114900.GA17033@infradead.org>
 <20080417110135.08b076ac.akpm@linux-foundation.org> <20080417185158.GA26603@elte.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-189012854-1208509882=:2102"
Content-ID: <Pine.BSO.4.63.0804181111540.2102@rudy.mif.pg.gda.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-189012854-1208509882=:2102
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2; FORMAT=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.BSO.4.63.0804181111541.2102@rudy.mif.pg.gda.pl>

On Thu, 17 Apr 2008, Ingo Molnar wrote:

>
> * Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> afaik the sysprof-vs-oprofile issue still hasn't been settled.  Maybe
>> it's no longer a relevant question with the new code - I just don't
>> know. Everything went all quiet and then this stuff happened.
>
> i dont think there's any big issue here. Sysprof is a time and stack
> system-wide tracer/profiler, oprofile profiles CPU events - deep
> stacktracing is an afterthought there. And how do you set up oprofile to
> do precise time events?
>
> with sysprof you can do:
>
>  cd /sys/kernel/debug/tracing
>  echo sysprof > current_tracer
>  cat trace_pipe
>
> and you'll see the trace events go by, live. The user-space bits of
> sysprof have been ported over to ftrace/sysprof already and it's a
> really nice tool that shows a deep stack-trace based hierarchical
> "vertical" profile instead of the usual finegrained profile.

Does it meany Linux give up implementing DTrace way of 
tracing/instrumntation ? In last time I observe more and more signs 
inroducing parallel ways of tracing/instrumentations infrasctructures in 
Linux kernel where all this can be rolled into only one .. common. Strange 
but some of this tracing/instrumentations does not uses "zero cost probes"
but "near zero cost probes" (like this) and this will result only more and 
more bloated kernel code with statically injected instrumentations.

(DTrace have very hermecic source code. In this case it mean DTrace have 
*very* limited point of entry to all other source code. In case Linux 
numbers of points of entry to instrumented code seems constantly growing 
by introducing sometimes duplicationg instrumentations infrastructures: 
oprofile, Text editor, sysprof/ftrace, utrace, blktrace .. what will be 
next ?).

Is this any explanation this (looks like completly) ad hoc/haotic Linux
way ?

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko | *e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-189012854-1208509882=:2102--
