Return-Path: <linux-kernel-owner+w=401wt.eu-S933913AbYDQSMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbYDQSMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 14:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763001AbYDQSMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 14:12:13 -0400
Received: from webmail1.posta.tim.it ([213.230.128.226]:34188 "EHLO
	fep05-svc.tim.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762038AbYDQSMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 14:12:12 -0400
Message-ID: <480792F3.8020903@unimore.it>
Date: Thu, 17 Apr 2008 20:12:03 +0200
From: Paolo Valente <paolo.valente@unimore.it>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it> <20080417071012.GP12774@kernel.dk> <480709A2.7040606@unimore.it> <20080417083047.GV12774@kernel.dk> <48076A97.9060003@qumranet.com> <48077120.8030007@unimore.it> <480771E5.9070707@qumranet.com>
In-Reply-To: <480771E5.9070707@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity ha scritto:
> Paolo Valente wrote:
>> Avi Kivity ha scritto:
>>> Jumping in at random, does "process" here mean task or mms_struct?  
>>> If the former, doesn't that mean that a 100-thread process can 
>>> starve out a single-threaded process?
>>>
>>> Perhaps we need hierarchical io scheduling, like cfs has for the cpu.
>>>
>> Hierarchical would simplify isolating groups of threads or processes.
>> However, some simple solution is already available with bfq. For 
>> example, if you have to fairly share the disk bandwidth between the 
>> above 100 threads and another important thread, you get it by just 
>> assigning weight 1 to each of these 100 threads, and weight 100 to 
>> the important one.
>
> Doesn't work.  If the 100-thread process wants to use just on thread 
> for issuing I/O, it will be starved by the single-threaded process.
>
> [my example has process A with 100 threads, and process B with 1 
> thread, not a 101-thread process with one important thread]
>
Right. I was thinking only about the case where all the 101 threads 
concurrently access the disk, and I just wanted to say that weights may 
offer more help than priorities in simple cases as this one.
Apart from this, automatically recomputing weights as needed is most 
certainly a worse solution than hierarchical scheduling.

Paolo

