Return-Path: <linux-kernel-owner+w=401wt.eu-S1760290AbZDBOEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbZDBOEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbZDBOEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:04:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48156 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615AbZDBOEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:04:43 -0400
Date: Thu, 2 Apr 2009 10:00:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       menage@google.com, peterz@infradead.org
Subject: Re: [RFC] IO Controller
Message-ID: <20090402140037.GC12851@redhat.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <49D45DAC.2060508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D45DAC.2060508@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 02:39:40PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > Hi All,
> > 
> > Here is another posting for IO controller patches. Last time I had posted
> > RFC patches for an IO controller which did bio control per cgroup.
> > 
> > http://lkml.org/lkml/2008/11/6/227
> > 
> > One of the takeaway from the discussion in this thread was that let us
> > implement a common layer which contains the proportional weight scheduling
> > code which can be shared by all the IO schedulers.
> > 
>   
>   Hi Vivek,
> 
>   I did some tests on my *old* i386 box(with two concurrent dd running), and notice 
>   that IO Controller doesn't work fine in such situation. But it can work perfectly 
>   in my *new* x86 box. I dig into this problem, and i guess the major reason is that
>   my *old* i386 box is too slow, it can't ensure two running ioqs are always backlogged.

Hi Gui,

Have you run top to see what's the percentage cpu usage. I suspect that
cpu is not keeping up pace disk to enqueue enough requests. I think
process might be blocked somewhere else so that it could not issue
requests. 

>   If that is the case, I happens to have a thought. when an ioq uses up it time slice, 
>   we don't expire it immediately. May be we can give a piece of bonus time for idling 
>   to wait new requests if this ioq's finish time and its ancestor's finish time are all 
>   much smaller than other entities in each corresponding service tree.

Have you tried it with "fairness" enabled? With "fairness" enabled, for
sync queues I am waiting for one extra idle time slice "8ms" for queue
to get backlogged again before I move to the next queue?

Otherwise try to increase the idle time length to higher value say "12ms"
just to see if that has any impact.

Can you please also send me output of blkparse. It might give some idea
how IO schedulers see IO pattern.

Thanks
Vivek
