Return-Path: <linux-kernel-owner+w=401wt.eu-S1765820AbZARIia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765820AbZARIia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 03:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbZARIiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 03:38:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42775 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbZARIiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 03:38:20 -0500
Date: Sun, 18 Jan 2009 09:37:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, Kevin Shanahan <kmshanah@ucwb.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler fixes
Message-ID: <20090118083744.GB21940@elte.hu>
References: <1232173776.7073.21.camel@marge.simson.net> <1232186054.6813.48.camel@marge.simson.net> <1232186877.14073.59.camel@laptop> <1232188484.6813.85.camel@marge.simson.net> <1232193617.14073.67.camel@laptop> <1232194752.6273.5.camel@marge.simson.net> <20090117044316.bda7d0bd.akpm@linux-foundation.org> <1232198574.16303.8.camel@marge.simson.net> <20090117160115.GA31601@elte.hu> <4972E860.5080206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4972E860.5080206@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> Ingo Molnar wrote:
>> * Mike Galbraith <efault@gmx.de> wrote:
>>
>>   
>>> On Sat, 2009-01-17 at 04:43 -0800, Andrew Morton wrote:
>>>     
>>>> http://bugzilla.kernel.org/show_bug.cgi?id=12465 just popped up - another
>>>> scheduler regression.  It has been bisected.
>>>>       
>>> Seems pretty clear.  I'd suggest reverting it.
>>>     
>>
>> We can revert it (and will revert it if no solution is found), but i'd  
>> also like to understand why it happens, because that kind of regression 
>> from this change is unexpected - we might be hiding some bug that could 
>> pop up under less debuggable circumstances, so we need to understand it 
>> while we have a chance.
>>
>> Below is the commit in question. Avi, any ideas what makes KVM special  
>> here? Perhaps its use of "preempt notifiers" is causing a problem 
>> somehow?
>>   
>
> preempt notifiers use should cause additional context switch costs of a 
> few thousand cycles and possible an IPI (if a vcpu was migrated).  So 
> I'd suspect scheduling latency here.
>
> Is it possible to trace this (the time between a wake up and actual 
> scheduling of a task)?

Can you reproduce those latencies? We didnt get similar reports from 
elsewhere so there seems to be a KVM angle.

	Ingo
