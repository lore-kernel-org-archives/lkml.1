Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab0BHD2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 22:28:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab0BHD23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 22:28:29 -0500
Message-ID: <4B6F8543.9080904@redhat.com>
Date: Mon, 08 Feb 2010 11:30:11 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
References: <Pine.LNX.4.44L0.1002051021120.22829-100000@netrider.rowland.org>	 <1265384517.30057.50.camel@laptop> <20100207092216.GA2585@darkstar>	 <4B6F803D.5080007@redhat.com> <a8e1da1002071914p21de488aobd14005b22aaf392@mail.gmail.com>
In-Reply-To: <a8e1da1002071914p21de488aobd14005b22aaf392@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
> On Mon, Feb 8, 2010 at 11:08 AM, Cong Wang <amwang@redhat.com> wrote:
>> Dave Young wrote:
>>> On Fri, Feb 05, 2010 at 04:41:57PM +0100, Peter Zijlstra wrote:
>>>> On Fri, 2010-02-05 at 10:30 -0500, Alan Stern wrote:
>>>>> On Fri, 5 Feb 2010, Peter Zijlstra wrote:
>>>>>
>>>>>> Right, so this device stuff is much more complicated than I was led to
>>>>>> believe ;-)
>>>>> Haven't I told you all along that tree-structured locking is
>>>>> complicated?  :-)
>>>> Well, regular tree's aren't all that complicated, but multiple
>>>> inter-locking trees is a whole different story indeed.
>>>>
>>> I ever tried converting device semaphore to mutex, but failed with same
>>> issue.
>>>
>>> At least now there's no lockdep solution for it, so I recommend revert
>>> the mutex converting patch.
>>>
>>> following lockdep warning with rc6-mm1:
>>>
>>> [    0.397123] [    0.397124]
>>> =============================================
>>> [    0.397359] [ INFO: possible recursive locking detected ]
>>> [    0.397480] 2.6.33-rc6-mm1 #1
>>> [    0.397596] ---------------------------------------------
>>> [    0.397717] swapper/1 is trying to acquire lock:
>>> [    0.397836]  (&dev->mutex){+.+...}, at: [<c12662e4>]
>>> __driver_attach+0x38/0x63
>>> [    0.398162] [    0.398162] but task is already holding lock:
>>> [    0.398393]  (&dev->mutex){+.+...}, at: [<c12662d8>]
>>> __driver_attach+0x2c/0x63
>>> [    0.399999]
>> Alan already provided a patch for this issue earlier in this thread.
> 
> Yes, but device locks can not be classified with regular tree style.

True, Alan mentioned the device trees could be more than one,
which is the difference with the sysfs, I think, where we only
have one tree.

> Please read the whole thread.

Surely I did.

