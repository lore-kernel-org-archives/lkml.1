Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbZFIIhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbZFIIhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758922AbZFIIhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:37:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58673 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758524AbZFIIhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:37:23 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH mmotm] vmscan: handle may_swap more strictly (Re: [PATCH  mmotm] vmscan: fix may_swap handling for memcg)
Cc: kosaki.motohiro@jp.fujitsu.com,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <28c262360906090135x3382456by3518434a9939002b@mail.gmail.com>
References: <20090609172035.DD7C.A69D9226@jp.fujitsu.com> <28c262360906090135x3382456by3518434a9939002b@mail.gmail.com>
Message-Id: <20090609173605.DD82.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Jun 2009 17:37:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jun 9, 2009 at 5:24 PM, KOSAKI
> Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
> >> On Tue, Jun 9, 2009 at 4:58 PM, KOSAKI
> >> Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
> >> >> Hi, KOSAKI.
> >> >>
> >> >> As you know, this problem caused by if condition(priority) in shrink_zone.
> >> >> Let me have a question.
> >> >>
> >> >> Why do we have to prevent scan value calculation when the priority is zero ?
> >> >> As I know, before split-lru, we didn't do it.
> >> >>
> >> >> Is there any specific issue in case of the priority is zero ?
> >> >
> >> > Yes.
> >> >
> >> > example:
> >> >
> >> > get_scan_ratio() return anon:80%, file=20%. and the system have
> >> > 10000 anon pages and 10000 file pages.
> >> >
> >> > shrink_zone() picked up 8000 anon pages and 2000 file pages.
> >> > it mean 8000 file pages aren't scanned at all.
> >> >
> >> > Oops, it can makes OOM-killer although system have droppable file cache.
> >> >
> >> Hmm..Can that problem be happen in real system ?
> >> The file ratio is big means that file lru list scanning is so big but
> >> rotate is small.
> >> It means file lru have few reclaimable page.
> >>
> >> Isn't it ? I am confusing.
> >> Could you elaborate, please if you don't mind ?
> >
> > hm, ok, my example was wrong.
> > I intention is, if there are droppable file-back pages (althout only 1 page),
> > OOM-killer shouldn't occuer.
> >
> > many or few is unrelated.
> >
> 
> I am not sure that is effective.
> Have you ever met this problem in real situation ?

No.
It's only stress workload issue. but VM subsystem sould work on
stress workload, I think.


> BTW, I have to dive into code. :)
> Thanks for spending valuable time for commenting





