Return-Path: <linux-kernel-owner+w=401wt.eu-S1161207AbXAZTXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161207AbXAZTXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161205AbXAZTXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:23:13 -0500
Received: from vulpecula.futurs.inria.fr ([195.83.212.5]:60028 "EHLO
	vulpecula.futurs.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161207AbXAZTXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:23:12 -0500
X-Greylist: delayed 1818 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jan 2007 14:23:12 EST
Message-ID: <45BA4E01.6050303@tremplin-utc.net>
Date: Fri, 26 Jan 2007 19:52:49 +0100
From: Eric Piel <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: Kirill Korotaev <dev@sw.ru>
Cc: vatsa@in.ibm.com, riel@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Fair-user scheduler
References: <20070126060142.GA2487@in.ibm.com> <45BA0B7C.1090304@sw.ru>
In-Reply-To: <45BA0B7C.1090304@sw.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

01/26/2007 03:09 PM, Kirill Korotaev wrote/a écrit:
> Srivatsa,
> 
>> Current Linux CPU scheduler doesnt recognize process aggregates while
>> allocating bandwidth. As a result of this, an user could simply spawn large 
>> number of processes and get more bandwidth than others.
>>
>> Here's a patch that provides fair allocation for all users in a system.
>>
>> Some benchmark numbers with and without the patch applied follows:
>>
>>
>> 		 	user "vatsa"		    user "guest"
>> 		    (make -s -j4 bzImage)      (make -s -j20 bzImage)
>>
>> 2.6.20-rc5		472.07s (real)		   257.48s (real)
>> 2.6.20-rc5+fairsched	766.74s (real)		   766.73s (real)
> 1. If I interpret these numbers correctly, then your scheduler is not work-conservative,
> i.e. 766.74 + 766.73 >> 472.07 + 257.48
> why does it slow down users so much?
You can't measure work-conservation by summing! Everything is ran 
_concurrently_. A proof of losing computing power is to show 
"MAX(new_algorithm execution_times) > MAX(old_algorithm 
execution_times)". Anyway... it still seems lots of power is lost: 
MAX(766,766) >> MAX(472,257).

Actually, I'd be very interested by a "fairness number" and believe so 
far no one as proposed such thing. Probably needs to take into account 
the loss of CPU power and the variance of execution time in between the 
sets of tasks which are supposed to be fair.

> 2. compilation of kernel is quite CPU-bound task. So it's not that hard to be fair :)
>    Can you please try some other applications?
>    e.g. pipe-based context switching, java Volano benchmark etc.
Another worthy benchmark would be :
(make -s -j4 bzImage) vs (nice make -s -j20 bzImage)
                           ^^^^


Regards,
Eric
