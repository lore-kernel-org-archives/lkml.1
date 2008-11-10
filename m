Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbYKJNpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbYKJNpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 08:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbYKJNpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 08:45:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46273 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbYKJNpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 08:45:35 -0500
Date: Mon, 10 Nov 2008 08:44:07 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Rik van Riel <riel@redhat.com>,
       Jeff Moyer <jmoyer@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 1/4] io controller: documentation
Message-ID: <20081110134407.GA26956@redhat.com>
References: <20081106153022.215696930@redhat.com> <20081106153135.743458085@redhat.com> <4917A116.7040603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4917A116.7040603@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 10:48:54AM +0800, Li Zefan wrote:
> Hi, Vivek
> 
> Thanks for your work. :)
> 
> A question below.
> 
> > +For example, assume there are two cgroups A and B with weights 1024 and 2048
> > +in the system. Tasks in two cgroups A and B are doing IO to two disks sda and
> > +sdb in the system. A user has enabled IO control on both sda and sdb. Now on
> > +both sda and sdb, tasks in cgroup B will get to use 2/3 of disk BW and
> > +tasks in cgroup A will get to use 1/3 of disk bandwidth, only in case of
> > +contention. If tasks in any of the groups stop doing IO to a particular disk,
> > +task in other group will get to use full disk BW for that duration.
> > +
> 
> So in this example, I can't assign 1/3 of sda's disk BW while 2/3 of sdb's
> disk BW to A. Am I right?

Hi,

Yes you are right. Currently policies are global and not per disk. So in 
above example, cgroup A will get 1/3 of disk BW both on sda and sdb. And
one can not configure in such a manner so that A gets 1/3 of BW on sda and
2/3 of BW on sdb.

I think assigning cgroup weights per disk should be doable but personally
I think it makes configuration complex and I am not sure if it really a
very useful feature.

Thanks
Vivek
