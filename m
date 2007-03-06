Return-Path: <linux-kernel-owner+w=401wt.eu-S965176AbXCFPnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965176AbXCFPnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 10:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965172AbXCFPnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 10:43:22 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:61101 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965176AbXCFPnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 10:43:22 -0500
Message-ID: <45ED8C13.5020401@nortel.com>
Date: Tue, 06 Mar 2007 09:43:15 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Linux kernel <linux-kernel@vger.kernel.org>
Subject: resend: KERNEL BUG: nice level should not affect SCHED_RR timeslice
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2007 15:43:19.0058 (UTC) FILETIME=[29CADF20:01C76006]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Apparently the timeslice of the SCHED_RR process varies with nice level 
the same way that it does for SCHED_OTHER.  So while niceness doesn't 
affect the priority of a SCHED_RR task, it does impact how much cpu it gets.

SUSv3 indicates, "Any processes or threads using SCHED_FIFO or SCHED_RR 
shall be unaffected by a call to setpriority()."

The code in set_user_nice() has a comment that leads me to believe the 
current behaviour is accidental (although I think the "not" in the last 
line isn't meant to be there):

/*
  * The RT priorities are set via sched_setscheduler(), but we still
  * allow the 'normal' nice value to be set - but as expected
  * it wont have any effect on scheduling until the task is
  * not SCHED_NORMAL/SCHED_BATCH:
  */

It appears that the desired behaviour is to allow setting the nice level 
of a realtime task, but to not have it affect anything until (and 
unless) it drops that realtime status.  Is this correct?

Chris
