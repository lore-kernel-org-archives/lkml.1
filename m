Return-Path: <linux-kernel-owner+w=401wt.eu-S965425AbXDBRqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965425AbXDBRqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 13:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965164AbXDBRqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 13:46:13 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:56156 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965425AbXDBRqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 13:46:11 -0400
Message-ID: <4611414A.3050606@nortel.com>
Date: Mon, 02 Apr 2007 11:45:46 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: question on comment in __oom_kill_task()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2007 17:45:50.0439 (UTC) FILETIME=[C0B5D770:01C7754E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In __oom_kill_task(), there is a comment that says,

"We give our sacrificial lamb high priority and access to all the memory 
it needs. That way it should be able to exit() and clear out its 
resources quickly..."

However, we don't actually change the priority at that point, we just 
give it a large timeslice.

Would it make sense to actually change the priority/policy using 
sched_setscheduler() to give the process a deeply negative nice level or 
maybe even make it realtime?

This seems to help on some of our OOM stress tests.

Chris
