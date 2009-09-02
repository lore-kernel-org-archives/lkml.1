Return-Path: <linux-kernel-owner+w=401wt.eu-S932110AbZIBBB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbZIBBB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 21:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbZIBBB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 21:01:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56492 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbZIBBB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 21:01:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 2 Sep 2009 09:59:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, dhaval@linux.vnet.ibm.com,
       dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com,
       balbir@linux.vnet.ibm.com, paolo.valente@unimore.it,
       jmarchan@redhat.com, fernando@oss.ntt.co.jp, jmoyer@redhat.com,
       mingo@elte.hu, riel@redhat.com, fchecconi@gmail.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, righi.andrea@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches from Ryo to
 track async bios.
Message-Id: <20090902095912.cdf8a55e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090901141142.GA13709@redhat.com>
References: <4A9C09BE.4060404@redhat.com>
	<20090831185640.GF3758@redhat.com>
	<e98e18940908311651s26de5b70ye6f4a82402956309@mail.gmail.com>
	<20090901.160004.226800357.ryov@valinux.co.jp>
	<20090901141142.GA13709@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Sep 2009 10:11:42 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > - Somebody also gave an example where there is a memory hogging process and
> > > >  possibly pushes out some processes to swap. It does not sound fair to
> > > >  charge those proccess for that swap writeout. These processes never
> > > >  requested swap IO.
> > 
> > I think that swap writeouts should be charged to the memory hogging
> > process, because the process consumes more resources and it should get
> > a penalty.
> > 
> 
> A process requesting memory gets IO penalty? IMHO, swapping is a kernel 
> mechanism and kernel's way of providing extended RAM. If we want to solve
> the issue of memory hogging by a process then right way to solve is to use
> memory controller and not by charging the process for IO activity.
> Instead, proabably a more suitable way is to charge swap activity to root
> group (where by default all the kernel related activity goes).   
> 

I agree. It't memcg's job.
(Support dirty_ratio in memcg is necessary, I think)

background-write-out-to-swap-for-memory-shortage should be handled
as kernel I/O. If swap-out-by-memcg bacause of its limit is a problem,
dirty_ratio for memcg should be implemetned.

Thanks,
-Kame

