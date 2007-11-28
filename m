Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbXK1XEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbXK1XEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756746AbXK1XEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:04:32 -0500
Received: from mx12.go2.pl ([193.17.41.142]:39327 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756381AbXK1XEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:04:31 -0500
Message-ID: <474DF4CB.4090606@o2.pl>
Date: Thu, 29 Nov 2007 00:07:55 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
CC: Larry Finger <larry.finger@lwfinger.net>, Andreas Schwab <schwab@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding mutex locking
References: <474CF06C.8020208@lwfinger.net> <jemysy2y3y.fsf@sykes.suse.de> <474D8C22.7010902@lwfinger.net> <474DEF79.1080900@o2.pl> <474DF207.2090705@o2.pl>
In-Reply-To: <474DF207.2090705@o2.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote, On 11/28/2007 11:56 PM:

> Jarek Poplawski wrote, On 11/28/2007 11:45 PM:
> 
>> Larry Finger wrote, On 11/28/2007 04:41 PM:
>>
>>> Andreas Schwab wrote:
>>>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>>>
>>>>> If a particular routine needs to lock a mutex, but it may be entered with that mutex already locked,
>>>>> would the following code be SMP safe?
>>>>>
>>>>> hold_lock = mutex_trylock()
>>>>>
>>>>> ...
>>>>>
>>>>> if (hold_lock)
>>>>> 	mutex_unlock()
>>>> When two CPUs may enter the critical region at the same time, what is
>>>> the point of the mutex?  Also, the first CPU may unlock the mutex while
>>>> the second one is still inside the critical region.
>>> Thank you for that answer. I think that I'm finally beginning to understand.
>> Probably it would be faster without these "...", which look like
>> no man's land...
>>
>> hold_lock = mutex_trylock()
>> if (hold_lock) {
>> 	/* SMP safe */
>> 	...
>>  	mutex_unlock()
>> } else {
>> 	/* SMP unsafe */


...But, not for sure! If our caller holds the lock and we can
check this...

>> 	...
>> 	/* maybe try again after some break or check */
> 
> 
> OOPS! Of course, since it can be called with this lock held,
> any break is not enough: we can only check if there is a
> possibility that another thread is holding the lock.
> 
>> }
>>
>> Regards,
>> Jarek P.
> 
> 


