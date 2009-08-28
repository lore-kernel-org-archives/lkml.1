Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346AbZH1PPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbZH1PPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 11:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbZH1PPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 11:15:31 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:51461 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZH1PPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 11:15:30 -0400
Date: Fri, 28 Aug 2009 20:45:28 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 1/5] memcg: change for softlimit.
Message-ID: <20090828151528.GT4889@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090828132321.e4a497bb.kamezawa.hiroyu@jp.fujitsu.com> <20090828072007.GH4889@balbir.in.ibm.com> <20090828163523.e51678be.kamezawa.hiroyu@jp.fujitsu.com> <20090828132643.GM4889@balbir.in.ibm.com> <bfd50d44ff730c2720b882a81b7446c6.squirrel@webmail-b.css.fujitsu.com> <712c0209222358d9c7d1e33f93e21c30.squirrel@webmail-b.css.fujitsu.com> <20090828144648.GO4889@balbir.in.ibm.com> <b2d13270df033cc94ec4387e01c88c82.squirrel@webmail-b.css.fujitsu.com> <20090828150829.GR4889@balbir.in.ibm.com> <25afd2b84c65e7c2c8f2edde31c914f7.squirrel@webmail-b.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <25afd2b84c65e7c2c8f2edde31c914f7.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-29 00:12:26]:

> Balbir Singh wrote:
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-29
> > 00:06:23]:
> >
> >> Balbir Singh wrote:
> >> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28
> >> > 23:40:56]:
> >> >
> >> >> KAMEZAWA Hiroyuki wrote:
> >> >> > Balbir Singh wrote:
> >> >> >> But Bob and Mike might need to set soft limits between themselves.
> >> if
> >> >> >> soft limit of gold is 1G and bob needs to be close to 750M and
> >> mike
> >> >> >> 250M, how do we do it without supporting what we have today?
> >> >> >>
> >> >> > Don't use hierarchy or don't use softlimit.
> >> >> > (I never think fine-grain  soft limit can be useful.)
> >> >> >
> >> >> > Anyway, I have to modify unnecessary hacks for res_counter of
> >> >> softlimit.
> >> >> > plz allow modification. that's bad.
> >> >> > I postpone RB-tree breakage problem, plz explain it or fix it by
> >> >> yourself.
> >> >> >
> >> >> I changed my mind....per-zone RB-tree is also broken ;)
> >> >>
> >> >> Why I don't like broken system is a function which a user can't
> >> >> know/calculate how-it-works is of no use in mission critical systems.
> >> >>
> >> >> I'd like to think how-to-fix it with better algorithm. Maybe RB-tree
> >> >> is not a choice.
> >> >>
> >> >
> >> > Soft limits are not meant for mission critical work :-) Soft limits is
> >> > best effort and not a guaranteed resource allocation mechanism. I've
> >> > mentioned in previous emails how we recover if we find the data is
> >> > stale
> >> >
> >> yes. but can you explain how selection will be done to users ?
> >> I can't.
> >>
> >
> > From a user point, we get what we set, but the timelines can be a
> > little longer.
> >
> I'll drop this patch, anyway. But will modify res_counter.
> We have to reduce ops under lock after we see spinlock can explode
> system time.
>

Thanks! I'll review the other patches as well and test them sometime
over the weekend. 

-- 
	Balbir
