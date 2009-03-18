Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817AbZCRD2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbZCRD2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 23:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756448AbZCRD2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 23:28:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62894 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754351AbZCRD2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 23:28:09 -0400
Message-ID: <49C069F2.5040003@cn.fujitsu.com>
Date: Wed, 18 Mar 2009 11:26:42 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Valdis.Kletnieks@vt.edu, jkosina@suse.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: 29-rc-mmotm - HID/USB wedge w/ WARNING: at kernel/workqueue.c:371
References: <6648.1237271589@turing-police.cc.vt.edu>	<20090317135424.9151c4f8.akpm@linux-foundation.org>	<37742.1237327272@turing-police.cc.vt.edu>	<49C05C94.7030104@cn.fujitsu.com> <20090317195004.18fb6af6.akpm@linux-foundation.org>
In-Reply-To: <20090317195004.18fb6af6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 18 Mar 2009 10:29:40 +0800 Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
> 
> static void run_workqueue(struct cpu_workqueue_struct *cwq)
> {
> 	spin_lock_irq(&cwq->lock);
> 	cwq->run_depth++;
> 	if (cwq->run_depth > 3) {
> 		/* morton gets to eat his hat */
> 		printk("%s: recursion depth exceeded: %d\n",
> 			__func__, cwq->run_depth);
> 		dump_stack();
> 	}
> 
> That was added five or six years ago, and I never ever got to eat my hat.

If Valdis.Kletnieks let lockdep work, he will see the complain
from lockdep at first.

> 
>> If it's hard for you avoid flush_scheduled_work() in
>> keventd's work fuction by other fix, you can create
>> another workqueue to handle your works, IMO.
> 
> Why do we need to change anything here?  No known bugs were fixed, and some
> new ones were added.
> 

I prefer the code which has no known bugs and no known potential bugs.

I defend myself:
I did not add a new bug as you said, it's the new code hid_cease_io()
adds a new unsafe usage of workqueue.

Thanks, Lai.






