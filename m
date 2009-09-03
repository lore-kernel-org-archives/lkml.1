Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZICDlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZICDlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 23:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbZICDlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 23:41:44 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:56022 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZICDln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 23:41:43 -0400
Date: Thu, 03 Sep 2009 12:41:44 +0900 (JST)
Message-Id: <20090903.124144.104054881.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: nauman@google.com, riel@redhat.com, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches from Ryo to
 track async bios.
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090903024014.GA8644@redhat.com>
References: <20090902135821.GB5012@redhat.com>
	<20090903.112423.226782505.ryov@valinux.co.jp>
	<20090903024014.GA8644@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> > > At ioband level you just get to see bio and page. How do you decide wheter
> > > this bio is being issued by a process which is a memory hog?
> > > 
> > > In fact requester of memory could be anybody. It could be memory hog or a
> > > different process. So are you saying that you got a mechanism where you 
> > > can detect that a process is memory hog and charge swap activity to it.
> > > IOW, if there are two processes A and B and assume A is the memory hog and
> > > then B requests for memory which triggers lot of swap IO, then you can
> > > charge all that IO to memory hog A?
> > 
> > When an annoymou page is allocated, blkio-cgroup sets an ID to the
> > page. And then when the page is going to swap out, dm-ioband can know
> > who the owner of the page is by retrieving ID from the page.
> > 
> > In the above case, since the pages of the process A are swapped-out, 
> > dm-ioband charges swap IO to the process A.
> > 
> 
> But this does not mean that in all cases memory hog is being charged for
> swap IO, as you have said. So if a process A has done some anonymous page
> allocations and later a memory hog B comes in and forces swap out of A, 
> you will charge A for swap activity which does not seem fair as B is
> memory hog here?

I think this charging policy is not bad, but I think I can understand
you think it's not fair. Do you think it's fair if all IO is carged to B?

We should use both io and memory controller together, as you wrote, 

Thanks,
Ryo Tsuruta
