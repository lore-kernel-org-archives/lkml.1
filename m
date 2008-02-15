Return-Path: <linux-kernel-owner+w=401wt.eu-S1761971AbYBOFZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761971AbYBOFZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 00:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbYBOFZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 00:25:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:62541 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbYBOFZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 00:25:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,356,1199692800"; 
   d="scan'208";a="340279833"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C86F92.CB50E5F8"
Subject: [patch 1/6] Generic thermal management: validate input parameters
Date: Fri, 15 Feb 2008 10:52:44 +0530
Message-ID: <05B550FD4BD2014E841D83547B62600802AA64FF@bgsmsx411.gar.corp.intel.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 1/6] Generic thermal management: validate input parameters
Thread-Index: AchvksroDmoo9QmfSUqjMN+Y0b1Dew==
From: "Thomas, Sujith" <sujith.thomas@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <lenb@kernel.org>, <mingo@elte.hu>, <linux-acpi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
       "Zhang, Rui" <rui.zhang@intel.com>
X-OriginalArrivalTime: 15 Feb 2008 05:22:48.0982 (UTC) FILETIME=[CDDD9B60:01C86F92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C86F92.CB50E5F8
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

From: Thomas Sujith <sujith.thomas@intel.com>

Added sanity check to make sure that thermal zone
and cooling device exists.

Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
---

 drivers/thermal/thermal.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletion(-)

Index: linux-2.6.24/drivers/thermal/thermal.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.24.orig/drivers/thermal/thermal.c
+++ linux-2.6.24/drivers/thermal/thermal.c
@@ -306,12 +306,23 @@ int thermal_zone_bind_cooling_device(str
 {
 	struct thermal_cooling_device_instance *dev;
 	struct thermal_cooling_device_instance *pos;
+	struct thermal_zone_device *pos1;
+	struct thermal_cooling_device *pos2;
 	int result;
=20
 	if (trip >=3D tz->trips || (trip < 0 && trip !=3D
THERMAL_TRIPS_NONE))
 		return -EINVAL;
=20
-	if (!tz || !cdev)
+	list_for_each_entry(pos1, &thermal_tz_list, node) {
+		if (pos1 =3D=3D tz)
+			break;
+	}
+	list_for_each_entry(pos2, &thermal_cdev_list, node) {
+		if (pos2 =3D=3D cdev)
+			break;
+	}
+
+	if (tz !=3D pos1 || cdev !=3D pos2)
 		return -EINVAL;
=20
 	dev =3D

------_=_NextPart_001_01C86F92.CB50E5F8
Content-Type: application/octet-stream;
	name="[patch 1 of 6] Thermal Management - validate input parameters"
Content-Transfer-Encoding: base64
Content-Description: [patch 1 of 6] Thermal Management - validate input parameters
Content-Disposition: attachment;
	filename="[patch 1 of 6] Thermal Management - validate input parameters"

RnJvbTogVGhvbWFzIFN1aml0aCA8c3VqaXRoLnRob21hc0BpbnRlbC5jb20+CgpBZGRlZCBzYW5p
dHkgY2hlY2sgdG8gbWFrZSBzdXJlIHRoYXQgdGhlcm1hbCB6b25lCmFuZCBjb29saW5nIGRldmlj
ZSBleGlzdHMuCgpTaWduZWQtb2ZmLWJ5OiBUaG9tYXMgU3VqaXRoIDxzdWppdGgudGhvbWFzQGlu
dGVsLmNvbT4KLS0tCgogZHJpdmVycy90aGVybWFsL3RoZXJtYWwuYyB8ICAgMTMgKysrKysrKysr
KysrLQogMSBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpJ
bmRleDogbGludXgtMi42LjI0L2RyaXZlcnMvdGhlcm1hbC90aGVybWFsLmMKPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQot
LS0gbGludXgtMi42LjI0Lm9yaWcvZHJpdmVycy90aGVybWFsL3RoZXJtYWwuYworKysgbGludXgt
Mi42LjI0L2RyaXZlcnMvdGhlcm1hbC90aGVybWFsLmMKQEAgLTMwNiwxMiArMzA2LDIzIEBAIGlu
dCB0aGVybWFsX3pvbmVfYmluZF9jb29saW5nX2RldmljZShzdHIKIHsKIAlzdHJ1Y3QgdGhlcm1h
bF9jb29saW5nX2RldmljZV9pbnN0YW5jZSAqZGV2OwogCXN0cnVjdCB0aGVybWFsX2Nvb2xpbmdf
ZGV2aWNlX2luc3RhbmNlICpwb3M7CisJc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnBvczE7
CisJc3RydWN0IHRoZXJtYWxfY29vbGluZ19kZXZpY2UgKnBvczI7CiAJaW50IHJlc3VsdDsKIAog
CWlmICh0cmlwID49IHR6LT50cmlwcyB8fCAodHJpcCA8IDAgJiYgdHJpcCAhPSBUSEVSTUFMX1RS
SVBTX05PTkUpKQogCQlyZXR1cm4gLUVJTlZBTDsKIAotCWlmICghdHogfHwgIWNkZXYpCisJbGlz
dF9mb3JfZWFjaF9lbnRyeShwb3MxLCAmdGhlcm1hbF90el9saXN0LCBub2RlKSB7CisJCWlmIChw
b3MxID09IHR6KQorCQkJYnJlYWs7CisJfQorCWxpc3RfZm9yX2VhY2hfZW50cnkocG9zMiwgJnRo
ZXJtYWxfY2Rldl9saXN0LCBub2RlKSB7CisJCWlmIChwb3MyID09IGNkZXYpCisJCQlicmVhazsK
Kwl9CisKKwlpZiAodHogIT0gcG9zMSB8fCBjZGV2ICE9IHBvczIpCiAJCXJldHVybiAtRUlOVkFM
OwogCiAJZGV2ID0K

------_=_NextPart_001_01C86F92.CB50E5F8--
