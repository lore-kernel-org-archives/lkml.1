Return-Path: <linux-kernel-owner+w=401wt.eu-S1757651AbYBFSGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbYBFSGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 13:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbYBFSFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 13:05:50 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:35526 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbYBFSFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 13:05:49 -0500
Message-ID: <47A9F6BE.1010800@qualcomm.com>
Date: Wed, 06 Feb 2008 10:04:46 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: RT scheduler config, suggestions and questions
References: <47A8F328.5070107@qualcomm.com>	 <1202279815.19243.34.camel@lappy> <1202297381.19243.48.camel@lappy>
In-Reply-To: <1202297381.19243.48.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2008-02-06 at 07:36 +0100, Peter Zijlstra wrote:
> 
>>> btw I can see "watchdog" being very useful to catch hard-RT tasks that exceed the deadline.
>>> But's it gotta be per thread.
>> It is.
>>
>>> Single setting per user is not enough. Unless a use has a single RT task.
>> ?
> 
> Ah, its starting to make sense, you want it configurable per thread, not
> process wide. Yes, I see how that is useful, just no idea how to expose
> that to user-space atm.
Yes. That's what I meant. I don't think overall per process setting is that useful.
Per thread though would be useful.

How to expose that to the user-space ? The best option in my opinion is to extend
struct sched_param. That way both sched_setparam() and pthread_attr_setschedparam() 
can be used to set new attributes and it's backwards compatible.
Something like:

struct sched_param {
	...
	unsigned int sched_rt_limit;
	unsigned int sched_rt_...;
};

Max
