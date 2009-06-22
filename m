Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbZFVQER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbZFVQER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbZFVQED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:04:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46304 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbZFVQEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:04:02 -0400
Date: Mon, 22 Jun 2009 12:02:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       dhaval@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [RFC] IO scheduler based io controller (V5)
Message-ID: <20090622160207.GC15600@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <20090621152116.GC3728@balbir.in.ibm.com> <20090622153030.GA15600@redhat.com> <x497hz4l1j9.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x497hz4l1j9.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 11:40:42AM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Sun, Jun 21, 2009 at 08:51:16PM +0530, Balbir Singh wrote:
> >> * Vivek Goyal <vgoyal@redhat.com> [2009-06-19 16:37:18]:
> >> 
> >> > 
> >> > Hi All,
> >> > 
> >> > Here is the V5 of the IO controller patches generated on top of 2.6.30.
> >> [snip]
> >> 
> >> > Testing
> >> > =======
> >> >
> >> 
> >> [snip]
> >> 
> >> I've not been reading through the discussions in complete detail, but
> >> I see no reference to async reads or aio. In the case of aio, aio
> >> presumes the context of the user space process. Could you elaborate on
> >> any testing you've done with these cases? 
> >> 
> >
> > Hi Balbir,
> >
> > So far I had not done any testing with AIO. I have done some just now.
> > Here are the results.
> >
> > Test1 (AIO reads)
> > ================
> > Set up two fio, AIO read jobs in two cgroup with weight 1000 and 500
> > respectively. I am using cfq scheduler. Following are some lines from my test
> > script.
> >
> > ===================================================================
> > fio_args="--ioengine=libaio --rw=read --size=512M"
> 
> AIO doesn't make sense without O_DIRECT.
> 

Ok, here are the read results with --direct=1 for reads. In previous posting,
writes were already direct.

test1 statistics: time=8 16 20796   sectors=8 16 1049648
test2 statistics: time=8 16 10551   sectors=8 16 581160


Not sure why reads are so slow with --direct=1? In the previous test
(no direct IO), I had cleared the caches using
(echo 3 > /proc/sys/vm/drop_caches) so reads could not have come from page
cache?

Thanks
Vivek
