Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbZGMMQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbZGMMQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 08:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbZGMMQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 08:16:02 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:40346 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbZGMMQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 08:16:01 -0400
Date: Mon, 13 Jul 2009 17:41:38 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: lizf@cn.fujitzu.com, bblum@google.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       libcg-devel <libcg-devel@lists.sourceforge.net>
Subject: Re: [PATCH 0/2] CGroups: cgroup member list enhancement/fix
Message-ID: <20090713121138.GC5051@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com> <20090705063850.GX11273@balbir.in.ibm.com> <6599ad830907101658i13e4046br70377a487dd6b49b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <6599ad830907101658i13e4046br70377a487dd6b49b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* menage@google.com <menage@google.com> [2009-07-10 16:58:23]:

> On Sat, Jul 4, 2009 at 11:38 PM, Balbir Singh<balbir@linux.vnet.ibm.com> wrote:
> >
> > Paul, I don't see an interface to migrate all procs or at-least I
> > can't read it in the changelog. As discussed in the containers
> > mini-summit in 2008, it would be a nice thing to have (I've not looked
> > at the implementation yet).
> >
> 
> We're still working on that bit.
> 
> We want to provide the guarantee that if you write a tgid to the procs
> file, all its threads get migrated even if you race with a clone()
> call, and are trying to figure out a nice way to do that without
> introducing unnecessary overhead/synchronization in the fork path.
>

How about lazy migration? Mark a group as to move when the kernel sees
it next for scheduling. We'll still need synchronization, but we can
amortize the cost. I've not tried it yet. BTW, we have quite a bit of
logic in libcgroup to deal with migration problems, specially during
classification, which Kenichi has added. We needed timestamping to get
correct migration working during classification.

-- 
	Balbir
