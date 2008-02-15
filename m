Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbYBOFZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbYBOFZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 00:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYBOFY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 00:24:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:21126 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbYBOFYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 00:24:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,356,1199692800"; 
   d="scan'208";a="379339917"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C86F92.EB7E1A21"
Subject: [patch 3/6] ACPI fan: extract return values using PTR_ERR
Date: Fri, 15 Feb 2008 10:53:38 +0530
Message-ID: <05B550FD4BD2014E841D83547B62600802AA6503@bgsmsx411.gar.corp.intel.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 3/6] ACPI fan: extract return values using PTR_ERR
Thread-Index: Achvkus8+3m0UfwgS3S/Esp7niEj+Q==
From: "Thomas, Sujith" <sujith.thomas@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <lenb@kernel.org>, <mingo@elte.hu>, <linux-acpi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
       "Zhang, Rui" <rui.zhang@intel.com>
X-OriginalArrivalTime: 15 Feb 2008 05:23:41.0480 (UTC) FILETIME=[ED282A80:01C86F92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C86F92.EB7E1A21
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

From: Thomas Sujith <sujith.thomas@intel.com>

Need to extract errors using PTR_ERR macro and
process accordingly.thermal_cooling_device_register
returning NULL means that CONFIG_THERMAL=3Dn and in that
case no need to create symbolic links.

Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
---

 drivers/acpi/fan.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

Index: linux-2.6.24/drivers/acpi/fan.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.24.orig/drivers/acpi/fan.c
+++ linux-2.6.24/drivers/acpi/fan.c
@@ -256,22 +256,28 @@ static int acpi_fan_add(struct acpi_devi
=20
 	cdev =3D thermal_cooling_device_register("Fan", device,
 						&fan_cooling_ops);
-	if (cdev)
+	if (IS_ERR(cdev)) {
+		result =3D PTR_ERR(cdev);
+		goto end;
+	}
+	if (cdev) {
 		printk(KERN_INFO PREFIX
 			"%s is registered as cooling_device%d\n",
 			device->dev.bus_id, cdev->id);
-	else
-		goto end;
-	acpi_driver_data(device) =3D cdev;
-	result =3D sysfs_create_link(&device->dev.kobj,
&cdev->device.kobj,
-					"thermal_cooling");
-	if (result)
-		return result;
=20
-	result =3D sysfs_create_link(&cdev->device.kobj,
&device->dev.kobj,
-                                       "device");
-        if (result)
-                return result;
+		acpi_driver_data(device) =3D cdev;
+		result =3D sysfs_create_link(&device->dev.kobj,
+					   &cdev->device.kobj,
+					   "thermal_cooling");
+		if (result)
+			return result;
+
+		result =3D sysfs_create_link(&cdev->device.kobj,
+					   &device->dev.kobj,
+					   "device");
+		if (result)
+			return result;
+	}
=20
 	result =3D acpi_fan_add_fs(device);
 	if (result)

------_=_NextPart_001_01C86F92.EB7E1A21
Content-Type: application/octet-stream;
	name="[patch 3 of 6] ACPI fan - extract return value using PTR_ERR"
Content-Transfer-Encoding: base64
Content-Description: [patch 3 of 6] ACPI fan - extract return value using PTR_ERR
Content-Disposition: attachment;
	filename="[patch 3 of 6] ACPI fan - extract return value using PTR_ERR"

RnJvbTogVGhvbWFzIFN1aml0aCA8c3VqaXRoLnRob21hc0BpbnRlbC5jb20+CgpOZWVkIHRvIGV4
dHJhY3QgZXJyb3JzIHVzaW5nIFBUUl9FUlIgbWFjcm8gYW5kCnByb2Nlc3MgYWNjb3JkaW5nbHku
dGhlcm1hbF9jb29saW5nX2RldmljZV9yZWdpc3RlcgpyZXR1cm5pbmcgTlVMTCBtZWFucyB0aGF0
IENPTkZJR19USEVSTUFMPW4gYW5kIGluIHRoYXQKY2FzZSBubyBuZWVkIHRvIGNyZWF0ZSBzeW1i
b2xpYyBsaW5rcy4KClNpZ25lZC1vZmYtYnk6IFRob21hcyBTdWppdGggPHN1aml0aC50aG9tYXNA
aW50ZWwuY29tPgotLS0KCiBkcml2ZXJzL2FjcGkvZmFuLmMgfCAgIDMwICsrKysrKysrKysrKysr
KysrKy0tLS0tLS0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCAxMiBk
ZWxldGlvbnMoLSkKCkluZGV4OiBsaW51eC0yLjYuMjQvZHJpdmVycy9hY3BpL2Zhbi5jCj09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT0KLS0tIGxpbnV4LTIuNi4yNC5vcmlnL2RyaXZlcnMvYWNwaS9mYW4uYworKysgbGludXgt
Mi42LjI0L2RyaXZlcnMvYWNwaS9mYW4uYwpAQCAtMjU2LDIyICsyNTYsMjggQEAgc3RhdGljIGlu
dCBhY3BpX2Zhbl9hZGQoc3RydWN0IGFjcGlfZGV2aQogCiAJY2RldiA9IHRoZXJtYWxfY29vbGlu
Z19kZXZpY2VfcmVnaXN0ZXIoIkZhbiIsIGRldmljZSwKIAkJCQkJCSZmYW5fY29vbGluZ19vcHMp
OwotCWlmIChjZGV2KQorCWlmIChJU19FUlIoY2RldikpIHsKKwkJcmVzdWx0ID0gUFRSX0VSUihj
ZGV2KTsKKwkJZ290byBlbmQ7CisJfQorCWlmIChjZGV2KSB7CiAJCXByaW50ayhLRVJOX0lORk8g
UFJFRklYCiAJCQkiJXMgaXMgcmVnaXN0ZXJlZCBhcyBjb29saW5nX2RldmljZSVkXG4iLAogCQkJ
ZGV2aWNlLT5kZXYuYnVzX2lkLCBjZGV2LT5pZCk7Ci0JZWxzZQotCQlnb3RvIGVuZDsKLQlhY3Bp
X2RyaXZlcl9kYXRhKGRldmljZSkgPSBjZGV2OwotCXJlc3VsdCA9IHN5c2ZzX2NyZWF0ZV9saW5r
KCZkZXZpY2UtPmRldi5rb2JqLCAmY2Rldi0+ZGV2aWNlLmtvYmosCi0JCQkJCSJ0aGVybWFsX2Nv
b2xpbmciKTsKLQlpZiAocmVzdWx0KQotCQlyZXR1cm4gcmVzdWx0OwogCi0JcmVzdWx0ID0gc3lz
ZnNfY3JlYXRlX2xpbmsoJmNkZXYtPmRldmljZS5rb2JqLCAmZGV2aWNlLT5kZXYua29iaiwKLSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJkZXZpY2UiKTsKLSAgICAgICAg
aWYgKHJlc3VsdCkKLSAgICAgICAgICAgICAgICByZXR1cm4gcmVzdWx0OworCQlhY3BpX2RyaXZl
cl9kYXRhKGRldmljZSkgPSBjZGV2OworCQlyZXN1bHQgPSBzeXNmc19jcmVhdGVfbGluaygmZGV2
aWNlLT5kZXYua29iaiwKKwkJCQkJICAgJmNkZXYtPmRldmljZS5rb2JqLAorCQkJCQkgICAidGhl
cm1hbF9jb29saW5nIik7CisJCWlmIChyZXN1bHQpCisJCQlyZXR1cm4gcmVzdWx0OworCisJCXJl
c3VsdCA9IHN5c2ZzX2NyZWF0ZV9saW5rKCZjZGV2LT5kZXZpY2Uua29iaiwKKwkJCQkJICAgJmRl
dmljZS0+ZGV2LmtvYmosCisJCQkJCSAgICJkZXZpY2UiKTsKKwkJaWYgKHJlc3VsdCkKKwkJCXJl
dHVybiByZXN1bHQ7CisJfQogCiAJcmVzdWx0ID0gYWNwaV9mYW5fYWRkX2ZzKGRldmljZSk7CiAJ
aWYgKHJlc3VsdCkK

------_=_NextPart_001_01C86F92.EB7E1A21--
