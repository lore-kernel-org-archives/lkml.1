Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbYLAIMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbYLAIMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 03:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbYLAIME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 03:12:04 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60971 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYLAIMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 03:12:01 -0500
Date: Mon, 01 Dec 2008 17:11:59 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: "Catalin Marinas" <catalin.marinas@arm.com>
Subject: Re: [PATCH 01/15] kmemleak: Add the base support
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <84144f020811302249i7587662ewa621d0a81f5426a2@mail.gmail.com>
References: <20081201142824.D552.E1E9C6FF@jp.fujitsu.com> <84144f020811302249i7587662ewa621d0a81f5426a2@mail.gmail.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20081201170807.C2E2.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi!
> 
> On Mon, Dec 1, 2008 at 7:39 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> >> +/*
> >> + * Insert a pointer into the pointer hash table.
> >> + */
> >> +static inline void create_object(unsigned long ptr, size_t size, int ref_count)
> >> +{
> >> +     unsigned long flags;
> >> +     struct memleak_object *object;
> >> +     struct prio_tree_node *node;
> >> +     struct stack_trace trace;
> >> +
> >> +     object = kmem_cache_alloc(object_cache, GFP_ATOMIC);
> >> +     if (!object)
> >> +             panic("kmemleak: cannot allocate a memleak_object structure\n");
> >
> > IIRC, GFP_ATOMIC allocation sometimes fails. (ex. when page cache occupies all
> > area). It seems to be easy to panic. Is it intended?
> 
> Yup, GFP_ATOMIC can fail as can any memory allocation on out-of-memory
> conditions unless you specify GFP_NOFAIL which will either succeed or
> lock up the box. I think you can just WARN_ON() here? However, it's
> probably safer to pass gfp flags from the callers here; otherwise we
> end up doing tons of GFP_ATOMIC allocations which is not healthy in
> general.

I agree. It is reasonable to pass gfp flag from the caller.

Thanks.

> 
> Also, I see some other BUG_ON() calls in the code which probably
> should be converted to WARN_ON() as well.

-- 
Yasunori Goto 


