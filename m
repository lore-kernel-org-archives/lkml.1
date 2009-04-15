Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbZDONzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbZDONzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 09:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbZDONy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 09:54:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55862 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbZDONy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 09:54:57 -0400
Date: Wed, 15 Apr 2009 15:57:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] proc: export more page flags in /proc/kpageflags
Message-ID: <20090415135749.GD14687@one.firstfloor.org>
References: <20090414133448.C645.A69D9226@jp.fujitsu.com> <20090414064132.GB5746@localhost> <20090414154606.C665.A69D9226@jp.fujitsu.com> <20090414071159.GV14687@one.firstfloor.org> <20090415131800.GA11191@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415131800.GA11191@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's pretty good separations. I guess it would be convenient to make the
> extra kernel flags available under CONFIG_DEBUG_KERNEL?

Yes.

BTW an alternative would be just someone implementing a suitable
command/macro in crash(1) and tell the kernel hackers to run that on
/proc/kcore. That would have the advantage to not require code.

> > > > > > - PG_compound
> > 
> > I would combine these three into a pseudo "large page" flag.
> 
> Very neat idea! Patch updated accordingly.
>  
> However - one pity I observed:
> 
> # ./page-areas 0x008000
>     offset      len         KB
>       3088        4       16KB
> 
> We can no longer tell if the above line means one 4-page hugepage, or two
> 2-page hugepages... Adding PG_COMPOUND_TAIL into the CONFIG_DEBUG_KERNEL block

There's only a single size (2 or 4MB), at worst two.

> > 
> > PG_poison is also useful to export. But since it depends on my
> > patchkit I will pull a patch for that into the HWPOISON series.
> 
> That's not a problem - since the PG_poison line is be protected by
> #ifdef CONFIG_MEMORY_FAILURE :-) 

Good point. I added a patch to only add it to my pile,
but I can drop that again.

-Andi
