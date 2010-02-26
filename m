Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965534Ab0BZRgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:36:12 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:47094
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965498Ab0BZRf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:35:59 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYGM7N-02-2LH-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
       Shashi Belur <shashi-kiran.belur@hp.com>, Tony Jones <tonyj@suse.de>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 09/15] oprofile/x86: add comment to counter-in-use warning
Date: Fri, 26 Feb 2010 18:30:01 +0100
Message-ID: <1267205407-6523-10-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 26 Feb 2010 17:35:47.0335 (UTC) FILETIME=[21843970:01CAB70A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>

Currently, oprofile fails silently on platforms where a non-OS entity
such as the system firmware "enables" and uses a performance
counter. There is a warning in the code for this case.

The warning indicates an already running counter. If oprofile doesn't
collect data, then try using a different performance counter on your
platform to monitor the desired event. Delete the counter from the
desired event by editing the

 /usr/share/oprofile/<cpu_type>/<cpu>/events

file. If the event cannot be monitored by any other counter, contact
your hardware or BIOS vendor.

Cc: Shashi Belur <shashi-kiran.belur@hp.com>
Cc: Tony Jones <tonyj@suse.de>
Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_x86_model.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 59fa2bd..ff82a75 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -59,6 +59,15 @@ struct op_counter_config;
 
 static inline void op_x86_warn_in_use(int counter)
 {
+	/*
+	 * The warning indicates an already running counter. If
+	 * oprofile doesn't collect data, then try using a different
+	 * performance counter on your platform to monitor the desired
+	 * event. Delete counter #%d from the desired event by editing
+	 * the /usr/share/oprofile/%s/<cpu>/events file. If the event
+	 * cannot be monitored by any other counter, contact your
+	 * hardware or BIOS vendor.
+	 */
 	pr_warning("oprofile: counter #%d on cpu #%d may already be used\n",
 		   counter, smp_processor_id());
 }
-- 
1.6.6


