Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbZEKMxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbZEKMxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZEKMxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:53:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60529 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbZEKMxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:53:35 -0400
Date: Mon, 11 May 2009 08:49:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: akpm@linux-foundation.org, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, jens.axboe@oracle.com, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, peterz@infradead.org
Subject: Re: IO scheduler based IO Controller V2
Message-ID: <20090511124931.GA6036@redhat.com>
References: <20090506023332.GA1212@redhat.com> <20090507.091858.226775723.ryov@valinux.co.jp> <20090507012559.GC4187@redhat.com> <20090511.202309.112614168.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511.202309.112614168.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 08:23:09PM +0900, Ryo Tsuruta wrote:
> Hi Vivek,
> 
> From: Vivek Goyal <vgoyal@redhat.com>
> Subject: Re: IO scheduler based IO Controller V2
> Date: Wed, 6 May 2009 21:25:59 -0400
> 
> > On Thu, May 07, 2009 at 09:18:58AM +0900, Ryo Tsuruta wrote:
> > > Hi Vivek,
> > > 
> > > > Ryo, dm-ioband breaks the notion of classes and priority of CFQ because
> > > > of FIFO dispatch of buffered bios. Apart from that it tries to provide
> > > > fairness in terms of actual IO done and that would mean a seeky workload
> > > > will can use disk for much longer to get equivalent IO done and slow down
> > > > other applications. Implementing IO controller at IO scheduler level gives
> > > > us tigher control. Will it not meet your requirements? If you got specific
> > > > concerns with IO scheduler based contol patches, please highlight these and
> > > > we will see how these can be addressed.
> > > 
> > > I'd like to avoid making complicated existing IO schedulers and other
> > > kernel codes and to give a choice to users whether or not to use it.
> > > I know that you chose an approach that using compile time options to
> > > get the same behavior as old system, but device-mapper drivers can be
> > > added, removed and replaced while system is running.
> > > 
> > 
> > Same is possible with IO scheduler based controller. If you don't want
> > cgroup stuff, don't create those. By default everything will be in root
> > group and you will get the old behavior. 
> > 
> > If you want io controller stuff, just create the cgroup, assign weight
> > and move task there. So what more choices do you want which are missing
> > here?
> 
> What I mean to say is that device-mapper drivers can be completely
> removed from the kernel if not used.
> 
> I know that dm-ioband has some issues which can be addressed by your
> IO controller, but I'm not sure your controller works well. So I would
> like to see some benchmark results of your IO controller.
> 

Fair enough. IO scheduler based IO controller is still work in progress
and we have started to get some basic things right. I think after 3-4
iterations of patches, patches will be stable enough and working enough that
I should be able to give some benchmark numbers also.

Currently I am posting the intermediate snapshot of my tree to lkml to get the
design feedback so that if there are fundamental design issues, we can sort
these out.

Thanks
Vivek
