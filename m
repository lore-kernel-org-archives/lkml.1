Return-Path: <linux-kernel-owner+w=401wt.eu-S933458AbYBUQqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbYBUQqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759949AbYBUQqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:46:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbYBUQqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:46:00 -0500
Message-ID: <47BDAAB2.3000100@redhat.com>
Date: Thu, 21 Feb 2008 11:45:38 -0500
From: Dave Anderson <anderson@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070718)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mingo@redhat.com, markus.t.metzger@intel.com,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] ptrace: fix 2.6.25 ptrace_bts_config structure declaration
Content-Type: multipart/mixed;
 boundary="------------000807010203030704090409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000807010203030704090409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


The 2.6.25 ptrace_bts_config structure in asm-x86/ptrace-abi.h
is defined with u32 types:

   #include <asm/types.h>

   /* configuration/status structure used in PTRACE_BTS_CONFIG and
      PTRACE_BTS_STATUS commands.
   */
   struct ptrace_bts_config {
           /* requested or actual size of BTS buffer in bytes */
           u32 size;
           /* bitmask of below flags */
           u32 flags;
           /* buffer overflow signal */
           u32 signal;
           /* actual size of bts_struct in bytes */
           u32 bts_size;
   };
   #endif

But u32 is only accessible in asm-x86/types.h if __KERNEL__,
leading to compile errors when ptrace.h is included from
user-space.  Perhaps the double-underscore versions that
are exported to user-space in asm-x86/types.h should be
used instead?

Signed-off-by: anderson@redhat.com







--------------000807010203030704090409
Content-Type: text/x-patch;
 name="ptrace-abi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ptrace-abi.patch"

--- linux-2.6.25-rc2/include/asm-x86/ptrace-abi.h.orig
+++ linux-2.6.25-rc2/include/asm-x86/ptrace-abi.h
@@ -89,13 +89,13 @@
 */
 struct ptrace_bts_config {
 	/* requested or actual size of BTS buffer in bytes */
-	u32 size;
+	__u32 size;
 	/* bitmask of below flags */
-	u32 flags;
+	__u32 flags;
 	/* buffer overflow signal */
-	u32 signal;
+	__u32 signal;
 	/* actual size of bts_struct in bytes */
-	u32 bts_size;
+	__u32 bts_size;
 };
 #endif
 

--------------000807010203030704090409--
