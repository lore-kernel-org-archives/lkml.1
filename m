Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbZF3X0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbZF3X0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbZF3X0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:26:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43991 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbZF3X0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:26:37 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] Show kernel stack usage to /proc/meminfo and OOM log
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       David Howells <dhowells@redhat.com>,
       "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
In-Reply-To: <alpine.DEB.1.10.0906301011210.6124@gentwo.org>
References: <20090630150035.A738.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0906301011210.6124@gentwo.org>
Message-Id: <20090701082531.85C2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Jul 2009 08:26:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 30 Jun 2009, KOSAKI Motohiro wrote:
> 
> > +static void account_kernel_stack(struct thread_info *ti, int on)
> 
> static inline?

gcc automatically inlined, IMHO.

> > +{
> > +	struct zone* zone = page_zone(virt_to_page(ti));
> > +	int sign = on ? 1 : -1;
> > +	long acct = sign * (THREAD_SIZE / PAGE_SIZE);
> 
> int pages = THREAD_SIZE / PAGE_SIZE;
> 
> ?

Will fix. thanks cleaner code advise.

> 
> > +
> > +	mod_zone_page_state(zone, NR_KERNEL_STACK, acct);
> 
> mod_zone_page_state(zone, NR_KERNEL_STACK, on ? pages : -pages);

yes, will fix.



