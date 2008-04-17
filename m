Return-Path: <linux-kernel-owner+w=401wt.eu-S934366AbYDQPvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934366AbYDQPvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762913AbYDQPvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:51:07 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37814
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761796AbYDQPvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:51:06 -0400
Message-ID: <480771E5.9070707@qumranet.com>
Date: Thu, 17 Apr 2008 18:51:01 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paolo Valente <paolo.valente@unimore.it>
CC: Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it> <20080417071012.GP12774@kernel.dk> <480709A2.7040606@unimore.it> <20080417083047.GV12774@kernel.dk> <48076A97.9060003@qumranet.com> <48077120.8030007@unimore.it>
In-Reply-To: <48077120.8030007@unimore.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Valente wrote:
> Avi Kivity ha scritto:
>> Jumping in at random, does "process" here mean task or mms_struct?  
>> If the former, doesn't that mean that a 100-thread process can starve 
>> out a single-threaded process?
>>
>> Perhaps we need hierarchical io scheduling, like cfs has for the cpu.
>>
> Hierarchical would simplify isolating groups of threads or processes.
> However, some simple solution is already available with bfq. For 
> example, if you have to fairly share the disk bandwidth between the 
> above 100 threads and another important thread, you get it by just 
> assigning weight 1 to each of these 100 threads, and weight 100 to the 
> important one.

Doesn't work.  If the 100-thread process wants to use just on thread for 
issuing I/O, it will be starved by the single-threaded process.

[my example has process A with 100 threads, and process B with 1 thread, 
not a 101-thread process with one important thread]


-- 
error compiling committee.c: too many arguments to function

