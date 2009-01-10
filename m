Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbZAJVVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbZAJVVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 16:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZAJVVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 16:21:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38704 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbZAJVVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 16:21:21 -0500
Message-ID: <49691134.1070005@redhat.com>
Date: Sat, 10 Jan 2009 16:20:52 -0500
From: Casey Dahlin <cdahlin@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Scott James Remnant <scott@canonical.com>
CC: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
References: <49639EB8.40204@redhat.com>	<4963ABF0.6070400@redhat.com>	 <20090107123457.GB16268@elte.hu>	 <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>	 <a36005b50901071302q70160bady41abc5ed2b105474@mail.gmail.com>	 <20090108143220.GA8717@redhat.com>	 <20090108193530.99D74FC3DD@magilla.sf.frob.com>	 <496663B6.3090709@redhat.com> <1231599041.11642.57.camel@quest>
In-Reply-To: <1231599041.11642.57.camel@quest>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott James Remnant wrote:
> On Thu, 2009-01-08 at 15:36 -0500, Casey Dahlin wrote:
>
>   
>> Roland McGrath wrote:
>>     
>>>>> Since waitfd shouldn't consume the child termination notification
>>>>> waitfd should be more widely usable than the wait*() interfaces.
>>>>>           
>>> waitid can be used that way with WNOWAIT.
>>>       
>> Yes, but waitfd does not have this flag. The reason being waitfd just
>> calls waitid internally, and there is no guarantee (afaik) that
>> calling waitid with WNOWAIT multiple times in succession will yield
>> different results each time. This breaks the streaming behavior of the
>> descriptor.
>>
>>     
> This would definitely be a Nice To Have though!
>
> Being able to use waitid() on another process of the same uid, with
> WNOHANG, in a streaming fashion would be a *very* cool thing.
>
> Scott
>   
That could be done in a separate patch for waitid itself, and its a 
simple change to propagate it through waitfd (just one less EINVAL 
case). In terms of waitfd we'd be supersetting the interface, so its no 
big deal to add. In terms of waitid I'd have to check and make sure that 
we wouldn't be breaking compliance by allowing it to return something 
different on every call (this would likely affect cases where 
waitid(WNOWAIT) was used even in a normal fashion as well).

--CJD
