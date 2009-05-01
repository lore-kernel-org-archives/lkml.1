Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbZEALLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbZEALLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZEALL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:11:27 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:41884 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbZEALL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:11:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z4ZdLeQHx6KQejjk+6jSnguqrkhbOMApDd3yaAxA3BgkIcfNVvgNMzjVVrdkc8Jn/6
         j1b+5AedLGeBzWlAIe29P9EzkZ/1GDOhW4SVPJb1TX5iLJLqzIoYR5ordCTqSmNmNuWY
         fpVUjbt6LTNWJFlG6HXmayT0xhd9Ss7xrzulw=
Date: Fri, 1 May 2009 13:11:22 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] cgroup: io-throttle controller (v13)
Message-ID: <20090501111121.GA25964@linux>
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <49F9A5BA.9030100@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F9A5BA.9030100@hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 09:20:58AM -0400, Alan D. Brunelle wrote:
> Hi Andrea -

Hi Alan,

> 
> FYI: I ran a simple test using this code to try and gauge the overhead
> incurred by enabling this technology. Using a single 400GB volume split
> into two 200GB partitions I ran two processes in parallel performing a
> mkfs (ext2) on each partition. First w/out cgroup io-throttle and then
> with it enabled (with each task having throttling enabled to
> 400MB/second (much, much more than the device is actually capable of
> doing)). The idea here is to see the base overhead of just having the
> io-throttle code in the paths.

Interesting. I've never explicitly measured the actual overhead of the
io-throttle infrastructure, I'll add a similar test to the io-throttle
testcase.

> 
> Doing 30 runs of each (w/out & w/ io-throttle enabled) shows very little
> difference (time in seconds)
> 
> w/out: min=80.196 avg=80.585 max=81.030 sdev=0.215 spread=0.834
> with:  min=80.402 avg=80.836 max=81.623 sdev=0.327 spread=1.221
> 
> So only around 0.3% overhead - and that may not be conclusive with the
> standard deviations seen.

You should see less overhead with reads respect to a pure write
workload, because with reads we don't need to check if the IO request
occurs in a different IO context. And things should be improved with
v16-rc1
(http://download.systemimager.org/~arighi/linux/patches/io-throttle/cgroup-io-throttle-v16-rc1.patch).

So, it would be also interesting to analyse the overhead of a read
stream compared to a write stream, as well a comparison of random
reads/writes. I'll do that in my next benchmarking session.

> 
> --
> 
> FYI: The test was run on 2.6.30-rc1+your patches on a 16-way x86_64 box
> (128GB RAM) plus a single FC volume off of a 1Gb FC RAID controller.
> 
> Regards,
> Alan D. Brunelle
> Hewlett-Packard

Thanks for posting these results,
-Andrea
