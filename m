Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYJLUKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYJLUKw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 16:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbYJLUK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 16:10:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:64712 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbYJLUKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 16:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=np63UNKOAFjQ2CyuwxFBH6QwqDWXSWWnLAyMTO+y/QbPGuf+q3Xavp/Gus9phC2NZQ
         okhZ6KyU+nVwkpN8BjHxG8BAE5Bga+dTmCjl02sVcQC9vDVW9RNpBm8ML1qPZY/ZXJAx
         tIm9Upi1G3gF0Fk0IoTg8IFxAHoJt29OkQFn8=
Message-ID: <48F259A7.2030800@gmail.com>
Date: Sun, 12 Oct 2008 23:10:15 +0300
From: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@elte.hu, sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 4/4] Implement semaphore latency tracer
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>	 <1223817124-27239-6-git-send-email-edwintorok@gmail.com> <1223838786.8634.8.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1223838786.8634.8.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-10-12 22:13, Peter Zijlstra wrote:
> On Sun, 2008-10-12 at 16:12 +0300, Török Edwin wrote:
>   
>> Each time a down_read or down_write fails, a unique latency id is generated.
>> Later when someone releases the semaphore, it is blamed for the latency of all
>> tasks on the wait_list of the semaphore.
>> If you would group the output from latency_trace by the latency_id you get all those
>> who were contending on a lock, and the tasks that were holding the lock.
>> An entry in latency_trace has the format:
>> (latency_id) [semaphore_id] read|write
>> stacktrace <= stacktrace
>>     
>
> What can this tracer do that latencytop cannot already do?

Latencytop can show latencies in down_read or down_write (and is very
useful at doing that), but it cannot show who else was holding the
semaphore,
i.e. the true cause of the latency.

Consider:
process A holds a semaphore for reading, process B tries to acquire it
for writing and fails. Latencytop shows the latency in process B, but
doesn't
show anything about process A.

The semlat tracer is doing something more similar to lockstat, but
doesn't need lockdep, and it adds tracepoints on the slowpath only (lock
failed, wakeup).

Best regards,
--Edwin
