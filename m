Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856Ab0AUPS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab0AUPS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339Ab0AUPS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:18:56 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:33716 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab0AUPSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:18:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hsrwiYuBjccsAnCVsUD3iZsha4fhhX0o9RhNBqCeqLVKOqH6z1BN3fM9HTEiLtYRuB
         yrJlxjLQLeDSyeXvqbhBur7olCjkydHpJkvssvZMVGATu6foYWS2yY1lgZ8Z0xp1n8XP
         /3F2sjTShq3mqzZoxcr5u53E9EeQJEojPD0GU=
Subject: Re: [PATCH] oom-kill: add lowmem usage aware oom kill handling
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       rientjes@google.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 00:18:44 +0900
Message-ID: <1264087124.1818.15.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kame. 

On Thu, 2010-01-21 at 14:59 +0900, KAMEZAWA Hiroyuki wrote:
> A patch for avoiding oom-serial-killer at lowmem shortage.
> Patch is onto mmotm-2010/01/15 (depends on mm-count-lowmem-rss.patch)
> Tested on x86-64/SMP + debug module(to allocated lowmem), works well.
> 
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> One cause of OOM-Killer is memory shortage in lower zones.
> (If memory is enough, lowmem_reserve_ratio works well. but..)
> 
> In lowmem-shortage oom-kill, oom-killer choses a vicitim process
> on their vm size. But this kills a process which has lowmem memory
> only if it's lucky. At last, there will be an oom-serial-killer.
> 
> Now, we have per-mm lowmem usage counter. We can make use of it
> to select a good? victim.
> 
> This patch does
>   - add CONSTRAINT_LOWMEM to oom's constraint type.
>   - pass constraint to __badness()
>   - change calculation based on constraint. If CONSTRAINT_LOWMEM,
>     use low_rss instead of vmsize.

As far as low memory, it would be better to consider lowmem counter.
But as you know, {vmsize VS rss} is debatable topic.
Maybe someone doesn't like this idea. 

So don't we need any test result at least?
If we don't have this patch, it happens several innocent process
killing. but we can't prevent it by this patch. 

Sorry for bothering you.

-- 
Kind regards,
Minchan Kim

