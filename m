Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbYFXRsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbYFXRsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYFXRsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:48:32 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:22539 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbYFXRsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:48:32 -0400
Subject: Re: [PATCH] fix to putback_lru_page()/unevictable page handling
	rework v3
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <2f11576a0806241035p45a440e1gb798091ef39cffc8@mail.gmail.com>
References: <20080621185408.E832.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080624184122.D838.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1214327987.6563.22.camel@lts-notebook>
	 <2f11576a0806241035p45a440e1gb798091ef39cffc8@mail.gmail.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 24 Jun 2008 13:48:28 -0400
Message-Id: <1214329708.6563.43.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-25 at 02:35 +0900, KOSAKI Motohiro wrote:
> > 'lru' was not being set to 'UNEVICTABLE when page was, in fact,
> > unevictable [really "nonreclaimable" :-)], so retry would never
> > happen, and culled pages never counted.
> >
> > Also, redundant mem_cgroup_move_lists()--one with incorrect 'lru',
> > in the case of unevictable pages--messes up memcontroller tracking [I think].
> 
> indeed.
> sorry, I forgot to send this fix.
> 
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> but I still happend panic on usex and nishimura-san's cpuset migration test.
>   -> http://marc.info/?l=linux-mm&m=121375647720110&w=2
> 

I saw the description of the cpuset migration test.  Have you wrapped
this in a script suitable for running under usex?  If so, I would like
to get a copy.  Actually, please send me any automation you have for
this test and I'll incorporate it into the usex load.  Meanwhile, I'll
take a cut at adding such a test to the load.  However, we know that
your version can provoke the panic, so I'd like to get that.

> 
> I'll  investigate it tommorow.

Later, then,
Lee



