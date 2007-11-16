Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbXKPIJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbXKPIJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 03:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbXKPIJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 03:09:09 -0500
Received: from il.qumranet.com ([82.166.9.18]:46041 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbXKPIJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 03:09:08 -0500
Message-ID: <473D5016.4000105@qumranet.com>
Date: Fri, 16 Nov 2007 10:08:54 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: x86: disable preemption in delay_tsc()
References: <200711150400.lAF40lIr020160@hera.kernel.org> <20071115194116.12c7a0f6@laptopd505.fenrus.org>
In-Reply-To: <20071115194116.12c7a0f6@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (firebolt.argo.co.il [0.0.0.0]); Fri, 16 Nov 2007 10:08:55 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Thu, 15 Nov 2007 04:00:47 GMT
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
>
>   
>> Gitweb:
>> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=35d5d08a085c56f153458c3f5d8ce24123617faf
>> Commit:     35d5d08a085c56f153458c3f5d8ce24123617faf Parent:
>> 7eea436433b7b18045f272562e256976f593f7c0 Author:     Andrew Morton
>> <akpm@linux-foundation.org> AuthorDate: Wed Nov 14 17:00:41 2007 -0800
>> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
>> CommitDate: Wed Nov 14 18:45:44 2007 -0800
>>
>>     x86: disable preemption in delay_tsc()
>>     
>>     Marin Mitov points out that delay_tsc() can misbehave if it is
>> preempted and rescheduled on a different CPU which has a skewed TSC.
>> Fix it by disabling preemption.
>>  
>>     
>
> this worries me.. this appears to effectively disable preemption during
> udelay() and mdelay() loops... which are very obvious latency inducers.
>
> Now you can argue that if you're preemptible you should have used
> msleep() and co, and I'll totally buy that. 
>
>
> Maybe we should just check if we're still on the same cpu or something,
> or have a cheap way to pin a process to a cpu.... but both are longer
> term solutions.
>
>   

You can use preemption notifiers to get a callback when you are
preempted.  Not sure what you'd to with that callback, though.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

