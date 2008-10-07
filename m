Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbYJGUfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbYJGUfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbYJGUf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:35:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:20903 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756224AbYJGUfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:35:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,375,1220252400"; 
   d="scan'208";a="345106194"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C928BC.24762681"
Subject: [RFC][PATCH 1/3] TXT: ACPI AddressRangeUnusuable support
Date: Tue, 7 Oct 2008 13:34:47 -0700
Message-ID: <D936D925018D154694D8A362EEB0892005AC105D@orsmsx416.amr.corp.intel.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH 1/3] TXT: ACPI AddressRangeUnusuable support
Thread-Index: AckovCNcAKCe62ABSySTNEx3lrEXsA==
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Wang, Shane" <shane.wang@intel.com>, "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       "Chris Wright" <chrisw@redhat.com>, "Jan Beulich" <jbeulich@novell.com>,
       <mingo@elte.hu>, <tytso@mit.edu>
X-OriginalArrivalTime: 07 Oct 2008 20:34:49.0133 (UTC) FILETIME=[24B145D0:01C928BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C928BC.24762681
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

See attached commit message (w/ patch), copied below:

Add support for the E820_UNUSABLE memory type, which is defined in
Revision 3.0b (Oct.  10, 2006) of the ACPI Specification on p.  394
Table
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
arch/x86/kernel/e820.c~acpi-add-support-for-addressrangeunusuable-acpi-m
emory-type arch/x86/kernel/e820.c
---
a/arch/x86/kernel/e820.c~acpi-add-support-for-addressrangeunusuable-acpi
-memory-type
+++ a/arch/x86/kernel/e820.c
@@ -148,6 +148,9 @@ void __init e820_print_map(char *who)
 		case E820_NVS:
 			printk(KERN_CONT "(ACPI NVS)\n");
 			break;
+		case E820_UNUSABLE:
+			printk("(unusable)\n");
+			break;
 		default:
 			printk(KERN_CONT "type %u\n", e820.map[i].type);
 			break;
@@ -1260,6 +1263,7 @@ static inline const char *e820_type_to_s
 	case E820_RAM:	return "System RAM";
 	case E820_ACPI:	return "ACPI Tables";
 	case E820_NVS:	return "ACPI Non-volatile Storage";
+	case E820_UNUSABLE:	return "Unusable memory";
 	default:	return "reserved";
 	}
 }
diff -puN
include/asm-x86/e820.h~acpi-add-support-for-addressrangeunusuable-acpi-m
emory-type include/asm-x86/e820.h
---
a/include/asm-x86/e820.h~acpi-add-support-for-addressrangeunusuable-acpi
-memory-type
+++ a/include/asm-x86/e820.h
@@ -43,6 +43,7 @@
 #define E820_RESERVED	2
 #define E820_ACPI	3
 #define E820_NVS	4
+#define E820_UNUSABLE	5
=20
 /* reserved RAM used by kernel itself */
 #define E820_RESERVED_KERN        128


------_=_NextPart_001_01C928BC.24762681
Content-Type: message/rfc822
Content-Transfer-Encoding: 7bit

