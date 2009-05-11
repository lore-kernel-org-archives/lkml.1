Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbZEKSMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbZEKSMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZEKSM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:12:29 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50216 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbZEKSM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:12:29 -0400
Message-ID: <4A086A89.6030905@linux.vnet.ibm.com>
Date: Mon, 11 May 2009 11:12:25 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] perf_counter: rework ioctl()s
References: <20090508165219.469818319@chello.nl> <20090508170028.837558214@chello.nl> <18951.32643.749495.538351@drongo.ozlabs.ibm.com>
In-Reply-To: <18951.32643.749495.538351@drongo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
>> Corey noticed that ioctl()s on grouped counters didn't work on the whole group.
>> This extends the ioctl() interface to take a second argument that is
>> interpreted as a flags field. We then provide PERF_IOC_FLAG_GROUP to toggle
>> the behaviour.
>>
>> Having this flag gives the greatest flexibility, allowing you to individually
>> enable/disable/reset counters in a group, or all together.
> 
> As far as enable/disable are concerned, I don't think this is really
> necessary.  My intention was that if you want to enable/disable a
> whole group you just enable/disable the leader and leave all its
> siblings enabled, since if the leader is disabled the whole group
> can't go on.
> 
> Corey's problem was that we have a bug where enabling the leader only
> puts the leader on and not the enabled group members.  I meant to send
> a patch to fix that ages ago but I got distracted.  I'll send out the
> patch shortly.
> 
> Paul.

One problem that I was seeing was that disabling only the group leader didn't 
keep the group member hardware counters from continuing to run and generate 
overflows, and causing sample records to be put in the mmap buffer.

Was this the intention?

For PAPI, we really need to be able to disable, at least, the sample records 
from going into the mmap buffers.  Even better would be to stop the hardware 
counters from counting while disabled.

Otherwise, the only way I have of stopping samples from getting into the buffer 
is to munmap the buffer.


- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
cjashfor@us.ibm.com

