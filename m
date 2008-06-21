Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbYFURBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbYFURBZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 13:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbYFURBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 13:01:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:52939 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbYFURBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 13:01:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=AESTW+wbmHhiuN96HGyZCZnTtNa3Dcdeu92zyVzqkF+KawFCQg616oMFfBhEjDLNgU
         K45aLuyefrrSOp4eKZq/+64/zoAsV9FYvtnAiRTg/1QhAGMClxiVMRyLWykag0tEX+0N
         JHXzTLvD0Q5EQmeMlBEMBnFRZNCms0f/KMO1I=
Message-ID: <2f11576a0806211001w375d440dua42b56edce25bfda@mail.gmail.com>
Date: Sun, 22 Jun 2008 02:01:12 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Paul Menage" <menage@google.com>
Subject: Re: [PATCH] introduce task cgroup v2
Cc: balbir@linux.vnet.ibm.com, "Pavel Emelianov" <xemul@openvz.org>,
       containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       "Li Zefan" <lizf@cn.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <6599ad830806210848q1a1538bcw79c2f3217dd49303@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830806210056n44c7ff37g7cd643f95aef4aa0@mail.gmail.com>
	 <485CC255.9010504@linux.vnet.ibm.com>
	 <20080621180530.E82D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <6599ad830806210848q1a1538bcw79c2f3217dd49303@mail.gmail.com>
X-Google-Sender-Auth: 9720e709a36d258c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I am going to convert spinlock in task limit cgroup to atomic_t.
>> task limit cgroup has following caractatics.
>>        - many write (fork, exit)
>>        - few read
>>        - fork() is performance sensitive systemcall.
>
> This is true, but I don't see how it can be more performance-sensitive
> than the overhead of allocating/freeing a page.
>
> What kinds of performance regressions did you see?

I ran spawn test of unix bench, thus

implement way                   performance degression
-------------------------------------------------------------------------
use res_counter                  15-20%
use spin_lock()                    nealy 10%
use atomic_t                       nealy 5%

Yes, this is really roughly number.
Of cource, I'll post more detail result at next week.

>>          if increase fork overhead, system total performance cause degression.
>
> What kind of overhead were you seeing? How about if you delay doing
> any task accounting until the task_limit subsystem is bound to a
> hierarchy? That way there's no noticeable overhead for people who
> aren't using your subsystem.

honestly, I am seeing it on micro-benchmark only.
but, I'm afraid to performance degression because many people check
performance regression periodically.
So if my implement cause performance regression, they never used mine.

Or, if you strongly want to task_limit subsystem use res_counter,
I can be working on improve to res_counter performance instead.
