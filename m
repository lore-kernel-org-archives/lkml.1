Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbXIYXRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbXIYXRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbXIYXRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:17:35 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:43557 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbXIYXRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:17:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=IdRx1LPGI4zHINav3Py5KT6l9Ol6pr8ppSgHP6WJO3cnHPKiMOWlPM0MR5nC6H46u8sE3sjyKHX0Eeir/CYXLTqQAU1BbxAd17qjafxwB8zjamQswlC1fSytGl7CouQ8uub7xpXZBiJCy4C90hdfScA+4+XGVZ65T5JeaBoKTns=
Message-ID: <46F996AD.2070107@gmail.com>
Date: Wed, 26 Sep 2007 08:15:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jonathan Corbet <corbet@lwn.net>, ebiederm@xmission.com,
       cornelia.huck@de.ibm.com, greg@kroah.com, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
References: <Pine.LNX.4.44L0.0709251105540.3909-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0709251105540.3909-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Tue, 25 Sep 2007, Tejun Heo wrote:
> 
>> Alan Stern wrote:
>>>> The unloading can proceed once module_unload_inhibit_cnt reaches zero.
>>>> An unloading thread only has to care about inhibition put in effect
>>>> before unloading has started, so there's no need to check again.
>>> You haven't fully answered Jon's question.  Suppose
>>> module_unload_inhibit_cnt is nonzero, so the task adds itself to the
>>> module_unload_wait queue, changes to TASK_UNINTERRUPTIBLE, and calls
>>> schedule.  There's nothing to prevent somebody else from waking the
>>> task back up before the original inhibition has been lifted.
>> Hmmm... I might be missing something here.  Who else can wake up a
>> thread in uninterruptible sleep?
> 
> In principle, anything can.  There has never been any guarantee in the 
> kernel that a task sleeping on a waitqueue will remain asleep until 
> the waitqueue is signalled.  That's part of the reason why things like 
> __wait_event() are coded as loops.

Hmmm... I always thought the queue was because the condition can change
inbetween waking up and actually running.  For example, if the condition
is !(queue empty), another task can enter the critical section and
consume the element which triggered wake up before the woken up task do.

I have no problem with changing the condition check to loop but it would
be great if someone can point me to a code where this unexpected wake up
is used.

Thanks.

-- 
tejun
