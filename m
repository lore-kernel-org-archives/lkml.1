Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab0BEDHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 22:07:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab0BEDHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 22:07:41 -0500
Message-ID: <4B6B8BD5.8020404@redhat.com>
Date: Fri, 05 Feb 2010 11:09:09 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Peter Zijlstra <peterz@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
References: <Pine.LNX.4.44L0.1002041337590.1261-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1002041337590.1261-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Thu, 4 Feb 2010, Peter Zijlstra wrote:
> 
>> On Thu, 2010-02-04 at 11:35 -0500, Alan Stern wrote:
>>> +#include <linux/sched.h>
>> #include <linux/lockdep.h>
>>
>> should be sufficient I think.
> 
> No, it's not.  It leaves MAX_LOCK_DEPTH undeclared.  Beats me why that 
> symbol ended up in sched.h...
> 

because task_struct->held_locks uses it, but it seems better to move
it into lockdep.h...
