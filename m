Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbYJUL3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbYJUL3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 07:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbYJUL3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 07:29:16 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:61257 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbYJUL3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 07:29:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PBbOAiVgakriZ6NqAwHrSA9ZQMmqPmMr6a7tXWizx/g7iSBtDsM5Byiuih0UMpe47A
         pVdyWiBpBi5R7IyMWjPBApvj1BpEMzK+0maWNlkblrivsga33esTfNIYP3t4HEHMMRqJ
         jN2daucd3BRdtNsdo4HqpSuH96SI6NImY5OtQ=
Message-ID: <c4e36d110810210429q55e959c5hcdf7bfad34cb1f57@mail.gmail.com>
Date: Tue, 21 Oct 2008 13:29:12 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: Scheduler on C2D CPU and latest 2.6.27 kernel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@redhat.com>,
       "Peter Zijlstra" <pzijlstr@redhat.com>
In-Reply-To: <48FDB7E7.4090007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110810210259o38897783i2dc4bcb59e8d32e7@mail.gmail.com>
	 <48FDB7E7.4090007@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/21 Chris Snook <csnook@redhat.com>:
> Zdenek Kabelac wrote:
>>
>> Hi
>>
>> Recently I'm noticing bad behavior of the CPU scheduler on my T61 (2GB,
>> C2D)
>>
>> It looks like Linux concentrates all running tasks on one CPU and the
>> second cpu is sleeping.
>>
>> With recent changes to DRI - glxgears went up to 840FPS but also takes
>> 100% (with Xorg) and when I run 'while :; do true; done' loop in
>> parallel frame rate drops to 300FPS.
>>
>> But as I have C2D CPU I would expect that there should be no such
>> dramatic slowdown.
>>
>> Xosview shows that only one CPU is fully loaded.
>>
>> Here are my .config scheduler options:
>>
>> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
>> # CONFIG_GROUP_SCHED is not set
>> CONFIG_IOSCHED_NOOP=y
>> CONFIG_IOSCHED_AS=y
>> CONFIG_IOSCHED_DEADLINE=y
>> CONFIG_IOSCHED_CFQ=y
>> CONFIG_DEFAULT_IOSCHED="cfq"
>> CONFIG_SCHED_SMT=y
>> # CONFIG_SCHED_MC is not set

I've also tested   SMT=n  MC=y - with same result

>> CONFIG_SCHED_HRTICK=y
>> # CONFIG_NET_SCHED is not set
>> CONFIG_USB_EHCI_TT_NEWSCHED=y
>> CONFIG_SCHED_DEBUG=y
>> CONFIG_SCHEDSTATS=y
>> CONFIG_SCHED_TRACER=y
>>
>>
>> Am I missing something?
>
> You're running a loop that does nothing except create new tasks that have no
> scheduling history, and then disappear before the scheduler can migrate
> them.
>
> Try running 'openssl speed' to chew up CPU.  I promise you the scheduler
> will behave very nicely.

Well -  sorry you really shouldn't promise things you cannot guarantee.

It's obviously showing exactly same problem on my box.

And I should add that with  2.6.27-rc8 I do not experience this behavior.
Gears are showning 80% speed - but consumes only 25%
and bash loop or openssl speed task do not influence its speed.
(as expected with 2CPU machine)

Zdenek.
