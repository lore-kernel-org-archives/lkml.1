Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZCLHT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZCLHT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZCLHTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:19:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750835AbZCLHTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:19:47 -0400
Date: Thu, 12 Mar 2009 00:11:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       arozansk@redhat.com, jmoyer@redhat.com, oz-kernel@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       menage@google.com, peterz@infradead.org
Subject: Re: [PATCH 01/10] Documentation
Message-Id: <20090312001146.74591b9d.akpm@linux-foundation.org>
In-Reply-To: <1236823015-4183-2-git-send-email-vgoyal@redhat.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com>
	<1236823015-4183-2-git-send-email-vgoyal@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 21:56:46 -0400 Vivek Goyal <vgoyal@redhat.com> wrote:

> +Currently "current" task
> +is used to determine the cgroup (hence io group) of the request. Down the
> +line we need to make use of bio-cgroup patches to map delayed writes to
> +right group.

You handled this problem pretty neatly!

It's always been a BIG problem for all the io-controlling schemes, and
most of them seem to have "handled" it in the above way :(

But for many workloads, writeback is the majority of the IO and it has
always been the form of IO which has caused us the worst contention and
latency problems.  So I don't think that we can proceed with _anything_
until we at least have a convincing plan here.




Also..  there are so many IO controller implementations that I've lost
track of who is doing what.  I do have one private report here that
Andreas's controller "is incredibly productive for us and has allowed
us to put twice as many users per server with faster times for all
users".  Which is pretty stunning, although it should be viewed as a
condemnation of the current code, I'm afraid.

So my question is: what is the definitive list of
proposed-io-controller-implementations and how do I cunningly get all
you guys to check each others homework? :)
