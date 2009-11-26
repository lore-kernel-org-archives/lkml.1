Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbZKZQK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbZKZQK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760723AbZKZQK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:10:56 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:56029 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760745AbZKZQKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:10:54 -0500
Message-ID: <4B0EA88E.3030205@linux.vnet.ibm.com>
Date: Thu, 26 Nov 2009 17:10:54 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Holger.Wolf@de.ibm.com, epasch@de.ibm.com
Subject: Missing recalculation of scheduler tunables in case of cpu hot add/remove
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,
while testing different scheduler tunables I came across the function 
sched_init_granularity which recalculates the values of 
sysctl_sched_min_granularity, sysctl_sched_latency and 
sysctl_sched_wakeup_granularity  in reference to the number of cpu's 
currently online on boot time. While someone could think the 1+ 
ilog2(num_online_cpus() factor might be wrong or suboptimal I wanted to 
avoid that discussion (at least in this thread :-)).

What I consider more important at the moment is that there is no hook to 
recalculate these values in case cpu hot add/remove takes place.
As an example someone could boot a machine with one online cpu and get 
the low non scaled defaults, later on driven by load the system 
activates more and more processors. Therefore the system could end up 
having  a large amount of cpus with non recalculated scheduler tunables.

I'm looking forward to all other solutions approaches that will come up, 
so the following is just a suggestion.
We might store the corresponding 1cpu values in hidden variables and 
rescale the effective ones on every cpu add/remove.
Additionally there would be the need for some logic to update the 
corresponding 1cpu values every time a user sets new values via the proc 
interface.
I already thought about potential rounding errors in the suggested 
solution, but those might be better than systems being factors off the 
value they should have.

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 

