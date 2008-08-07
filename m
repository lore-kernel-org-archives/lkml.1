Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbYHGIbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbYHGIbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 04:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYHGIa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 04:30:58 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:47613 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751738AbYHGIaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 04:30:55 -0400
Date: Thu, 07 Aug 2008 17:30:52 +0900 (JST)
Message-Id: <20080807.173052.13120905.taka@valinux.co.jp>
To: ngupta@google.com
Cc: fernando@oss.ntt.co.jp, dave@linux.vnet.ibm.com, ryov@valinux.co.jp,
       yoshikawa.takuya@oss.ntt.co.jp, uchida@ap.jp.nec.com,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@sourceware.org,
       righi.andrea@gmail.com
Subject: Re: RFC: I/O bandwidth controller
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <2846be6b0808061237o6667c609l21bdb5a765469e95@mail.gmail.com>
References: <1217870433.20260.101.camel@nimitz>
	<1217985189.3154.57.camel@sebastian.kern.oss.ntt.co.jp>
	<2846be6b0808061237o6667c609l21bdb5a765469e95@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Naveen,

> > If we are pursuing a I/O prioritization model à la CFQ the temptation is
> > to implement it at the elevator layer or extend any of the existing I/O
> > schedulers.
> >
> > There have been several proposals that extend either the CFQ scheduler
> > (see (1), (2) below) or the AS scheduler (see (3) below). The problem
> > with these controllers is that they are scheduler dependent, which means
> > that they become unusable when we change the scheduler or when we want
> > to control stacking devices which define their own make_request_fn
> > function (md and dm come to mind). It could be argued that the physical
> > devices controlled by a dm or md driver are likely to be fed by
> > traditional I/O schedulers such as CFQ, but these I/O schedulers would
> > be running independently from each other, each one controlling its own
> > device ignoring the fact that they part of a stacking device. This lack
> > of information at the elevator layer makes it pretty difficult to obtain
> > accurate results when using stacking devices. It seems that unless we
> > can make the elevator layer aware of the topology of stacking devices
> > (possibly by extending the elevator API?) evelator-based approaches do
> > not constitute a generic solution. Here onwards, for discussion
> > purposes, I will refer to this type of I/O bandwidth controllers as
> > elevator-based I/O controllers.
> 
> It can be argued that any scheduling decision wrt to i/o belongs to
> elevators. Till now they have been used to improve performance. But
> with new requirements to isolate i/o based on process or cgroup, we
> need to change the elevators.
> 
> If we add another layer of i/o scheduling (block layer I/O controller)
> above elevators
> 1) It builds another layer of i/o scheduling (bandwidth or priority)
> 2) This new layer can have decisions for i/o scheduling which conflict
> with underlying elevator. e.g. If we decide to do b/w scheduling in
> this new layer, there is no way a priority based elevator could work
> underneath it.

I seems like the same goes for the current Linux kernel implementation
that if processes issued a lot of I/O requests and the io-request queue
of a disk is overflowed, all the I/O requests after will be blocked
and the priorities of them are meaningless.
In other word, it won't work if it receives lots of requests more than
the ability/bandwidth of a disk.

It doesn't seem so weird if it won't work if a cgroup issues lots of
I/O requests more than the bandwidth which is assigned to the cgroup.

> If a custom make_request_fn is defined (which means the said device is
> not using existing elevator), it could build it's own scheduling
> rather than asking kernel to add another layer at the time of i/o
> submission. Since it has complete control of i/o.

Thanks,
Hirokazu Takahashi

