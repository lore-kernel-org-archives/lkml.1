Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbYI1U4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbYI1U4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 16:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYI1U4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 16:56:34 -0400
Received: from pih-relay08.plus.net ([212.159.14.20]:45517 "EHLO
	pih-relay08.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYI1U4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 16:56:33 -0400
Message-ID: <48DFEF8A.3000502@yahoo.com>
Date: Sun, 28 Sep 2008 21:56:42 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: How how latent should non-preemptive scheduling be?
References: <fa.Jx/Ygtm46CVRawlA6OnfYNn6cN0@ifi.uio.no> <fa.iIHgL48F3T5VAqFw3mqaf9Pzrs4@ifi.uio.no> <fa.Td8xkKZKMSMghlJmEYefTRVF2kc@ifi.uio.no> <48D39312.9000400@yahoo.com> <20080922115749.GE14301@elte.hu> <48D88DB4.9020003@yahoo.com> <20080923115323.GA27240@elte.hu> <48D919A9.5000708@yahoo.com> <48D9460C.5040504@yahoo.com> <48D96725.1080909@yahoo.com> <20080927204834.GA31650@elte.hu>
In-Reply-To: <20080927204834.GA31650@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 441ecf478467fd0cb2beace28f47524b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> does it get better if you have CONFIG_PREEMPT_VOLUNTARY=y enabled? That 

CONFIG_PREEMPT_VOLUNTARY=y has always been enabled in these results.

> _should_ break up this section neatly. If it doesnt then please add a 
> might_sleep() check to kernel/kernel/semaphore.c's down_timeout() 
> function - that is called a number of times in this trace.

I added might_sleep() to the start of down_timeout() but it neither 
printed anything to dmesg nor changed the latency issue...

Strangely stalling only seems to turn up in linux-tip kernels with very 
little debugging options set within them. I have a linux-tip that has 
lots of extra debugging options set and this problem doesn't show up...

I've also asked about this on the ACPI mailing list and had a huge 
amount of help from finding a good point for a cond_resched - 
http://marc.info/?l=linux-acpi&m=122236450105747&w=2 . Certain things 
(like games) still stutter when the battery is read but it's enough to 
play back sound in rhythmbox without stuttering.

Any ideas why the issue would go away with a debug kernel though?

-- 
Sitsofe | http://sucs.org/~sits/
