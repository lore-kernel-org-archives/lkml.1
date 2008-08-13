Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYHMJBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYHMJBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 05:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYHMJBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 05:01:05 -0400
Received: from il.qumranet.com ([212.179.150.194]:58413 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbYHMJBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 05:01:05 -0400
Message-ID: <48A2A2CF.3050703@qumranet.com>
Date: Wed, 13 Aug 2008 12:01:03 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: Max Krasnyansky <maxk@qualcomm.com>, LKML <linux-kernel@vger.kernel.org>,
       andrea@qumranet.com, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Circular vma locking with kvm, seems to be mmu notifiers related
References: <48A0D6A9.4030603@qualcomm.com> <48A29D0D.9010801@qumranet.com> <87od3x9u61.fsf@skyscraper.fehenstaub.lan>
In-Reply-To: <87od3x9u61.fsf@skyscraper.fehenstaub.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> Hi Avi,
>
> Avi Kivity <avi@qumranet.com> writes:
>
>   
>> Max Krasnyansky wrote:
>>     
>>> Got this on the latest mainline git.
>>> There are already a couple of lockdep/kvm threads. So maybe it's known.
>>>
>>> =============================================
>>> [ INFO: possible recursive locking detected ]
>>> 2.6.27-rc2 #36
>>> ---------------------------------------------
>>> qemu-system-x86/3445 is trying to acquire lock:
>>>  (&anon_vma->lock){--..}, at: [<ffffffff8029f84d>] mm_take_all_locks+0x8d/0xf0
>>>
>>> but task is already holding lock:
>>>  (&anon_vma->lock){--..}, at: [<ffffffff8029f84d>] mm_take_all_locks+0x8d/0xf0
>>>
>>>   
>>>       
>> Seems to be a false positive.  mmu_take_all_locks takes (surprise!)
>> all anon_vma->locks belonging to an mm, and takes special care not to
>> deadlock while doing this.
>>
>> We need to communicate this to lockdep somehow.
>>     
>
> I think Peter already annotated this in
> 454ed842d55740160334efc9ad56cfef54ed37bc .
>
>   

Excellent, thanks for the info.

-- 
error compiling committee.c: too many arguments to function

