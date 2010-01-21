Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528Ab0AUXwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0AUXwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 18:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487Ab0AUXwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 18:52:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47179 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab0AUXwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 18:52:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 22 Jan 2010 08:48:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       rientjes@google.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oom-kill: add lowmem usage aware oom kill handling
Message-Id: <20100122084856.600b2dd5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1264087124.1818.15.camel@barrios-desktop>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
	<1264087124.1818.15.camel@barrios-desktop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jan 2010 00:18:44 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Hi, Kame. 
> 
> On Thu, 2010-01-21 at 14:59 +0900, KAMEZAWA Hiroyuki wrote:
> > A patch for avoiding oom-serial-killer at lowmem shortage.
> > Patch is onto mmotm-2010/01/15 (depends on mm-count-lowmem-rss.patch)
> > Tested on x86-64/SMP + debug module(to allocated lowmem), works well.
> > 
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > One cause of OOM-Killer is memory shortage in lower zones.
> > (If memory is enough, lowmem_reserve_ratio works well. but..)
> > 
> > In lowmem-shortage oom-kill, oom-killer choses a vicitim process
> > on their vm size. But this kills a process which has lowmem memory
> > only if it's lucky. At last, there will be an oom-serial-killer.
> > 
> > Now, we have per-mm lowmem usage counter. We can make use of it
> > to select a good? victim.
> > 
> > This patch does
> >   - add CONSTRAINT_LOWMEM to oom's constraint type.
> >   - pass constraint to __badness()
> >   - change calculation based on constraint. If CONSTRAINT_LOWMEM,
> >     use low_rss instead of vmsize.
> 
> As far as low memory, it would be better to consider lowmem counter.
> But as you know, {vmsize VS rss} is debatable topic.
> Maybe someone doesn't like this idea. 
> 
About lowmem, vmsize never work well.

> So don't we need any test result at least?
My test result was very artificial, so I didn't attach the result.

 - Before this patch, sshd was killed at first.
 - After this patch, memory consumer of low-rss was killed.

> If we don't have this patch, it happens several innocent process
> killing. but we can't prevent it by this patch. 
> 
I can't catch what you mean.

> Sorry for bothering you.
> 

Hmm, boot option or CONFIG ? (CONFIG_OOMKILLER_EXTENSION ?)

I'm now writing fork-bomb detector again and want to remove current
"gathering child's vm_size" heuristics. I'd like to put that under
the same config, too.

Thanks,
-Kame






