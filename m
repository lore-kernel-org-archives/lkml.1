Return-Path: <linux-kernel-owner+w=401wt.eu-S932087AbYDUKlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbYDUKlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbYDUKbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:31:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46301 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbYDUKbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:31:04 -0400
Date: Mon, 21 Apr 2008 19:29:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Shi Weihua <shiwh@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, hugh@veritas.com
Subject: Re: [PATCH]Fix usemap for DISCONTIG/FLATMEM with not-aligned zone
 initilaization.
Message-Id: <20080421192952.4e60b11b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080421101231.GA629@csn.ul.ie>
References: <20080418161522.GB9147@csn.ul.ie>
	<48080706.50305@cn.fujitsu.com>
	<48080930.5090905@cn.fujitsu.com>
	<48080B86.7040200@cn.fujitsu.com>
	<20080418211214.299f91cd.kamezawa.hiroyu@jp.fujitsu.com>
	<21878461.1208539556838.kamezawa.hiroyu@jp.fujitsu.com>
	<20080421112048.78f0ec76.kamezawa.hiroyu@jp.fujitsu.com>
	<20080421101231.GA629@csn.ul.ie>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008 11:12:32 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> On (21/04/08 11:20), KAMEZAWA Hiroyuki didst pronounce:
> > On Sat, 19 Apr 2008 02:25:56 +0900 (JST)
> > kamezawa.hiroyu@jp.fujitsu.com wrote:
> >  
> > > >What about something like the following? Instead of expanding the size of
> > > >structures, it sanity checks input parameters. It touches a number of places
> > > >because of an API change but it is otherwise straight-forward.
> > > >
> > > >Unfortunately, I do not have an IA-64 machine that can reproduce the problem
> > > >to see if this still fixes it or not so a test as well as a review would be
> > > >appreciated. What should happen is the machine boots but prints a warning
> > > >about the unexpected PFN ranges. It boot-tested fine on a number of other
> > > >machines (x86-32 x86-64 and ppc64).
> > > >
> > > ok, I'll test today if I have a chance. At least, I think I can test this
> > > until Monday. but I have one concern (below)
> > > 
> > I tested and found your patch doesn't work.
> > It seems because all valid page struct is not initialized.
> 
> The fact I didn't calculate end_pfn properly as pointed out by Dave Hansen
> didn't help either. If that was corrected, I'd be surprised if the patch
> didn't work. If it is broken, it implies that arch-specific code is using
> PFN ranges that do not contain valid memory - something I find surprising.
> 
I noticed and fixed end_pfn but did not work....If necessary, I'll check it
again....

Thanks,
-Kame

