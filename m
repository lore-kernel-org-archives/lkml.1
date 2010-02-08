Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776Ab0BHDO4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 22:14:56 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:64295 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476Ab0BHDOz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 22:14:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O6c3t+rFtShcLMJugUBsqk64WBB8B04+nYWIocVbcS8a3wtVpYeLaDEcvqrWCuA2wl
         GEs1+XTe38eNzU09Jvn5+zip9C04ksJIAgRO6/f3yGWswyVTOwgziWVVNR2FSUlVIRBe
         FMUBxAyvgBrz8aOO561mzVe0/VLIrkw4tiqx0=
MIME-Version: 1.0
In-Reply-To: <4B6F803D.5080007@redhat.com>
References: <Pine.LNX.4.44L0.1002051021120.22829-100000@netrider.rowland.org>
	 <1265384517.30057.50.camel@laptop> <20100207092216.GA2585@darkstar>
	 <4B6F803D.5080007@redhat.com>
Date: Mon, 8 Feb 2010 11:14:53 +0800
Message-ID: <a8e1da1002071914p21de488aobd14005b22aaf392@mail.gmail.com>
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
From: Dave Young <hidave.darkstar@gmail.com>
To: Cong Wang <amwang@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 8, 2010 at 11:08 AM, Cong Wang <amwang@redhat.com> wrote:
> Dave Young wrote:
>>
>> On Fri, Feb 05, 2010 at 04:41:57PM +0100, Peter Zijlstra wrote:
>>>
>>> On Fri, 2010-02-05 at 10:30 -0500, Alan Stern wrote:
>>>>
>>>> On Fri, 5 Feb 2010, Peter Zijlstra wrote:
>>>>
>>>>> Right, so this device stuff is much more complicated than I was led to
>>>>> believe ;-)
>>>>
>>>> Haven't I told you all along that tree-structured locking is
>>>> complicated?  :-)
>>>
>>> Well, regular tree's aren't all that complicated, but multiple
>>> inter-locking trees is a whole different story indeed.
>>>
>>
>> I ever tried converting device semaphore to mutex, but failed with same
>> issue.
>>
>> At least now there's no lockdep solution for it, so I recommend revert
>> the mutex converting patch.
>>
>> following lockdep warning with rc6-mm1:
>>
>> [    0.397123] [    0.397124]
>> =============================================
>> [    0.397359] [ INFO: possible recursive locking detected ]
>> [    0.397480] 2.6.33-rc6-mm1 #1
>> [    0.397596] ---------------------------------------------
>> [    0.397717] swapper/1 is trying to acquire lock:
>> [    0.397836]  (&dev->mutex){+.+...}, at: [<c12662e4>]
>> __driver_attach+0x38/0x63
>> [    0.398162] [    0.398162] but task is already holding lock:
>> [    0.398393]  (&dev->mutex){+.+...}, at: [<c12662d8>]
>> __driver_attach+0x2c/0x63
>> [    0.399999]
>
> Alan already provided a patch for this issue earlier in this thread.

Yes, but device locks can not be classified with regular tree style.
Please read the whole thread.

>
> Thanks.
>
>



-- 
Regards
dave
