Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbYCXVLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbYCXVLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 17:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYCXVLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 17:11:03 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:40852 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYCXVLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 17:11:02 -0400
Message-ID: <47E818E4.2050602@ct.jp.nec.com>
Date: Mon, 24 Mar 2008 14:11:00 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt] rt-slab: fix cpu inconsistency case
References: <47E2A63B.4020003@ct.jp.nec.com> <Pine.LNX.4.58.0803201519160.21990@gandalf.stny.rr.com> <47E2C4CC.5050401@ct.jp.nec.com> <Pine.LNX.4.58.0803211635160.3220@gandalf.stny.rr.com> <47E41EDB.7030908@ct.jp.nec.com> <Pine.LNX.4.58.0803241630290.9884@gandalf.stny.rr.com> <Pine.LNX.4.58.0803241639220.9884@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0803241639220.9884@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 24 Mar 2008, Steven Rostedt wrote:
> 
>> On Fri, 21 Mar 2008, Hiroshi Shimamoto wrote:
>>>> Is this a bug in mainline? The !PREEMPT_RT case should be as close to
>>>> mainline as possible, with no actual changes in object code. If this is
>>>> not the case, then we need to fix that.
>>> No, this issue is in -rt only.
>>>
>> Hi Hiroshi,
>>
>> Thanks again for reporting this. I took a deeper look into this today and
>> came to the conclusion that we need to get rid of both
>> slab_irq_disable_nort and slab_irq_disable_rt, and simply use
>> slab_irq_disable ;-)
>>
>> This is what you patch indirectly does. I'll write up another patch to fix
>> this.
>>
> 
> Actually, I'm going to take your patch.
> 
> Seems that the reason Ingo did the two separate, is that the functions
> called also call the slab_irq_save, which will retake the locks in
> PREEMPT_RT. If we don't release the lock, then we can deadlock.
> 

OK, actually, I had a interest in your rework :-)

thanks,
Hiroshi Shimamoto
