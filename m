Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbYGUBtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbYGUBtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 21:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbYGUBtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 21:49:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756542AbYGUBtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 21:49:10 -0400
Date: Sun, 20 Jul 2008 18:48:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: "Johannes Weiner" <hannes@saeurebad.de>, "Rik van Riel" <riel@redhat.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       Nossum <vegard.nossum@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] mm: more likely reclaim MADV_SEQUENTIAL mappings
Message-Id: <20080720184843.9f7b48e9.akpm@linux-foundation.org>
In-Reply-To: <2f11576a0807201709q45aeec3cvb99b0049421245ae@mail.gmail.com>
References: <87y73x4w6y.fsf@saeurebad.de>
	<2f11576a0807201709q45aeec3cvb99b0049421245ae@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 09:09:26 +0900 "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi Johannes,
> 
> > File pages accessed only once through sequential-read mappings between
> > fault and scan time are perfect candidates for reclaim.
> >
> > This patch makes page_referenced() ignore these singular references and
> > the pages stay on the inactive list where they likely fall victim to the
> > next reclaim phase.
> >
> > Already activated pages are still treated normally.  If they were
> > accessed multiple times and therefor promoted to the active list, we
> > probably want to keep them.
> >
> > Benchmarks show that big (relative to the system's memory)
> > MADV_SEQUENTIAL mappings read sequentially cause much less kernel
> > activity.  Especially less LRU moving-around because we never activate
> > read-once pages in the first place just to demote them again.
> >
> > And leaving these perfect reclaim candidates on the inactive list makes
> > it more likely for the real working set to survive the next reclaim
> > scan.
> 
> looks good to me.
> Actually, I made similar patch half year ago.
> 
> in my experience,
>   - page_referenced_one is performance critical point.
>     you should test some benchmark.
>   - its patch improved mmaped-copy performance about 5%.
>     (Of cource, you should test in current -mm. MM code was changed widely)
> 
> So, I'm looking for your test result :)

The change seems logical and I queued it for 2.6.28.

But yes, testing for what-does-this-improve is good and useful, but so
is testing for what-does-this-worsen.  How do we do that in this case?

