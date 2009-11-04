Return-Path: <linux-kernel-owner+w=401wt.eu-S933109AbZKDXWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109AbZKDXWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933074AbZKDXWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:22:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932382AbZKDXWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:22:34 -0500
Date: Wed, 4 Nov 2009 18:22:16 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 02/20] blkio: Change CFQ to use CFS like queue time
	stamps
Message-ID: <20091104232216.GP2870@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-3-git-send-email-vgoyal@redhat.com> <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 10:18:15PM +0100, Corrado Zoccolo wrote:
> Hi Vivek,
> On Wed, Nov 4, 2009 at 12:43 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > o Previously CFQ had one service tree where queues of all theree prio classes
> >  were being queued. One side affect of this time stamping approach is that
> >  now single tree approach might not work and we need to keep separate service
> >  trees for three prio classes.
> >
> Single service tree is no longer true in cfq for-2.6.33.
> Now we have a matrix of service trees, with first dimension being the
> priority class, and second dimension being the workload type
> (synchronous idle, synchronous no-idle, async).
> You can have a look at the series: http://lkml.org/lkml/2009/10/26/482 .
> It may have other interesting influences on your work, as the idle
> introduced at the end of the synchronous no-idle tree, that provides
> fairness also for seeky or high-think-time queues.
> 

Hi Corrado,

Had one more question. Now with dynamic slice length (reduce slice length
to meet target latency), don't wee see reduced throughput on rotational
media with sequential workload?

I saw some you posted numbers for SSD. Do you have some numbers for
rotational media also?

Thanks
Vivek
