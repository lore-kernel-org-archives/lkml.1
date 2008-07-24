Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbYGXQuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbYGXQuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 12:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYGXQuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 12:50:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:63907 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbYGXQuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 12:50:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,247,1215414000"; 
   d="scan'208";a="24392388"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C8EDAD.52089C68"
Subject: [PATCH] acpi - Add support for AddressRangeUnusuable ACPI memory type
Date: Thu, 24 Jul 2008 09:49:57 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004FC7099@orsmsx416.amr.corp.intel.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] acpi - Add support for AddressRangeUnusuable ACPI memory type
Thread-Index: AcjtrU31ixShJhX5SeCWQIKDlr/hkg==
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Cc: "Kleen, Andi" <andi.kleen@intel.com>, "Wang, Shane" <shane.wang@intel.com>,
       "Wei, Gang" <gang.wei@intel.com>, "Brown, Len" <len.brown@intel.com>
X-OriginalArrivalTime: 24 Jul 2008 16:50:04.0714 (UTC) FILETIME=[525EF8A0:01C8EDAD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C8EDAD.52089C68
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add support for the E820_UNUSABLE memory type, which is defined in
Revision 3.0b (Oct. 10, 2006) of the ACPI Specification on p. 394 Table
14-1:
	AddressRangeUnusuable
	This range of address contains memory in which errors have been
detected. This range must not be used by the OSPM.

This patch applies cleanly to 2.6.26.

Signed-off-by:  Joseph Cihula <joseph.cihula@intel.com>
Signed-off-by:  Shane Wang <shane.wang@intel.com>
Signed-off-by:  Gang Wei <gang.wei@intel.com>

--- linux-2.6.26/arch/x86/kernel/e820_32.c	2008-07-13
14:51:29.000000000 -0700
+++ linux-2.6.26-acpi/arch/x86/kernel/e820_32.c	2008-07-23
13:25:44.000000000 -0700
@@ -198,6 +198,7 @@
 		case E820_RAM:	res->name =3D "System RAM"; break;
 		case E820_ACPI:	res->name =3D "ACPI Tables"; break;
 		case E820_NVS:	res->name =3D "ACPI Non-volatile Storage";
break;
+		case E820_UNUSABLE:     res->name =3D "Unusable memory";
break;
 		default:	res->name =3D "reserved";
 		}
 		res->start =3D e820.map[i].addr;
@@ -604,6 +605,9 @@
 		case E820_NVS:
 				printk("(ACPI NVS)\n");
 				break;
+		case E820_UNUSABLE:
+				printk("(unusable)\n");
+				break;
 		default:	printk("type %u\n", e820.map[i].type);
 				break;
 		}
--- linux-2.6.26/arch/x86/kernel/e820_64.c	2008-07-13
14:51:29.000000000 -0700
+++ linux-2.6.26-acpi/arch/x86/kernel/e820_64.c	2008-07-23
13:27:29.000000000 -0700
@@ -336,6 +336,7 @@
 		case E820_RAM:	res->name =3D "System RAM"; break;
 		case E820_ACPI:	res->name =3D "ACPI Tables"; break;
 		case E820_NVS:	res->name =3D "ACPI Non-volatile Storage";
break;
+		case E820_UNUSABLE:     res->name =3D "Unusable memory";
break;
 		default:	res->name =3D "reserved";
 		}
 		res->start =3D e820.map[i].addr;
@@ -495,6 +496,9 @@
 		case E820_NVS:
 			printk(KERN_CONT "(ACPI NVS)\n");
 			break;
+ 		case E820_UNUSABLE:
+			printk("(unusable)\n");
+			break;
 		default:
 			printk(KERN_CONT "type %u\n", e820.map[i].type);
 			break;
--- linux-2.6.26/include/asm-x86/e820.h	2008-07-13 14:51:29.000000000
-0700
+++ linux-2.6.26-acpi/include/asm-x86/e820.h	2008-07-23
13:25:44.000000000 -0700
@@ -8,6 +8,7 @@
 #define E820_RESERVED	2
 #define E820_ACPI	3
 #define E820_NVS	4
