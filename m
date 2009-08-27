Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbZH0AUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbZH0AUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 20:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbZH0AUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 20:20:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59213 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbZH0AUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 20:20:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [RFC][PATCH] mm: remove unnecessary loop inside shrink_inactive_list()
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>
In-Reply-To: <20090821112228.GA6457@localhost>
References: <2f11576a0908210409p3f1551a4i194887abbad94e9b@mail.gmail.com> <20090821112228.GA6457@localhost>
Message-Id: <20090827091834.397F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 27 Aug 2009 09:20:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Aug 21, 2009 at 07:09:17PM +0800, KOSAKI Motohiro wrote:
> > 2009/8/20 Wu Fengguang <fengguang.wu@intel.com>:
> > > shrink_inactive_list() won't be called to scan too much pages
> > > (unless in hibernation code which is fine) or too few pages (ie.
> > > batching is taken care of by the callers).  So we can just remove the
> > > big loop and isolate the exact number of pages requested.
> > >
> > > Just a RFC, and a scratch patch to show the basic idea.
> > > Please kindly NAK quick if you don't like it ;)
> > 
> > Hm, I think this patch taks only cleanups. right?
> > if so, I don't find any objection reason.
> 
> Mostly cleanups, but one behavior change here: 
> 
> > > -               nr_taken = sc->isolate_pages(sc->swap_cluster_max,
> > > +               nr_taken = sc->isolate_pages(nr_to_scan,
> > >                             &page_list, &nr_scan, sc->order, mode,
> > >                                zone, sc->mem_cgroup, 0, file);
> 
> The new behavior is to scan exactly the number of pages that
> shrink_zone() or other callers tell it. It won't try to "round it up"
> to 32 pages. This new behavior is in line with shrink_active_list()'s
> current status as well as shrink_zone()'s expectation.
> 
> shrink_zone() may still submit scan requests for <32 pages, which is
> suboptimal. I'll try to eliminate that totally with more patches.

Your explanation seems makes sense.
I'll wait your next spin :)





