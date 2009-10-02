Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbZJBRNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbZJBRNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbZJBRNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:13:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33568 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbZJBRNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:13:51 -0400
Date: Fri, 2 Oct 2009 19:13:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
Subject: Re: IO scheduler based IO controller V10
Message-ID: <20091002171354.GH31616@kernel.dk>
References: <20090930202447.GA28236@redhat.com> <1254382405.7595.9.camel@marge.simson.net> <20091001185816.GU14918@kernel.dk> <1254464628.7158.101.camel@marge.simson.net> <20091002080417.GG14918@kernel.dk> <20091002092409.GA19529@elte.hu> <20091002092839.GA26962@kernel.dk> <alpine.LFD.2.01.0910020715160.6996@localhost.localdomain> <20091002145610.GD31616@kernel.dk> <2c0942db0910020933l6d312c6ahae0e00619f598b39@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0910020933l6d312c6ahae0e00619f598b39@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02 2009, Ray Lee wrote:
> On Fri, Oct 2, 2009 at 7:56 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > In some cases I wish we had a server vs desktop switch, since it would
> > decisions on this easier. I know you say that servers care about
> > latency, but not at all to the extent that desktops do. Most desktop
> > users would gladly give away the top of the performance for latency,
> > that's not true of most server users. Depends on what the server does,
> > of course.
> 
> If most of the I/O on a system exhibits seeky tendencies, couldn't the
> schedulers notice that and use that as the hint for what to optimize?
> 
> I mean, there's no switch better than the actual I/O behavior itself.

Heuristics like that have a tendency to fail. What's the cut-off point?
Additionally, heuristics based on past process/system behaviour also has
a tendency to be suboptimal, since things aren't static.

We already look at seekiness of individual processes or groups. IIRC,
as-iosched also keeps a per-queue tracking.

-- 
Jens Axboe

