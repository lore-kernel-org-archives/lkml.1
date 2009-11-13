Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbZKMT1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbZKMT1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757039AbZKMT1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:27:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215AbZKMT1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:27:11 -0500
Date: Fri, 13 Nov 2009 14:26:48 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 05/16] blkio: Implement per cfq group latency target
	and busy queue avg
Message-ID: <20091113192648.GK17076@redhat.com>
References: <1258068756-10766-1-git-send-email-vgoyal@redhat.com> <1258068756-10766-6-git-send-email-vgoyal@redhat.com> <4e5e476b0911130246m372eb8e8x7b98f13278515a95@mail.gmail.com> <20091113151815.GC17076@redhat.com> <20091113161506.GF17076@redhat.com> <4e5e476b0911131040l58dc1e04ncbb4be7ca2ca7227@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0911131040l58dc1e04ncbb4be7ca2ca7227@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 07:40:51PM +0100, Corrado Zoccolo wrote:
> On Fri, Nov 13, 2009 at 5:15 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Fri, Nov 13, 2009 at 10:18:15AM -0500, Vivek Goyal wrote:
> >> On Fri, Nov 13, 2009 at 11:46:49AM +0100, Corrado Zoccolo wrote:
> >> > On Fri, Nov 13, 2009 at 12:32 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > >  static inline void
> >> > > @@ -441,10 +445,13 @@ cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> >> > >        if (cfqd->cfq_latency) {
> >> > >                /* interested queues (we consider only the ones with the same
> >> > >                 * priority class) */
> >> > This comment needs to be updated
> >>
> >> Sure. Will do. Now the interested queues are the one with same priority
> >> class with-in group.
> >>
> >> > >                 * priority class) */
> >> > > -               unsigned iq = cfq_get_avg_queues(cfqd, cfq_class_rt(cfqq));
> >> > > +               unsigned iq = cfq_group_get_avg_queues(cfqd, cfqq->cfqg,
> >> > > +                                               cfq_class_rt(cfqq));
> >> > >                unsigned sync_slice = cfqd->cfq_slice[1];
> >> > >                unsigned expect_latency = sync_slice * iq;
> >> > > -               if (expect_latency > cfq_target_latency) {
> >> > > +               unsigned group_target_lat = cfq_target_latency/cfqd->nr_groups;
> >> >
> >> > I'm not sure that we should divide the target latency evenly among groups.
> >> > Groups with different weights will have different percentage of time
> >> > in each 300ms round, so probably we should consider it here.
> >> >
> >>
> >> Taking group weight into account will be more precise thing. So may be
> >> I can keep track of total weight on the service tree and determine
> >> group target latency as proportion of total weight.
> >>
> >>  group_target_lat = group_weight * cfq_target_latency/total_weight_of_groups
> >>
> >
> > Here is the patch I generated on top of all the patches in series.
> >
> > o Determine group target latency in proportion to group weight instead of
> >  just number of groups.
> 
> Great.
> I have only one concern, regarding variable naming:
> group_target_lat is a bit misleading. The fact is that it will be
> larger for higher weight groups, so people could ask why are you
> giving more latency to higher weight group...
> Actually, it is the group share of the scheduling round, so you should
> name it accordingly.
> 

How about "group_slice" ?

Thanks
Vivek

