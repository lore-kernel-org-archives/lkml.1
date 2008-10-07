Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbYJGW54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbYJGW54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYJGW5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:57:48 -0400
Received: from mga05.intel.com ([192.55.52.89]:54629 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753969AbYJGW5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:57:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,375,1220252400"; 
   d="scan'208";a="624522929"
Message-ID: <48EBE96A.6080700@linux.intel.com>
Date: Tue, 07 Oct 2008 15:57:46 -0700
From: Joseph Cihula <joseph.cihula@linux.intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: shane.wang@intel.com, gang.wei@intel.com, arjan@linux.intel.com,
       asit.k.mallick@intel.com, jun.nakajima@intel.com, chrisw@sous-sol.org,
       jbeulich@novell.com, mingo@elte.hu, tytso@mit.edu,
       linux-kernel@vger.kernel.org, joseph.cihula@intel.com
Subject: [RFC][PATCH 1/3] TXT: ACPI AddressRangeUnusuable support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(re-posted with apologies for formatting and email addresses)

Commit message (w/ patch), copied below:

Add support for the E820_UNUSABLE memory type, which is defined in 
Revision 3.0b (Oct.  10, 2006) of the ACPI Specification on p.  394 Table
14-1:

  AddressRangeUnusuable This range of address contains memory in which
  errors have been detected.  This range must not be used by the OSPM.

Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>
Signed-off-by: Shane Wang <shane.wang@intel.com>
Signed-off-by: Gang Wei <gang.wei@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/e820.c |    4 ++++
 include/asm-x86/e820.h |    1 +
 2 files changed, 5 insertions(+)

diff -puN 
arch/x86/kernel/e820.c~acpi-add-support-for-addressrangeunusuable-acpi-memory-type 
arch/x86/kernel/e820.c
--- 
a/arch/x86/kernel/e820.c~acpi-add-support-for-addressrangeunusuable-acpi-memory-type
+++ a/arch/x86/kernel/e820.c
@@ -148,6 +148,9 @@ void __init e820_print_map(char *who)
         case E820_NVS:
             printk(KERN_CONT "(ACPI NVS)\n");
             break;
+        case E820_UNUSABLE:
+            printk("(unusable)\n");
+            break;
         default:
             printk(KERN_CONT "type %u\n", e820.map[i].type);
             break;
@@ -1260,6 +1263,7 @@ static inline const char *e820_type_to_s
     case E820_RAM:    return "System RAM";
     case E820_ACPI:    return "ACPI Tables";
     case E820_NVS:    return "ACPI Non-volatile Storage";
+    case E820_UNUSABLE:    return "Unusable memory";
     default:    return "reserved";
     }
 }
diff -puN 
include/asm-x86/e820.h~acpi-add-support-for-addressrangeunusuable-acpi-memory-type 
include/asm-x86/e820.h
--- 
a/include/asm-x86/e820.h~acpi-add-support-for-addressrangeunusuable-acpi-memory-type
+++ a/include/asm-x86/e820.h
@@ -43,6 +43,7 @@
 #define E820_RESERVED    2
 #define E820_ACPI    3
 #define E820_NVS    4
+#define E820_UNUSABLE    5
 
 /* reserved RAM used by kernel itself */
 #define E820_RESERVED_KERN        128