X-MimeOLE: Produced By Microsoft Exchange V6.5
Received: from orsmsx335.jf.intel.com ([10.22.226.40]) by orsmsx416.amr.corp.intel.com with Microsoft SMTPSVC(6.0.3790.1830); Tue, 26 Aug 2008 11:45:45 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Received: from azsmsx333.amr.corp.intel.com ([10.2.121.77]) by orsmsx335.jf.intel.com with Microsoft SMTPSVC(6.0.3790.1830); Tue, 26 Aug 2008 11:45:45 -0700
Received: from fmsmga001.fm.intel.com ([10.253.24.23]) by azsmsx333.amr.corp.intel.com with Microsoft SMTPSVC(6.0.3790.1830); Tue, 26 Aug 2008 11:45:45 -0700
Received: from fmsmga101.fm.intel.com ([10.1.193.65])  by fmsmga001-1.fm.intel.com with ESMTP; 26 Aug 2008 11:46:45 -0700
Received: from smtp1.linux-foundation.org ([140.211.169.13])  by mga01.intel.com with ESMTP; 26 Aug 2008 11:43:54 -0700
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55]) by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m7QIinbk031036 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO); Tue, 26 Aug 2008 11:44:50 -0700
Received: from localhost.localdomain (localhost [127.0.0.1]) by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m7QIinld021343; Tue, 26 Aug 2008 11:44:49 -0700
Content-class: urn:content-classes:message
Subject: - acpi-add-support-for-addressrangeunusuable-acpi-memory-type.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:44:49 -0700
Message-ID: <200808261844.m7QIinld021343@imap1.linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: - acpi-add-support-for-addressrangeunusuable-acpi-memory-type.patch removed from -mm tree
Thread-Index: AckHq/M8DymmjbyVT/6tTW8tuGvnzw==
From: <akpm@linux-foundation.org>
To: "Cihula, Joseph" <joseph.cihula@intel.com>,
	<andi@firstfloor.org>,
	"Wei, Gang" <gang.wei@intel.com>,
	<mingo@elte.hu>,
	"Wang, Shane" <shane.wang@intel.com>,
	<tglx@linutronix.de>,
	<mm-commits@vger.kernel.org>


The patch titled
     acpi: add support for AddressRangeUnusuable ACPI memory type
has been removed from the -mm tree.  Its filename was
     acpi-add-support-for-addressrangeunusuable-acpi-memory-type.patch

This patch was dropped because it was merged into mainline or a =
subsystem tree

The current -mm tree may be found at =
http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: add support for AddressRangeUnusuable ACPI memory type
From: "Cihula, Joseph" <joseph.cihula@intel.com>

Add support for the E820_UNUSABLE memory type, which is defined in
Revision 3.0b (Oct.  10, 2006) of the ACPI Specification on p.  394 =
Table
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

diff -puN =
arch/x86/kernel/e820.c~acpi-add-support-for-addressrangeunusuable-acpi-me=
mory-type arch/x86/kernel/e820.c
--- =
a/arch/x86/kernel/e820.c~acpi-add-support-for-addressrangeunusuable-acpi-=
memory-type
+++ a/arch/x86/kernel/e820.c
@@ -148,6 +148,9 @@ void __init e820_print_map(char *who)
 		case E820_NVS:
 			printk(KERN_CONT "(ACPI NVS)\n");
 			break;
+		case E820_UNUSABLE:
+			printk("(unusable)\n");
+			break;
 		default:
 			printk(KERN_CONT "type %u\n", e820.map[i].type);
 			break;
@@ -1260,6 +1263,7 @@ static inline const char *e820_type_to_s
 	case E820_RAM:	return "System RAM";
 	case E820_ACPI:	return "ACPI Tables";
 	case E820_NVS:	return "ACPI Non-volatile Storage";
+	case E820_UNUSABLE:	return "Unusable memory";
 	default:	return "reserved";
 	}
 }
diff -puN =
include/asm-x86/e820.h~acpi-add-support-for-addressrangeunusuable-acpi-me=
mory-type include/asm-x86/e820.h
--- =
a/include/asm-x86/e820.h~acpi-add-support-for-addressrangeunusuable-acpi-=
memory-type
+++ a/include/asm-x86/e820.h
@@ -43,6 +43,7 @@
 #define E820_RESERVED	2
 #define E820_ACPI	3
 #define E820_NVS	4
+#define E820_UNUSABLE	5
=20
 /* reserved RAM used by kernel itself */
 #define E820_RESERVED_KERN        128
_

Patches currently in -mm which might be from joseph.cihula@intel.com are

linux-next.patch


------_=_NextPart_001_01C928BC.24762681--
