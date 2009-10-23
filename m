Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbZJWTQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbZJWTQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 15:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZJWTQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 15:16:21 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46980 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZJWTQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 15:16:20 -0400
Message-ID: <4AE20102.8010002@linux.vnet.ibm.com>
Date: Fri, 23 Oct 2009 12:16:18 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@au1.ibm.com,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: perf_events: zero time running and enabled, but non-zero count
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

First let me state that I'm working with a Linux kernel which is a couple of
weeks old and came from Linus' post-2.6.31 release tree.  It does contain the
name change from perf_counter to perf_event, for example.

I'm working on some optimizations of PAPI's use of perf_events.  In particular I
want to speed up the reading of events.  To do this, I am doing two things:
1) Not disabling and enabling the counters around reading the counters.  In
other words, read them on the fly.
2) Use the PERF_FORMAT_GROUP option so that I can read up an entire group of
counters in one syscall.

This seems to be working fairly well, except it seems that sometimes the "time
running" and "time enabled" values that I read up are zero, even though the
count is non-zero.  The case I'm looking at has three groups, and it's the third
group, containing a single event, which is getting the zero enabled/running values.

One experiment that I just now tried was to put the code back in that
disables/re-enables the counters around the code that reads the counters.  This
seems to have fixed the problem, but causes a performance degradation, of course.

Is this expected behavior?  Should I be able to read the counts, and times on
the fly like I want to be able to do?

Thanks for your consideration of this issue.

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
cjashfor@us.ibm.com


