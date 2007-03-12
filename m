Return-Path: <linux-kernel-owner+w=401wt.eu-S965388AbXCLJ2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965388AbXCLJ2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965427AbXCLJ2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:28:14 -0400
Received: from mail04.syd.optusnet.com.au ([211.29.132.185]:37536 "EHLO
	mail04.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965388AbXCLJ2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:28:13 -0400
From: Con Kolivas <kernel@kolivas.org>
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: resend: KERNEL BUG: nice level should not affect SCHED_RR timeslice
Date: Mon, 12 Mar 2007 20:27:16 +1100
User-Agent: KMail/1.9.5
Cc: Robert Love <rml@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
References: <45EF4890.6020806@nortel.com>
In-Reply-To: <45EF4890.6020806@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703122027.17219.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 March 2007 10:19, Chris Friesen wrote:
> I still haven't seen any replies, so I'm resending with a few more
> people directly in the TO list.
>
> The timeslice of a SCHED_RR process currently varies with nice level the
> same way that it does for SCHED_OTHER.  I've included a small app below
> that demonstrates the issue.  So while niceness doesn't affect the
> priority of a SCHED_RR task, it does impact how much cpu it gets
> relative to other SCHED_RR tasks.
>
> SUSv3 indicates, "Any processes or threads using SCHED_FIFO or SCHED_RR
> shall be unaffected by a call to setpriority()."
>
> In addition, the code in set_user_nice() has a comment that leads me to
> believe the current behaviour is accidental (although I think the "not"
> in the last line of the comment isn't meant to be there):
>
> /*
>   * The RT priorities are set via sched_setscheduler(), but we still
>   * allow the 'normal' nice value to be set - but as expected
>   * it wont have any effect on scheduling until the task is
>   * not SCHED_NORMAL/SCHED_BATCH:
>   */
>
> It appears that the desired behaviour is to allow setting the nice level
> of a realtime task, but to not have it affect anything until (and
> unless) it drops that realtime status.  This seems reasonable, but
> doesn't match current behaviour.

Chris. 

Indeed we do change timeslice with nice on rt_tasks in mainline at the moment. 
Truth is most rt programming couldn't care less about timeslices, but your 
point about it deviating from the standard is valid. RSDL does not change 
timeslice with nice on SCHED_RR tasks so it's sort of getting addressed by 
proxy.

-- 
-ck
