Return-Path: <linux-kernel-owner+w=401wt.eu-S1751367AbXCEUCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbXCEUCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXCEUCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:02:18 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:37434 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbXCEUCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:02:17 -0500
Message-ID: <45EC7740.6040708@nortel.com>
Date: Mon, 05 Mar 2007 14:02:08 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel bug, nice level should not affect SCHED_RR timeslice
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2007 20:02:12.0463 (UTC) FILETIME=[2A029FF0:01C75F61]
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
