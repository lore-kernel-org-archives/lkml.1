Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbYFMVjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbYFMVjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 17:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYFMVjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 17:39:00 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:64230 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbYFMVi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 17:38:59 -0400
Message-ID: <4852E8D5.3000503@nortel.com>
Date: Fri, 13 Jun 2008 15:38:29 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
       a.p.zijlstra@chello.nl
Subject: odd timing bug with cgroups?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jun 2008 21:38:33.0295 (UTC) FILETIME=[D42715F0:01C8CD9D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm seeing some odd behaviour in the case where a parent task forks a 
child and then immediately attempts to put the child into a group.

It appears that there is a window after task creation where the child 
task is in "limbo" such that the parent cannot put it into a group.  If 
I run the parent under "strace" or else sleep for a bit before trying to 
put the child into a group, then everything works fine.

This seems odd...I would think that as soon as the fork() call returns 
in the parent we should be able to put that task into a group.

I'm just starting to look at the code, but I thought I'd mention it in 
case someone knows exactly where to look.

Chris