+#define E820_UNUSABLE	5
=20
 #ifndef __ASSEMBLY__
 struct e820entry {
 <<linux-acpi-2.6.26.patch>>=20

------_=_NextPart_001_01C8EDAD.52089C68
Content-Type: application/octet-stream;
	name="linux-acpi-2.6.26.patch"
Content-Transfer-Encoding: base64
Content-Description: linux-acpi-2.6.26.patch
Content-Disposition: attachment;
	filename="linux-acpi-2.6.26.patch"

LS0tIGxpbnV4LTIuNi4yNi9hcmNoL3g4Ni9rZXJuZWwvZTgyMF8zMi5jCTIwMDgtMDctMTMgMTQ6
NTE6MjkuMDAwMDAwMDAwIC0wNzAwCisrKyBsaW51eC0yLjYuMjYtYWNwaS9hcmNoL3g4Ni9rZXJu
ZWwvZTgyMF8zMi5jCTIwMDgtMDctMjMgMTM6MjU6NDQuMDAwMDAwMDAwIC0wNzAwCkBAIC0xOTgs
NiArMTk4LDcgQEAKIAkJY2FzZSBFODIwX1JBTToJcmVzLT5uYW1lID0gIlN5c3RlbSBSQU0iOyBi
cmVhazsKIAkJY2FzZSBFODIwX0FDUEk6CXJlcy0+bmFtZSA9ICJBQ1BJIFRhYmxlcyI7IGJyZWFr
OwogCQljYXNlIEU4MjBfTlZTOglyZXMtPm5hbWUgPSAiQUNQSSBOb24tdm9sYXRpbGUgU3RvcmFn
ZSI7IGJyZWFrOworCQljYXNlIEU4MjBfVU5VU0FCTEU6ICAgICByZXMtPm5hbWUgPSAiVW51c2Fi
bGUgbWVtb3J5IjsgYnJlYWs7CiAJCWRlZmF1bHQ6CXJlcy0+bmFtZSA9ICJyZXNlcnZlZCI7CiAJ
CX0KIAkJcmVzLT5zdGFydCA9IGU4MjAubWFwW2ldLmFkZHI7CkBAIC02MDQsNiArNjA1LDkgQEAK
IAkJY2FzZSBFODIwX05WUzoKIAkJCQlwcmludGsoIihBQ1BJIE5WUylcbiIpOwogCQkJCWJyZWFr
OworCQljYXNlIEU4MjBfVU5VU0FCTEU6CisJCQkJcHJpbnRrKCIodW51c2FibGUpXG4iKTsKKwkJ
CQlicmVhazsKIAkJZGVmYXVsdDoJcHJpbnRrKCJ0eXBlICV1XG4iLCBlODIwLm1hcFtpXS50eXBl
KTsKIAkJCQlicmVhazsKIAkJfQotLS0gbGludXgtMi42LjI2L2FyY2gveDg2L2tlcm5lbC9lODIw
XzY0LmMJMjAwOC0wNy0xMyAxNDo1MToyOS4wMDAwMDAwMDAgLTA3MDAKKysrIGxpbnV4LTIuNi4y
Ni1hY3BpL2FyY2gveDg2L2tlcm5lbC9lODIwXzY0LmMJMjAwOC0wNy0yMyAxMzoyNzoyOS4wMDAw
MDAwMDAgLTA3MDAKQEAgLTMzNiw2ICszMzYsNyBAQAogCQljYXNlIEU4MjBfUkFNOglyZXMtPm5h
bWUgPSAiU3lzdGVtIFJBTSI7IGJyZWFrOwogCQljYXNlIEU4MjBfQUNQSToJcmVzLT5uYW1lID0g
IkFDUEkgVGFibGVzIjsgYnJlYWs7CiAJCWNhc2UgRTgyMF9OVlM6CXJlcy0+bmFtZSA9ICJBQ1BJ
IE5vbi12b2xhdGlsZSBTdG9yYWdlIjsgYnJlYWs7CisJCWNhc2UgRTgyMF9VTlVTQUJMRTogICAg
IHJlcy0+bmFtZSA9ICJVbnVzYWJsZSBtZW1vcnkiOyBicmVhazsKIAkJZGVmYXVsdDoJcmVzLT5u
YW1lID0gInJlc2VydmVkIjsKIAkJfQogCQlyZXMtPnN0YXJ0ID0gZTgyMC5tYXBbaV0uYWRkcjsK
QEAgLTQ5NSw2ICs0OTYsOSBAQAogCQljYXNlIEU4MjBfTlZTOgogCQkJcHJpbnRrKEtFUk5fQ09O
VCAiKEFDUEkgTlZTKVxuIik7CiAJCQlicmVhazsKKyAJCWNhc2UgRTgyMF9VTlVTQUJMRToKKwkJ
CXByaW50aygiKHVudXNhYmxlKVxuIik7CisJCQlicmVhazsKIAkJZGVmYXVsdDoKIAkJCXByaW50
ayhLRVJOX0NPTlQgInR5cGUgJXVcbiIsIGU4MjAubWFwW2ldLnR5cGUpOwogCQkJYnJlYWs7Ci0t
LSBsaW51eC0yLjYuMjYvaW5jbHVkZS9hc20teDg2L2U4MjAuaAkyMDA4LTA3LTEzIDE0OjUxOjI5
LjAwMDAwMDAwMCAtMDcwMAorKysgbGludXgtMi42LjI2LWFjcGkvaW5jbHVkZS9hc20teDg2L2U4
MjAuaAkyMDA4LTA3LTIzIDEzOjI1OjQ0LjAwMDAwMDAwMCAtMDcwMApAQCAtOCw2ICs4LDcgQEAK
ICNkZWZpbmUgRTgyMF9SRVNFUlZFRAkyCiAjZGVmaW5lIEU4MjBfQUNQSQkzCiAjZGVmaW5lIEU4
MjBfTlZTCTQKKyNkZWZpbmUgRTgyMF9VTlVTQUJMRQk1CiAKICNpZm5kZWYgX19BU1NFTUJMWV9f
CiBzdHJ1Y3QgZTgyMGVudHJ5IHsK

------_=_NextPart_001_01C8EDAD.52089C68--
