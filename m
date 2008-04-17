Return-Path: <linux-kernel-owner+w=401wt.eu-S1764132AbYDQK1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764132AbYDQK1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbYDQK0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:26:51 -0400
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:32956 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754069AbYDQK0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:26:50 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Apr 2008 06:26:49 EDT
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 17 Apr 2008 20:19:13 +1000
Message-ID: <48072421.60307@cse.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080316)
MIME-Version: 1.0
CC: Paolo Valente <paolo.valente@unimore.it>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it> <20080417071012.GP12774@kernel.dk> <480709A2.7040606@unimore.it> <20080417083047.GV12774@kernel.dk> <4807173E.4060300@unimore.it> <20080417092751.GX12774@kernel.dk>
In-Reply-To: <20080417092751.GX12774@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>> Maybe there is also another middle-ground solution. I'll try to sketch 
>> it out:
>> . use sectors instead of time
>> . impose a penalty to each thread in proportion to the distance between 
>> its disk requests
>> . reduce the maximum budget of each thread as a function of this seek 
>> penalty so as to prevent the thread from stealing more than a given time 
>> slice (the simple mechanism to limit per-thread budget is already 
>> implemented in bfq).
>>
>> By doing so, both fairness and time isolation should be guaranteed.
>> Finally, this policy should be safe in that, given the maximum time used 
>> by a seeky thread to consume its maximum budget on a reference disk, the 
>> time used on any faster disk should be shorter.
>>
>> Does it seem reasonable?
> 
> Not for CFQ, that will stay time based. The problem with #2 above is
> that it then quickly turns to various heuristics, which is just
> impossible to tune for general behaviour. Or it just falls apart for
> other real life situations.

Like SSD or hardware RAID.  Time-slices have the nice property of fairness
irrespective of the underlying hardware characteristics.
