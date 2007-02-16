Return-Path: <linux-kernel-owner+w=401wt.eu-S1946050AbXBPTEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946050AbXBPTEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946053AbXBPTEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:04:25 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:51322 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946050AbXBPTEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:04:24 -0500
Message-ID: <45D6001E.1020605@nortel.com>
Date: Fri, 16 Feb 2007 13:03:58 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: misleading comment in __oom_kill_task()?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2007 19:04:07.0215 (UTC) FILETIME=[3B9E3BF0:01C751FD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Towards the end of __oom_kill_task() we see the following comment/code:

	/*
	 * We give our sacrificial lamb high priority and access to
	 * all the memory it needs. That way it should be able to
	 * exit() and clear out its resources quickly...
	 */
	p->time_slice = HZ;
	set_tsk_thread_flag(p, TIF_MEMDIE);

	force_sig(SIGKILL, p);

I see it getting a large timeslice and access to memory, but I don't 
actually see the priority getting bumped at all.  It appears the comment 
is inaccurate.

Should the process actually get its priority bumped up as well so that 
it can process its own death faster?  The reason I ask is that we're 
seeing some oom-killed processes taking a very long time (multiple 
seconds) to actually die.

Chris
