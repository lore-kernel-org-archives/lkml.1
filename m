Return-Path: <linux-kernel-owner+w=401wt.eu-S1760811AbXK1WmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760811AbXK1WmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757634AbXK1WmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:42:00 -0500
Received: from mx2.go2.pl ([193.17.41.42]:52730 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756579AbXK1Wl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:41:59 -0500
Message-ID: <474DEF79.1080900@o2.pl>
Date: Wed, 28 Nov 2007 23:45:13 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Larry Finger <larry.finger@lwfinger.net>
CC: Andreas Schwab <schwab@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding mutex locking
References: <474CF06C.8020208@lwfinger.net> <jemysy2y3y.fsf@sykes.suse.de> <474D8C22.7010902@lwfinger.net>
In-Reply-To: <474D8C22.7010902@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote, On 11/28/2007 04:41 PM:

> Andreas Schwab wrote:
>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>
>>> If a particular routine needs to lock a mutex, but it may be entered with that mutex already locked,
>>> would the following code be SMP safe?
>>>
>>> hold_lock = mutex_trylock()
>>>
>>> ...
>>>
>>> if (hold_lock)
>>> 	mutex_unlock()
>> When two CPUs may enter the critical region at the same time, what is
>> the point of the mutex?  Also, the first CPU may unlock the mutex while
>> the second one is still inside the critical region.
> 
> Thank you for that answer. I think that I'm finally beginning to understand.

Probably it would be faster without these "...", which look like
no man's land...

hold_lock = mutex_trylock()
if (hold_lock) {
	/* SMP safe */
	...
 	mutex_unlock()
} else {
	/* SMP unsafe */
	...
	/* maybe try again after some break or check */
}

Regards,
Jarek P.
