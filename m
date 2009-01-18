Return-Path: <linux-kernel-owner+w=401wt.eu-S932128AbZARIab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbZARIab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 03:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761339AbZARIaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 03:30:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54351 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760940AbZARIaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 03:30:13 -0500
Message-ID: <4972E860.5080206@redhat.com>
Date: Sun, 18 Jan 2009 10:29:20 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Galbraith <efault@gmx.de>, Kevin Shanahan <kmshanah@ucwb.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler fixes
References: <1231964647.14825.59.camel@laptop> <20090116204049.f4d6ef1c.akpm@linux-foundation.org> <1232173776.7073.21.camel@marge.simson.net> <1232186054.6813.48.camel@marge.simson.net> <1232186877.14073.59.camel@laptop> <1232188484.6813.85.camel@marge.simson.net> <1232193617.14073.67.camel@laptop> <1232194752.6273.5.camel@marge.simson.net> <20090117044316.bda7d0bd.akpm@linux-foundation.org> <1232198574.16303.8.camel@marge.simson.net> <20090117160115.GA31601@elte.hu>
In-Reply-To: <20090117160115.GA31601@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
>
>   
>> On Sat, 2009-01-17 at 04:43 -0800, Andrew Morton wrote:
>>     
>>> http://bugzilla.kernel.org/show_bug.cgi?id=12465 just popped up - another
>>> scheduler regression.  It has been bisected.
>>>       
>> Seems pretty clear.  I'd suggest reverting it.
>>     
>
> We can revert it (and will revert it if no solution is found), but i'd 
> also like to understand why it happens, because that kind of regression 
> from this change is unexpected - we might be hiding some bug that could 
> pop up under less debuggable circumstances, so we need to understand it 
> while we have a chance.
>
> Below is the commit in question. Avi, any ideas what makes KVM special 
> here? Perhaps its use of "preempt notifiers" is causing a problem somehow?
>   

preempt notifiers use should cause additional context switch costs of a 
few thousand cycles and possible an IPI (if a vcpu was migrated).  So 
I'd suspect scheduling latency here.

Is it possible to trace this (the time between a wake up and actual 
scheduling of a task)?

-- 
error compiling committee.c: too many arguments to function

