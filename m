Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbYA1HuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbYA1HuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 02:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYA1Ht7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 02:49:59 -0500
Received: from sacred.ru ([62.205.161.221]:37690 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbYA1Ht6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 02:49:58 -0500
Message-ID: <479D88C7.5030101@openvz.org>
Date: Mon, 28 Jan 2008 10:48:23 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Vinay Sridhar <vinay@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
       drepper@redhat.com, wli@holomorphy.com, sripathik@in.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC] Per-thread getrusage
References: <1200558425.5992.17.camel@srivinay.in.ibm.com> <20080127215242.b873c341.akpm@linux-foundation.org>
In-Reply-To: <20080127215242.b873c341.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 28 Jan 2008 10:48:11 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 	On Thu, 17 Jan 2008 13:57:05 +0530 Vinay Sridhar <vinay@linux.vnet.ibm.com> wrote:
> 
>> Hi All,
>>
>> Last year, there was discussion about per-thread getrusage by adding
>> RUSAGE_THREAD flag to getrusage(). Please refer to the thread
>> http://lkml.org/lkml/2007/4/4/308. Ulrich had suggested that we should
>> design a better user-space API. Specifically, we need a
>> pthread_getrusage interface in the thread library, which accepts
>> pthread_t, converts pthread_t into the corresponding tid and passes it
>> down to the syscall.
>>
>> There are two ways to implement this in the kernel:
>> 1) Introduce an additional parameter 'tid' to sys_getrusage() and put
>> code in glibc to handle getrusage() and pthread_getrusage() calls
>> correctly.
>> 2) Introduce a new system call to handle pthread_getrusage() and leave
>> sys_getrusage() untouched.
>>
>> We implemented the second idea above, simply because it avoids touching
>> any existing code. We have implemented a new syscall, thread_getrusage()
>> and we have exposed pthread_getrusage() API to applications.
>>
>> Could you please share your thoughts on this? Does the approach look
>> alright? The code is hardly complete. It is just a prototype that works
>> on IA32 at the moment.
>>
>> ...
>>
>> +asmlinkage long sys_thread_getrusage(int tid, struct rusage __user *ru);
> 
> What happens if `tid' refers to a thread in a different pid namespace?
> 

That's impossible. I explicitly deny namespace creation in case the
CLONE_THREAD is specified. So all threads of a single process always
live in one pid namespace.

Thanks,
Pavel
