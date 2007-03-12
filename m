Return-Path: <linux-kernel-owner+w=401wt.eu-S1030363AbXCLPSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030363AbXCLPSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030370AbXCLPSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:18:40 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:51611 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030363AbXCLPSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:18:39 -0400
Message-ID: <45F56F37.6090407@nortel.com>
Date: Mon, 12 Mar 2007 09:18:15 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: Robert Love <rml@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: resend: KERNEL BUG: nice level should not affect SCHED_RR timeslice
References: <45EF4890.6020806@nortel.com> <200703122027.17219.kernel@kolivas.org>
In-Reply-To: <200703122027.17219.kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Mar 2007 15:18:19.0281 (UTC) FILETIME=[AA559010:01C764B9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:

> Indeed we do change timeslice with nice on rt_tasks in mainline at the moment. 
> Truth is most rt programming couldn't care less about timeslices, but your 
> point about it deviating from the standard is valid. RSDL does not change 
> timeslice with nice on SCHED_RR tasks so it's sort of getting addressed by 
> proxy.

Unfortunately we have some vendor-supplied software that does care about 
timeslices.  It's a crazy thing with multiple SCHED_RR kernel threads 
that don't really self-manage very well.  They're spawned by a 
SCHED_OTHER task and inherit its nice level.

We modified the startup for the spawning task to run it at a lower nice 
level and were fairly surprised when the latency of message handling 
went way up.

Chris
