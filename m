Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbYFLLP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbYFLLP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 07:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbYFLLPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 07:15:14 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:4074 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYFLLPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 07:15:12 -0400
Message-ID: <4851052A.80008@hp.com>
Date: Thu, 12 Jun 2008 07:14:50 -0400
From: Mark Seger <Mark.Seger@hp.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, util-linux-ng@vger.kernel.org
CC: Karel Zak <kzak@redhat.com>, Andrea Righi <a.righi@cineca.it>,
       Balbir Singh <balbir@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Latest release of collectl can now show top processes sorted by I/O
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This felt significant enough to announce to a wider audience.  If you 
haven't heard of collectl before, see: 
http://collectl.sourceforge.net/index.html, as monitoring processes is 
just a small component of what it can do and besides the 'usual set of 
suspects' such as cpu, network, disk and memory it can also monitor less 
common types of data such as nfs, slabs, lustre, quadrics, infiniband 
and even interrupts by cpu!  To read more about its capabilities see 
http://collectl.sourceforge.net/Features.html

The short story on I/O is you can now say "collectl --top io" and see a 
dynamically sorted list of top I/O users, displayed once a second, 
assuming of course that you're using a kernel that supports this.  If 
you include --procopts t, you can also see the top threads as well.  
Unfortunately there's a bug in the way I/O stats are currently reported 
in that if you just look at a process and not its threads, the aggregate 
is not included and so you can see I/O rates of 0 while the threads are 
working their little hearts out.  Andrea Righi has published a patch 
that corrects this and both his patch and my original bugzilla can be 
found at the bottom of the page that describes process monitoring in 
more detail at http://collectl.sourceforge.net/Process.html.  Just one 
comment, and I tried to be more descriptive in the webpage, looking for 
new processes/threads can be pretty labor intensive and by applying 
appropriate filters or taking less frequent samples you can 
significantly reduce the system load.

-mark


