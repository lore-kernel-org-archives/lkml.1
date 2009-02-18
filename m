Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbZBRAJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbZBRAJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZBRAJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:09:24 -0500
Received: from hot.fatooh.org ([208.78.103.127]:44943 "EHLO hot.fatooh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbZBRAJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:09:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=fatooh.org; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=domainkeys; b=
	AvnH3JBvjMLoU/Q766jSMxjhwCofOvHAn9zBDUChzeznRT/T494FYa8d+AJBchRC
	F4ZoKFX4iXyEMqUEhC8yftb0LznYAZpJiUqdQCbW5X/Arevd5L8R2Sk2oTPy9Z7P
	JeFy3LixukcIk2IM5q1YEgMa21C+rcdktXsZgSJXNpc=
Message-ID: <499B51AE.2000800@fatooh.org>
Date: Tue, 17 Feb 2009 16:09:18 -0800
From: Corey Hickey <bugfood-ml@fatooh.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, mtk.manpages@gmail.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: RT scheduling and a way to make a process hang, unkillable
References: <4997672B.1000301@fatooh.org> <1234697096.4713.24.camel@laptop>	 <20090216103636.GC17355@linux.vnet.ibm.com>	 <1234782516.4703.15.camel@laptop>	 <20090216120213.GB3925@linux.vnet.ibm.com>	 <1234787082.30178.3.camel@laptop>	 <20090216131440.GC3925@linux.vnet.ibm.com>	 <20090216132014.GD3925@linux.vnet.ibm.com> <4999BC0C.1010304@fatooh.org>	 <20090217050033.GA10409@linux.vnet.ibm.com>	 <20090217101542.GB15989@linux.vnet.ibm.com> <1234869339.4744.77.camel@laptop>
In-Reply-To: <1234869339.4744.77.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2009-02-17 at 15:45 +0530, Dhaval Giani wrote:
> 
>> sched: Don't allow setuid to succeed if the user does not have rt bandwidth
>>
>> Corey Hickey reported that on using setuid to change the uid of a
>> rt process, the process would be unkillable and not be running.
>> This is because there was no rt runtime for that user group. Add
>> in a check to see if a user can attach an rt task to its task group.
> 
> This looks good to me.
> 
> Does anybody object to the -ENOSPC return value? Should we introduce
> -ENOTIME for that?

setuid() failed: No space left on device

For what it's worth, a message like that would be confusing to me if I
didn't already know the context. It's not a big problem in my opinion,
though; I'm just happy there's an error at all, now. :)

I just tested patch v6 and it works nicely for me. Again, thanks a bunch
for the attention to this issue.

-Corey
