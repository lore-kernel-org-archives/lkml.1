Return-Path: <linux-kernel-owner+w=401wt.eu-S1757740AbZEGB2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740AbZEGB2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 21:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbZEGB1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 21:27:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46208 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbZEGB1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 21:27:53 -0400
Date: Wed, 6 May 2009 21:25:59 -0400
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
Message-ID: <20090507012559.GC4187@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <20090505132441.1705bfad.akpm@linux-foundation.org> <20090506023332.GA1212@redhat.com> <20090507.091858.226775723.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507.091858.226775723.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 09:18:58AM +0900, Ryo Tsuruta wrote:
> Hi Vivek,
> 
> > Ryo, dm-ioband breaks the notion of classes and priority of CFQ because
> > of FIFO dispatch of buffered bios. Apart from that it tries to provide
> > fairness in terms of actual IO done and that would mean a seeky workload
> > will can use disk for much longer to get equivalent IO done and slow down
> > other applications. Implementing IO controller at IO scheduler level gives
> > us tigher control. Will it not meet your requirements? If you got specific
> > concerns with IO scheduler based contol patches, please highlight these and
> > we will see how these can be addressed.
> 
> I'd like to avoid making complicated existing IO schedulers and other
> kernel codes and to give a choice to users whether or not to use it.
> I know that you chose an approach that using compile time options to
> get the same behavior as old system, but device-mapper drivers can be
> added, removed and replaced while system is running.
> 

Same is possible with IO scheduler based controller. If you don't want
cgroup stuff, don't create those. By default everything will be in root
group and you will get the old behavior. 

If you want io controller stuff, just create the cgroup, assign weight
and move task there. So what more choices do you want which are missing
here?

Thanks
Vivek
