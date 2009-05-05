Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbZEEDTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbZEEDTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 23:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZEEDT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 23:19:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50045 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbZEEDT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 23:19:26 -0400
Message-ID: <49FFB010.9000309@cn.fujitsu.com>
Date: Tue, 05 May 2009 11:18:40 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Nauman Rafique <nauman@google.com>
CC: Vivek Goyal <vgoyal@redhat.com>, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       menage@google.com, peterz@infradead.org
Subject: Re: [RFC] IO Controller
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <49DF1256.7080403@cn.fujitsu.com> <20090413130958.GB18007@redhat.com> <49EE895A.1060101@cn.fujitsu.com> <20090422132307.GA23098@redhat.com> <49F9FE3C.3070000@google.com>
In-Reply-To: <49F9FE3C.3070000@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nauman Rafique wrote:
...
> Hi Gui,
> This patch should solve the problems reported by you. Please let me know if it does not work.
> @Vivek, this has a few more changes after the patch I sent you separately.
> 

  Hi Nauman,

  I'v tried your patch, seems the bug has been fixed. thanks!

> DESC
> Add ref counting for io_group.
> EDESC
>     
>         Reference counting for io_group solves many problems, most of which
>         occured when we tried to delete the cgroup. Earlier, ioqs were being
>         moved out of cgroup to root cgroup. That is problematic in many ways:
>         First, the pending requests in queues might get unfair service, and
>         will also cause unfairness for other cgroups at the root level. This
>         problem can become signficant if cgroups are created and destroyed
>         relatively frequently. Second, moving queues to root cgroups was
>         complicated and was causing many BUG_ON's to trigger. Third, there is
>         a single io queue in AS, Deadline and Noop within a cgroup; and it
>         does not make sense to move it to the root cgroup. The same is true of
>         async queues.
>     
>         Requests already keep a reference on ioq, so queues keep a reference on
>         cgroup. For async queues in CFQ, and single ioq in other schedulers,
>         io_group also keeps are reference on io_queue. This reference on ioq
>         is dropped when the queue is released (elv_release_ioq). So the queue
>         can be freed.
>     
>         When a queue is released, it puts the reference to io_group and the
>         io_group is released after all the queues are released. Child groups
>         also take reference on parent groups, and release it when they are
>         destroyed.
>     
>         Also we no longer need to maintain a seprate linked list of idle
>         entities, which was maintained only to help release the ioq references
>         during elevator switch. The code for releasing io_groups is reused for
>         elevator switch, resulting in simpler and tight code.
> 
 

-- 
Regards
Gui Jianfeng

