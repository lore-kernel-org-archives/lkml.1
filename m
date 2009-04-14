Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbZDNHR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbZDNHR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZDNHRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:17:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45819 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZDNHRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:17:15 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC][PATCH] proc: export more page flags in /proc/kpageflags
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20090414071159.GV14687@one.firstfloor.org>
References: <20090414154606.C665.A69D9226@jp.fujitsu.com> <20090414071159.GV14687@one.firstfloor.org>
Message-Id: <20090414161211.C66E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 14 Apr 2009 16:17:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Apr 14, 2009 at 03:54:40PM +0900, KOSAKI Motohiro wrote:
> > Hi
> 
> There are two use cases here:
> 
> First what is useful for the administrator as a general abstraction.
> And what is useful for the kernel hacker for debugging.
> 
> The kernel hacker wants everything even if it's subject to change,
> the administrator wants a higher level abstraction they can make
> sense of and that doesn't change too often.
> 
> I think there's a case for both usages, but perhaps they 
> should be separated (in a public and a internal interface perhaps?)
> 
> My comments below are about abstractions for the first case.
> 
> 
> > 
> > > On Tue, Apr 14, 2009 at 12:37:10PM +0800, KOSAKI Motohiro wrote:
> > > > > Export the following page flags in /proc/kpageflags,
> > > > > just in case they will be useful to someone:
> > > > > 
> > > > > - PG_swapcache
> > > > > - PG_swapbacked
> > > > > - PG_mappedtodisk
> > > > > - PG_reserved
> 
> PG_reserved should be exported as PG_KERNEL or somesuch.

OK.

rest problem is, how do we write document this.
PG_reserved have multiple meanings...


> > > > > - PG_private
> > > > > - PG_private_2
> > > > > - PG_owner_priv_1
> > > > > 
> > > > > - PG_head
> > > > > - PG_tail
> > > > > - PG_compound
> 
> I would combine these three into a pseudo "large page" flag.

Ah good idea.

> > > > > 
> > > > > - PG_unevictable
> > > > > - PG_mlocked
> > > > > 
> > > > > - PG_poison
> 
> PG_poison is also useful to export. But since it depends on my
> patchkit I will pull a patch for that into the HWPOISON series.

Yes, I agree.

> > > > > - PG_unevictable
> > > > > - PG_mlocked
> > 
> > this 9 flags shouldn't exported.
> > I can't imazine administrator use what purpose those flags.
> 
> I think an abstraced "PG_pinned" or somesuch flag that combines
> page lock, unevictable, mlocked would be useful for the administrator.

PG_unevictable and PG_mlocked have a bit delicate meaning.
it gurantee the page isn't evicted. but mlock(2) don't gurantee
turn page on PG_mlocked. some race prevent it.

I'm afraid administrator confuse it. but if someone can write good
document, my worriness will vanished.





