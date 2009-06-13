Return-Path: <linux-kernel-owner+w=401wt.eu-S934001AbZFMB1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001AbZFMB1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 21:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZFMB1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 21:27:11 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60981 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZFMB1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 21:27:10 -0400
Message-ID: <4A330022.3070105@linux.vnet.ibm.com>
Date: Fri, 12 Jun 2009 18:25:54 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: perf_counters: page fault trace record
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

One of the tools we are working on needs to be able to look not only at counts 
of page faults, but where they are occurring (ip and faulting page address).

What would you think about adding a new bit to the config record, something like:

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 6e13395..c27d0bc 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -167,8 +167,9 @@ struct perf_counter_attr {
                                 mmap           :  1, /* include mmap data     */
                                 comm           :  1, /* include comm data     */
                                 freq           :  1, /* use freq, not period  */
-
-                               __reserved_2   : 53;
+                               page_fault     :  1, /* include page fault data
*/
+
+                               __reserved_2   : 52;

We'd need a new event type too - PERF_EVENT_PAGE_FAULT which would have:

/*
  * struct {
  *      struct perf_event_header header;
  *      u64                      ip;
  *      u64                      fault_address;
  * };
  */

etc.

I would guess that special care would need to be taken to post an event record 
like this on the thread of a page fault handler.

Any objection to this idea?



Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
cjashfor@us.ibm.com

