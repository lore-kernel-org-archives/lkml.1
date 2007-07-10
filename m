Return-Path: <linux-kernel-owner+w=401wt.eu-S1762267AbXGJLSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267AbXGJLSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 07:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756356AbXGJLSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 07:18:05 -0400
Received: from il.qumranet.com ([82.166.9.18]:41969 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939AbXGJLSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 07:18:04 -0400
Message-ID: <46936AF2.9010400@qumranet.com>
Date: Tue, 10 Jul 2007 14:18:10 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com
Subject: Re: [PATCH][RFC] kvm-scheduler integration
References: <11838994974161-git-send-email-avi@qumranet.com> <20070708133539.GA12597@elte.hu> <4690E973.7000606@qumranet.com> <20070708134850.GB22911@elte.hu> <4690EC47.6060904@qumranet.com> <20070708135905.GA24991@elte.hu>
In-Reply-To: <20070708135905.GA24991@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@qumranet.com> wrote:
>
>   
>>>> Won't that increase task_struct (16 bytes on 64-bit) unnecessarily?  
>>>> The function pointers are common to all virtual machines.
>>>>         
>>> well, this function pointer could then be reused by other virtual 
>>> machines as well, couldnt it?
>>>       
>> I don't get this.  If we add a couple of members to task_struct, it 
>> can't be reused.  The values will be the same across all tasks, but 
>> the memory will be gone (including tasks which aren't virtual 
>> machines).
>>     
>
> i mean, the function pointer is set by KVM, but it could be set to a 
> different value by other hypervisors.
>
> but ... no strong feelings either way, your patch is certainly fine.
>
> Acked-by: Ingo Molnar <mingo@elte.hu>
>
> 	Ingo
>   

How do you feel about some variant of this going into 2.6.23-rc1?  I 
initially thought of this as a 2.6.24 thing, but as it now looks solid, 
maybe we can hurry things along.

If Shaohua ports his spinlock->mutex convertion to the sched branch, we 
get some real benefits:

 - reduced latencies for desktop users
 - less kvm patches to carry in -rt (maybe none?)


-- 
error compiling committee.c: too many arguments to function

