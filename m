Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbZDCBqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbZDCBqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbZDCBqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:46:42 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45239 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbZDCBqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:46:42 -0400
Message-ID: <49D56A7E.80908@linux.vnet.ibm.com>
Date: Thu, 02 Apr 2009 18:46:38 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
Subject: perf_counter: request for three more sample data options
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, perf_counter has the ability to record the following on event 
counter overflow:

Instruction Pointer
Call chain
Group counter values
Thread id

To give perf_counter similar capabilities to perfmon2's default sampling 
  module, I'd like the following additional sample data to be added.

Time stamp
CPU number
Thread Group Id

I'd suggest the following

enum perf_counter_record_format {
         PERF_RECORD_IP          = 1U << 0,
         PERF_RECORD_TID         = 1U << 1,
         PERF_RECORD_TGID        = 1U << 2,
-        PERF_RECORD_GROUP       = 1U << 2,
+        PERF_RECORD_GROUP       = 1U << 3,
-        PERF_RECORD_CALLCHAIN   = 1U << 3,
+        PERF_RECORD_CALLCHAIN   = 1U << 4,
+        PERF_RECORD_CPU_ID      = 1U << 5,
+        PERF_RECORD_TIMESTAMP   = 1U << 6,
};

And of course the obvious changes to perf_event_type.

I would expect that CPU ID would be 32 bits, and the timestamp to be the 
64-bit current time.  TGID is the same size as TID.

I am guessing the only difficult thing here would be obtaining the 
current time from an IRQ, especially NMI handler.  Is this difficult?


-- 
Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

