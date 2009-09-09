Return-Path: <linux-kernel-owner+w=401wt.eu-S1751565AbZIIFRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbZIIFRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 01:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbZIIFRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 01:17:48 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:55498 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbZIIFRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 01:17:47 -0400
Date: Wed, 09 Sep 2009 14:17:48 +0900 (JST)
Message-Id: <20090909.141748.189706141.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: balbir@linux.vnet.ibm.com, riel@redhat.com, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com,
       akpm@linux-foundation.org, nauman@google.com,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com
Subject: Re: Regarding dm-ioband tests
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090908134915.GB15974@redhat.com>
References: <20090908032254.GJ8315@balbir.in.ibm.com>
	<20090908.140516.104049366.ryov@valinux.co.jp>
	<20090908134915.GB15974@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> > It is not necessary when controlling bandwidth on a per partition
> > basis or on a IO thread basis like Xen blkback kernel thread.
> > 
> > Here are configration examples.
> > http://sourceforge.net/apps/trac/ioband/wiki/dm-ioband/man/examples
> > 
> 
> For partition based control, where a thread or group of threads is doing
> IO to a specific parition, why can't you simply create different cgroups
> for each partition and move threads in those partitions.
> 
> 
> 			root
> 		 	/ | \
> 		    sda1 sda2 sda3
>
> Above are three groups and move threads doing IO into those groups and
> problem is solved. In fact that's what one will do for KVM virtual
> machines. Move all the qemu helper threds doing IO for a virtual machine
> instance into a specific group and control the IO.
> 
> Why do you have to come up with additional complicated grouping mechanism?

I don't get why you think it's complicated, your io-controller also
provides the same grouping machanism which assigns bandwidth per
device by io.policy file. What's the difference? The thread grouping
machianism is also not special, it is the same concept as cgroup.
These mechanisms are necessary to make use of dm-ioband on the systems
which doesn't support cgroup such as RHEL 5.x. As you know, dm-ioband
also supports cgroup, the configurations you mentioned above can apply
to the system by dm-ioband. I think it's not bad to have several ways
to setup.

Thanks,
Ryo Tsuruta
