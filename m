Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbYBOF1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbYBOF1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 00:27:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYBOF0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 00:26:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:63066 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbYBOF0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 00:26:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,356,1199692800"; 
   d="scan'208";a="518994655"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C86F93.12FADB11"
Subject: [patch 5/6] ACPI video: check for error in thermal_cooling_device_register call
Date: Fri, 15 Feb 2008 10:54:44 +0530
Message-ID: <05B550FD4BD2014E841D83547B62600802AA650C@bgsmsx411.gar.corp.intel.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 5/6] ACPI video: check for error in thermal_cooling_device_register call
Thread-Index: AchvkxKvhAGGAozZTeW6+yo1MLJEZw==
From: "Thomas, Sujith" <sujith.thomas@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <lenb@kernel.org>, <mingo@elte.hu>, <linux-acpi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
       "Zhang, Rui" <rui.zhang@intel.com>
X-OriginalArrivalTime: 15 Feb 2008 05:24:49.0227 (UTC) FILETIME=[158989B0:01C86F93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C86F93.12FADB11
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

From: Thomas Sujith <sujith.thomas@intel.com>

Need to check whetherthermal_cooling_device_register
returned ERROR or not.

Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
---

 drivers/acpi/video.c |    3 +++
 1 files changed, 3 insertions(+)

Index: linux-2.6.24/drivers/acpi/video.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.24.orig/drivers/acpi/video.c
+++ linux-2.6.24/drivers/acpi/video.c
@@ -731,6 +731,9 @@ static void acpi_video_device_find_cap(s
=20
 		device->cdev =3D thermal_cooling_device_register("LCD",
 					device->dev,
&video_cooling_ops);
+		if (IS_ERR(device->cdev))
+			return;
+
 		if (device->cdev) {
 			printk(KERN_INFO PREFIX
 				"%s is registered as
cooling_device%d\n",

------_=_NextPart_001_01C86F93.12FADB11
Content-Type: application/octet-stream;
	name="[patch 5 of 6] ACPI video -  check for error in cooling_device_register"
Content-Transfer-Encoding: base64
Content-Description: [patch 5 of 6] ACPI video -  check for error in cooling_device_register
Content-Disposition: attachment;
	filename="[patch 5 of 6] ACPI video -  check for error in cooling_device_register"

RnJvbTogVGhvbWFzIFN1aml0aCA8c3VqaXRoLnRob21hc0BpbnRlbC5jb20+CgpOZWVkIHRvIGNo
ZWNrIHdoZXRoZXJ0aGVybWFsX2Nvb2xpbmdfZGV2aWNlX3JlZ2lzdGVyCnJldHVybmVkIEVSUk9S
IG9yIG5vdC4KClNpZ25lZC1vZmYtYnk6IFRob21hcyBTdWppdGggPHN1aml0aC50aG9tYXNAaW50
ZWwuY29tPgotLS0KCiBkcml2ZXJzL2FjcGkvdmlkZW8uYyB8ICAgIDMgKysrCiAxIGZpbGVzIGNo
YW5nZWQsIDMgaW5zZXJ0aW9ucygrKQoKSW5kZXg6IGxpbnV4LTIuNi4yNC9kcml2ZXJzL2FjcGkv
dmlkZW8uYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYuMjQub3JpZy9kcml2ZXJzL2FjcGkvdmlk
ZW8uYworKysgbGludXgtMi42LjI0L2RyaXZlcnMvYWNwaS92aWRlby5jCkBAIC03MzEsNiArNzMx
LDkgQEAgc3RhdGljIHZvaWQgYWNwaV92aWRlb19kZXZpY2VfZmluZF9jYXAocwogCiAJCWRldmlj
ZS0+Y2RldiA9IHRoZXJtYWxfY29vbGluZ19kZXZpY2VfcmVnaXN0ZXIoIkxDRCIsCiAJCQkJCWRl
dmljZS0+ZGV2LCAmdmlkZW9fY29vbGluZ19vcHMpOworCQlpZiAoSVNfRVJSKGRldmljZS0+Y2Rl
dikpCisJCQlyZXR1cm47CisKIAkJaWYgKGRldmljZS0+Y2RldikgewogCQkJcHJpbnRrKEtFUk5f
SU5GTyBQUkVGSVgKIAkJCQkiJXMgaXMgcmVnaXN0ZXJlZCBhcyBjb29saW5nX2RldmljZSVkXG4i
LAo=

------_=_NextPart_001_01C86F93.12FADB11--
