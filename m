Return-Path: <linux-kernel-owner+w=401wt.eu-S1761359AbZCaCDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761359AbZCaCDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 22:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbZCaCDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 22:03:41 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:59982 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbZCaCDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 22:03:40 -0400
Date: Tue, 31 Mar 2009 10:52:49 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: nishimura@mxp.nes.nec.co.jp,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] vmscan: memcg needs may_swap (Re: [patch] vmscan:
 rename  sc.may_swap to may_unmap)
Message-Id: <20090331105249.98fd051b.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <28c262360903301826w6429720es8ceb361cfc088b1@mail.gmail.com>
References: <20090327151926.f252fba7.nishimura@mxp.nes.nec.co.jp>
	<20090327153035.35498303.kamezawa.hiroyu@jp.fujitsu.com>
	<20090328214636.68FF.A69D9226@jp.fujitsu.com>
	<28c262360903301826w6429720es8ceb361cfc088b1@mail.gmail.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > ========
> > Subject: vmswan: reintroduce sc->may_swap
> >
> > vmscan-rename-scmay_swap-to-may_unmap.patch removed may_swap flag,
> > but memcg had used it as a flag for "we need to use swap?", as the
> > name indicate.
> >
> > And in current implementation, memcg cannot reclaim mapped file caches
> > when mem+swap hits the limit.
> >
> > re-introduce may_swap flag and handle it at get_scan_ratio().
> > This patch doesn't influence any scan_control users other than memcg.
> >
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > --
> >  mm/vmscan.c |   12 ++++++++++--
> >  1 files changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 3be6157..00ea4a1 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -63,6 +63,9 @@ struct scan_control {
> >        /* Can mapped pages be reclaimed? */
> >        int may_unmap;
> >
> > +       /* Can pages be swapped as part of reclaim? */
> > +       int may_swap;
> > +
> 
> Sorry for too late response.
> I don't know memcg well.
> 
> The memcg managed to use may_swap well with global page reclaim until now.
memcg had a bug that it cannot reclaim mapped file caches when it hit
the mem+swap limit :(


Thanks,
Daisuke Nishimura.
