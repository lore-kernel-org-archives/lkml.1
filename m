Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbZCLNtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbZCLNtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbZCLNtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:49:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58345 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbZCLNtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:49:02 -0400
Date: Thu, 12 Mar 2009 09:46:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: anqin <anqin.qin@gmail.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, oz-kernel@redhat.com,
       paolo.valente@unimore.it, linux-kernel@vger.kernel.org,
       dhaval@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       menage@google.com, jmoyer@redhat.com, fchecconi@gmail.com,
       arozansk@redhat.com, jens.axboe@oracle.com, akpm@linux-foundation.org,
       fernando@intellilink.co.jp, balbir@linux.vnet.ibm.com
Subject: Re: [RFC] IO Controller
Message-ID: <20090312134646.GC10919@redhat.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <49B8810B.7030603@oss.ntt.co.jp> <d95d44a20903112340s3c77807dt465e68901747ad89@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d95d44a20903112340s3c77807dt465e68901747ad89@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 02:40:23PM +0800, anqin wrote:
> Hi Vivek,
> 
> It would be very appreciated if the patches can be based on 2.6.28.
> 

Hi Anquin,

I think most of the people want to test new patches on latest kernels
so I will keep it that way. You can backport it to previous kernels if
you really need to. For me it will become very difficult to maintain
two versions. 

Is there any reason why you can't move to latest kernels?  

Thanks
Vivek

> Thanks a lot.
> 
> Anqin
> 
> On Thu, Mar 12, 2009 at 11:27 AM, Takuya Yoshikawa
> <yoshikawa.takuya@oss.ntt.co.jp> wrote:
> > Hi Vivek,
> >
> > Could you tell me to which kernel I can apply your patches?
> >   # latest mm?
> > I would like to test your controller.
> >
> > Thank you,
> >   Takuya Yoshikawa
> >
> >
> > Vivek Goyal wrote:
> >>
> >> Hi All,
> >>
> >> Here is another posting for IO controller patches. Last time I had posted
> >> RFC patches for an IO controller which did bio control per cgroup.
> >>
> >> http://lkml.org/lkml/2008/11/6/227
> >>
> >> One of the takeaway from the discussion in this thread was that let us
> >> implement a common layer which contains the proportional weight scheduling
> >> code which can be shared by all the IO schedulers.
> >>
> >> Implementing IO controller will not cover the devices which don't use
> >> IO schedulers but it should cover the common case.
> >>
> >> There were more discussions regarding 2 level vs 1 level IO control at
> >> following link.
> >>
> >> https://lists.linux-foundation.org/pipermail/containers/2009-January/015402.html
> >>
> >> So in the mean time we took the discussion off the list and spent time on
> >> making the 1 level control apporoach work where majority of the proportional
> >> weight control is shared by the four schedulers instead of each one having
> >> to replicate the code. We make use of BFQ code for fair queuing as posted
> >> by Paolo and Fabio here.
> >>
> >> http://lkml.org/lkml/2008/11/11/148
> >>
> >> Details about design and howto have been put in documentation patch.
> >>
> >> I have done very basic testing of running 2 or 3 "dd" threads in different
> >> cgroups. Wanted to get the patchset out for feedback/review before we dive
> >> into more bug fixing, benchmarking, optimizations etc.
> >>
> >> Your feedback/comments are welcome.
> >>
> >> Patch series contains 10 patches. It should be compilable and bootable after
> >> every patch. Intial 2 patches implement flat fair queuing (no cgroup
> >> support) and make cfq to use that. Later patches introduce hierarchical
> >> fair queuing support in elevator layer and modify other IO schdulers to use
> >> that.
> >>
> >> Thanks
> >> Vivek
> >> _______________________________________________
> >> Containers mailing list
> >> Containers@lists.linux-foundation.org
> >> https://lists.linux-foundation.org/mailman/listinfo/containers
> >>
> >
> > _______________________________________________
> > Containers mailing list
> > Containers@lists.linux-foundation.org
> > https://lists.linux-foundation.org/mailman/listinfo/containers
> >
