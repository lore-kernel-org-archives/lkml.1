Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbYDGSzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbYDGSzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 14:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYDGSzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 14:55:04 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:42972 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbYDGSzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 14:55:01 -0400
Subject: Re: Fix "buggy BIOS check" when CPUs are hot removed
From: Alok Kataria <akataria@vmware.com>
To: len.brown@intel.com
Cc: rui.zhang@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Daniel Arai <arai@vmware.com>,
       Zachary Amsden <zach@vmware.com>
In-Reply-To: <1207352924.6294.29.camel@promb-2n-dhcp158.eng.vmware.com>
References: <1207352924.6294.29.camel@promb-2n-dhcp158.eng.vmware.com>
Content-Type: multipart/mixed; boundary="=-xPZPmts3MBTSqbELzQX5"
Organization: VMware, Inc.
Date: Mon, 07 Apr 2008 11:55:00 -0700
Message-Id: <1207594500.5864.31.camel@promb-2n-dhcp158.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xPZPmts3MBTSqbELzQX5
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch too seems malformed. Resending and also find attached.

Thanks,
Alok

--
Fix "buggy BIOS check" when CPUs are hot added and removed

processor_device_array[pr->id] needs to be set to NULL when removing a
CPU. Else the "buggy BIOS check" in acpi_processor_start mistakenly
fires when a CPU is removed from the system and then later re-added.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Dan Arai <arai@vmware.com>

---
 drivers/acpi/processor_core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/processor_core.c
b/drivers/acpi/processor_core.c
index 61450f4..0f95f26 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -828,6 +828,7 @@ static int acpi_processor_remove(struct acpi_device
*device, int type)
 	}
 
 	processors[pr->id] = NULL;
+	processor_device_array[pr->id] = NULL;
 
 	kfree(pr);
 
-- 
1.5.4




On Fri, 2008-04-04 at 16:48 -0700, Alok Kataria wrote:
> Fixes a BUG in ACPI hotplugging.
> 
> processor_device_array[pr->id] needs to be set to NULL when removing a
> CPU. Else the "buggy BIOS check" in acpi_processor_start mistakenly
> fires when a CPU is removed from the system and then later re-added.
> 
> Signed-off-by: Alok N Kataria <akataria@vmware.com>
> Signed-off-by: Dan Arai <arai@vmware.com>
> 
> ---
> drivers/acpi/processor_core.c |    1 +
> 1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/processor_core.c
> b/drivers/acpi/processor_core.c
> index 61450f4..0f95f26 100644
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@ -828,6 +828,7 @@ static int acpi_processor_remove(struct acpi_device
> *device, int type)
> }
> 
> processors[pr->id] = NULL;
> + processor_device_array[pr->id] = NULL;
> 
> kfree(pr);
> 

--=-xPZPmts3MBTSqbELzQX5
Content-Disposition: attachment; filename=buggy-bios-check-on-cpu-hotplug.patch
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name=buggy-bios-check-on-cpu-hotplug.patch; charset=utf-8

Rml4ICJidWdneSBCSU9TIGNoZWNrIiB3aGVuIENQVXMgYXJlIGhvdCBhZGRlZCBhbmQgcmVtb3Zl
ZA0KDQpwcm9jZXNzb3JfZGV2aWNlX2FycmF5W3ByLT5pZF0gbmVlZHMgdG8gYmUgc2V0IHRvIE5V
TEwgd2hlbiByZW1vdmluZyBhDQpDUFUuIEVsc2UgdGhlICJidWdneSBCSU9TIGNoZWNrIiBpbiBh
Y3BpX3Byb2Nlc3Nvcl9zdGFydCBtaXN0YWtlbmx5DQpmaXJlcyB3aGVuIGEgQ1BVIGlzIHJlbW92
ZWQgZnJvbSB0aGUgc3lzdGVtIGFuZCB0aGVuIGxhdGVyIHJlLWFkZGVkLg0KDQpTaWduZWQtb2Zm
LWJ5OiBBbG9rIE4gS2F0YXJpYSA8YWthdGFyaWFAdm13YXJlLmNvbT4NClNpZ25lZC1vZmYtYnk6
IERhbiBBcmFpIDxhcmFpQHZtd2FyZS5jb20+DQoNCi0tLQ0KIGRyaXZlcnMvYWNwaS9wcm9jZXNz
b3JfY29yZS5jIHwgICAgMSArDQogMSBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbnMoKyksIDAg
ZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2FjcGkvcHJvY2Vzc29yX2NvcmUu
YyBiL2RyaXZlcnMvYWNwaS9wcm9jZXNzb3JfY29yZS5jDQppbmRleCA2MTQ1MGY0Li4wZjk1ZjI2
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9hY3BpL3Byb2Nlc3Nvcl9jb3JlLmMNCisrKyBiL2RyaXZl
cnMvYWNwaS9wcm9jZXNzb3JfY29yZS5jDQpAQCAtODI4LDYgKzgyOCw3IEBAIHN0YXRpYyBpbnQg
YWNwaV9wcm9jZXNzb3JfcmVtb3ZlKHN0cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlLCBpbnQgdHlw
ZSkNCiAJfQ0KIA0KIAlwcm9jZXNzb3JzW3ByLT5pZF0gPSBOVUxMOw0KKwlwcm9jZXNzb3JfZGV2
aWNlX2FycmF5W3ByLT5pZF0gPSBOVUxMOw0KIA0KIAlrZnJlZShwcik7DQogDQotLSANCjEuNS40
DQoNCg==


--=-xPZPmts3MBTSqbELzQX5--
