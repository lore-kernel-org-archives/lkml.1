Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYHARuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYHARuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 13:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYHARu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 13:50:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:3248 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbYHARu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 13:50:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,294,1215414000"; 
   d="scan'208";a="425013078"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C8F3FF.14BB2A36"
Subject: [PATCH] acpi: Add support for AddressRangeUnusuable ACPI memory type
Date: Fri, 1 Aug 2008 10:50:23 -0700
Message-ID: <D936D925018D154694D8A362EEB08920050E2B52@orsmsx416.amr.corp.intel.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] acpi: Add support for AddressRangeUnusuable ACPI memory type
Thread-Index: Acjz/xKSlSRdUNn+SsCysahYgLwUTw==
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       <linux-acpi@vger.kernel.org>
Cc: "Kleen, Andi" <andi.kleen@intel.com>, "Wang, Shane" <shane.wang@intel.com>,
       "Wei, Gang" <gang.wei@intel.com>, "Brown, Len" <len.brown@intel.com>
X-OriginalArrivalTime: 01 Aug 2008 17:50:27.0409 (UTC) FILETIME=[14F85C10:01C8F3FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C8F3FF.14BB2A36
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add support for the E820_UNUSABLE memory type, which is defined in
Revision 3.0b (Oct. 10, 2006) of the ACPI Specification on p. 394 Table
14-1:
	AddressRangeUnusuable
	This range of address contains memory in which errors have been
detected. This range must not be used by the OSPM.

This patch applies cleanly to the tip of the current git tree (with the
merged 32/64b e820.c file).

Signed-off-by:  Joseph Cihula <joseph.cihula@intel.com>
Signed-off-by:  Shane Wang <shane.wang@intel.com>
Signed-off-by:  Gang Wei <gang.wei@intel.com>

diff -uprN linux.trees.git/arch/x86/kernel/e820.c
acpi-linux/arch/x86/kernel/e820.c
--- linux.trees.git/arch/x86/kernel/e820.c	2008-08-01
08:14:10.000000000 -0700
+++ acpi-linux/arch/x86/kernel/e820.c	2008-08-01 08:24:19.000000000
-0700
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
diff -uprN linux.trees.git/include/asm-x86/e820.h
acpi-linux/include/asm-x86/e820.h
--- linux.trees.git/include/asm-x86/e820.h	2008-08-01
08:14:24.000000000 -0700
+++ acpi-linux/include/asm-x86/e820.h	2008-08-01 08:25:55.000000000
-0700
@@ -43,6 +43,7 @@
 #define E820_RESERVED	2
 #define E820_ACPI	3
 #define E820_NVS	4
+#define E820_UNUSABLE	5
=20
 /* reserved RAM used by kernel itself */
 #define E820_RESERVED_KERN        128

------_=_NextPart_001_01C8F3FF.14BB2A36
Content-Type: application/octet-stream;
	name="linux-acpi-tip.patch"
Content-Transfer-Encoding: base64
Content-Description: linux-acpi-tip.patch
Content-Disposition: attachment;
	filename="linux-acpi-tip.patch"

ZGlmZiAtdXByTiBsaW51eC50cmVlcy5naXQvYXJjaC94ODYva2VybmVsL2U4MjAuYyBhY3BpLWxp
bnV4L2FyY2gveDg2L2tlcm5lbC9lODIwLmMKLS0tIGxpbnV4LnRyZWVzLmdpdC9hcmNoL3g4Ni9r
ZXJuZWwvZTgyMC5jCTIwMDgtMDgtMDEgMDg6MTQ6MTAuMDAwMDAwMDAwIC0wNzAwCisrKyBhY3Bp
LWxpbnV4L2FyY2gveDg2L2tlcm5lbC9lODIwLmMJMjAwOC0wOC0wMSAwODoyNDoxOS4wMDAwMDAw
MDAgLTA3MDAKQEAgLTE0OCw2ICsxNDgsOSBAQCB2b2lkIF9faW5pdCBlODIwX3ByaW50X21hcChj
aGFyICp3aG8pCiAJCWNhc2UgRTgyMF9OVlM6CiAJCQlwcmludGsoS0VSTl9DT05UICIoQUNQSSBO
VlMpXG4iKTsKIAkJCWJyZWFrOworCQljYXNlIEU4MjBfVU5VU0FCTEU6CisJCQlwcmludGsoIih1
bnVzYWJsZSlcbiIpOworCQkJYnJlYWs7CiAJCWRlZmF1bHQ6CiAJCQlwcmludGsoS0VSTl9DT05U
ICJ0eXBlICV1XG4iLCBlODIwLm1hcFtpXS50eXBlKTsKIAkJCWJyZWFrOwpAQCAtMTI2MCw2ICsx
MjYzLDcgQEAgc3RhdGljIGlubGluZSBjb25zdCBjaGFyICplODIwX3R5cGVfdG9fcwogCWNhc2Ug
RTgyMF9SQU06CXJldHVybiAiU3lzdGVtIFJBTSI7CiAJY2FzZSBFODIwX0FDUEk6CXJldHVybiAi
QUNQSSBUYWJsZXMiOwogCWNhc2UgRTgyMF9OVlM6CXJldHVybiAiQUNQSSBOb24tdm9sYXRpbGUg
U3RvcmFnZSI7CisJY2FzZSBFODIwX1VOVVNBQkxFOglyZXR1cm4gIlVudXNhYmxlIG1lbW9yeSI7
CiAJZGVmYXVsdDoJcmV0dXJuICJyZXNlcnZlZCI7CiAJfQogfQpkaWZmIC11cHJOIGxpbnV4LnRy
ZWVzLmdpdC9pbmNsdWRlL2FzbS14ODYvZTgyMC5oIGFjcGktbGludXgvaW5jbHVkZS9hc20teDg2
L2U4MjAuaAotLS0gbGludXgudHJlZXMuZ2l0L2luY2x1ZGUvYXNtLXg4Ni9lODIwLmgJMjAwOC0w
OC0wMSAwODoxNDoyNC4wMDAwMDAwMDAgLTA3MDAKKysrIGFjcGktbGludXgvaW5jbHVkZS9hc20t
eDg2L2U4MjAuaAkyMDA4LTA4LTAxIDA4OjI1OjU1LjAwMDAwMDAwMCAtMDcwMApAQCAtNDMsNiAr
NDMsNyBAQAogI2RlZmluZSBFODIwX1JFU0VSVkVECTIKICNkZWZpbmUgRTgyMF9BQ1BJCTMKICNk
ZWZpbmUgRTgyMF9OVlMJNAorI2RlZmluZSBFODIwX1VOVVNBQkxFCTUKIAogLyogcmVzZXJ2ZWQg
UkFNIHVzZWQgYnkga2VybmVsIGl0c2VsZiAqLwogI2RlZmluZSBFODIwX1JFU0VSVkVEX0tFUk4g
ICAgICAgIDEyOAo=

------_=_NextPart_001_01C8F3FF.14BB2A36--
