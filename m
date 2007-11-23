Return-Path: <linux-kernel-owner+w=401wt.eu-S1757047AbXKWS3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbXKWS3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 13:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXKWS3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 13:29:14 -0500
Received: from dizzy.i200.net ([74.86.142.210]:55094 "EHLO dizzy.i200.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbXKWS3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 13:29:13 -0500
Message-ID: <47471BF9.8020100@quo.to>
Date: Fri, 23 Nov 2007 12:29:13 -0600
From: Jordan Russell <jr-list-2007@quo.to>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: 2.6.23.1: Random hangs during boot with "tsc" clocksource
References: <472B59E8.3080709@quo.to> <20071106221548.c8d7b41b.akpm@linux-foundation.org> <47436BA0.5050809@quo.to> <47446690.5090808@redhat.com>
In-Reply-To: <47446690.5090808@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 11/20/2007 06:20 PM, Jordan Russell wrote:
>> Same problem with 2.6.23.8.
>>
>> Are there any specific (TSC related?) patches I should try reverting?
>>
>> Would it help if I captured the dmesg/SysRq output from one of the
>> hanging boots?
>>
>> Any other information that might be useful in getting to the bottom of this?
>>
> 
> Did you try this one? You are seeing problems with preemption disabled,
> but it's at least worth trying.
> 
> 
> 
> From: Marin Mitov <mitov@issp.bas.bg>
> To: linux-kernel@vger.kernel.org
> Subject: [PATCH]new_TSC_based_delay_tsc()
> Cc: Ingo Molnar <mingo@elte.hu>
> Date: 	Tue, 20 Nov 2007 21:32:27 +0200

Thanks for the response.

I backported that patch to 2.6.23.8, but it didn't make a difference.

I also went ahead and tested 2.6.24-rc3 (with no changes to the existing
config settings):

With the new CPU_IDLE option set to "n", it still hangs, but much less
frequently than on 2.6.23.x. In 25 tries, there were 3 hangs, all after
"input: AT Translated Set 2 keyboard as /class/input/input0".

With CPU_IDLE set to "y", it didn't hang at all in 25 tries. However,
CPU_IDLE=y produces these additional messages, which may explain why:

Marking TSC unstable due to: TSC halts in idle.
...
Time: acpi_pm clocksource has been installed.

Not sure what else to try at this point...

-- 
Jordan Russell
