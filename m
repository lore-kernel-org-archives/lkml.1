Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744Ab0A1Uk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0A1Uk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052Ab0A1Uk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:40:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:54540 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab0A1Uk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:40:26 -0500
Message-ID: <4B61F5B2.70600@windriver.com>
Date: Thu, 28 Jan 2010 14:38:10 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 3/3] perf,hw_breakpoint,kgdb: No mutex taken forkerneldebugger
References: <1264631124-4837-1-git-send-email-jason.wessel@windriver.com> <1264631124-4837-4-git-send-email-jason.wessel@windriver.com> <20100128173307.GB18683@nowhere> <4B61CE1A.8090001@windriver.com> <20100128200951.GD18683@nowhere>
In-Reply-To: <20100128200951.GD18683@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2010 20:38:10.0262 (UTC) FILETIME=[CE079F60:01CAA059]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:

>> If it fails the debugger tried to remove it again later.   It seems to
>> me like it is a don't care corner case.   You get a printk if it ever
>> does happen (which it really shouldn't).
> 
> 
> 
> Yeah truly it's a corner case, especially if the debugger can handle that
> later.
> 
> May be just add a comment so that future reviewers don't stick to
> this part.


If you approve, I'll add your ack.


It looks like this now:


+static int hw_break_release_slot(int breakno)
+{
+	struct perf_event **pevent;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		pevent = per_cpu_ptr(breakinfo[breakno].pev, cpu);
+		if (dbg_release_bp_slot(*pevent))
+			/*
+			 * The debugger is responisble for handing the retry on
+			 * remove failure.
+			 */
+			return -1;
+	}
+	return 0;
+}
+



Thanks,
Jason.
