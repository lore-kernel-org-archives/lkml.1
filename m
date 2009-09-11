Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbZIKGDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbZIKGDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 02:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbZIKGDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 02:03:23 -0400
Received: from mail-pz0-f184.google.com ([209.85.222.184]:59497 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbZIKGDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 02:03:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=wTzq5vPY0xtqKToGf/sr5+eXHZDhOXznZpKniH0eYgxaPwSXS83I/JwdulXi0L7PXb
         jyqh3V+I+0o7RRsK75IjPaLY0vqXieh2fFOO7QwV2sSIUrpTUbExBENIzyvBa2Ya9Os6
         iS95kvC8AP3UGWgpDtd2sQC43AROVpVvvLYGc=
MIME-Version: 1.0
Date: Fri, 11 Sep 2009 14:03:26 +0800
Message-ID: <3877989d0909102303m31066b01he38e8a295995c430@mail.gmail.com>
Subject: [trivial PATCH] fix typo in nmi.c of apic
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000e0cd72db60fc20d0473471346
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd72db60fc20d0473471346
Content-Type: text/plain; charset=UTF-8

Hi there,

I came across x86/kernel/apic/nmi.c and found several typo.
It's trivial in terms of doing nothing on changing execution logic.

Please review. If make sense, please apply.

Ps. The patch is enclosed in attachment. The inline one
is c&p of it for reading.


Thanks,
Luming

Signed-off-by: Yu Luming <luming.yu@intel.com>

 nmi.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index b3025b4..9ff1f6d 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -121,7 +121,7 @@ static void report_broken_nmi(int cpu, unsigned
int *prev_nmi_count)
 	atomic_dec(&nmi_active);
 }

-static void __acpi_nmi_disable(void *__unused)
+static void __apic_nmi_disable(void *__unused)
 {
 	apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
 }
@@ -178,7 +178,7 @@ error:
 	if (nmi_watchdog == NMI_IO_APIC) {
 		if (!timer_through_8259)
 			disable_8259A_irq(0);
-		on_each_cpu(__acpi_nmi_disable, NULL, 1);
+		on_each_cpu(__apic_nmi_disable, NULL, 1);
 	}

 #ifdef CONFIG_X86_32
@@ -276,7 +276,7 @@ late_initcall(init_lapic_nmi_sysfs);

 #endif	/* CONFIG_PM */

-static void __acpi_nmi_enable(void *__unused)
+static void __apic_nmi_enable(void *__unused)
 {
 	apic_write(APIC_LVT0, APIC_DM_NMI);
 }
@@ -284,19 +284,19 @@ static void __acpi_nmi_enable(void *__unused)
 /*
  * Enable timer based NMIs on all CPUs:
  */
-void acpi_nmi_enable(void)
+void apic_nmi_enable(void)
 {
 	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_enable, NULL, 1);
+		on_each_cpu(__apic_nmi_enable, NULL, 1);
 }

 /*
  * Disable timer based NMIs on all CPUs:
  */
-void acpi_nmi_disable(void)
+void apic_nmi_disable(void)
 {
 	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_disable, NULL, 1);
+		on_each_cpu(__apic_nmi_disable, NULL, 1);
 }

 /*
@@ -341,7 +341,7 @@ void stop_apic_nmi_watchdog(void *unused)
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		lapic_watchdog_stop();
 	else
-		__acpi_nmi_disable(NULL);
+		__apic_nmi_disable(NULL);
 	__get_cpu_var(wd_enabled) = 0;
 	atomic_dec(&nmi_active);
 }
@@ -472,7 +472,7 @@ static void enable_ioapic_nmi_watchdog_single(void *unused)
 {
 	__get_cpu_var(wd_enabled) = 1;
 	atomic_inc(&nmi_active);
-	__acpi_nmi_enable(NULL);
+	__apic_nmi_enable(NULL);
 }

 static void enable_ioapic_nmi_watchdog(void)

--000e0cd72db60fc20d0473471346
Content-Type: application/octet-stream; name="9.patch"
Content-Disposition: attachment; filename="9.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fzgj3jpz0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9hcGljL25taS5jIGIvYXJjaC94ODYva2VybmVs
L2FwaWMvbm1pLmMKaW5kZXggYjMwMjViNC4uOWZmMWY2ZCAxMDA2NDQKLS0tIGEvYXJjaC94ODYv
a2VybmVsL2FwaWMvbm1pLmMKKysrIGIvYXJjaC94ODYva2VybmVsL2FwaWMvbm1pLmMKQEAgLTEy
MSw3ICsxMjEsNyBAQCBzdGF0aWMgdm9pZCByZXBvcnRfYnJva2VuX25taShpbnQgY3B1LCB1bnNp
Z25lZCBpbnQgKnByZXZfbm1pX2NvdW50KQogCWF0b21pY19kZWMoJm5taV9hY3RpdmUpOwogfQog
Ci1zdGF0aWMgdm9pZCBfX2FjcGlfbm1pX2Rpc2FibGUodm9pZCAqX191bnVzZWQpCitzdGF0aWMg
dm9pZCBfX2FwaWNfbm1pX2Rpc2FibGUodm9pZCAqX191bnVzZWQpCiB7CiAJYXBpY193cml0ZShB
UElDX0xWVDAsIEFQSUNfRE1fTk1JIHwgQVBJQ19MVlRfTUFTS0VEKTsKIH0KQEAgLTE3OCw3ICsx
NzgsNyBAQCBlcnJvcjoKIAlpZiAobm1pX3dhdGNoZG9nID09IE5NSV9JT19BUElDKSB7CiAJCWlm
ICghdGltZXJfdGhyb3VnaF84MjU5KQogCQkJZGlzYWJsZV84MjU5QV9pcnEoMCk7Ci0JCW9uX2Vh
Y2hfY3B1KF9fYWNwaV9ubWlfZGlzYWJsZSwgTlVMTCwgMSk7CisJCW9uX2VhY2hfY3B1KF9fYXBp
Y19ubWlfZGlzYWJsZSwgTlVMTCwgMSk7CiAJfQogCiAjaWZkZWYgQ09ORklHX1g4Nl8zMgpAQCAt
Mjc2LDcgKzI3Niw3IEBAIGxhdGVfaW5pdGNhbGwoaW5pdF9sYXBpY19ubWlfc3lzZnMpOwogCiAj
ZW5kaWYJLyogQ09ORklHX1BNICovCiAKLXN0YXRpYyB2b2lkIF9fYWNwaV9ubWlfZW5hYmxlKHZv
aWQgKl9fdW51c2VkKQorc3RhdGljIHZvaWQgX19hcGljX25taV9lbmFibGUodm9pZCAqX191bnVz
ZWQpCiB7CiAJYXBpY193cml0ZShBUElDX0xWVDAsIEFQSUNfRE1fTk1JKTsKIH0KQEAgLTI4NCwx
OSArMjg0LDE5IEBAIHN0YXRpYyB2b2lkIF9fYWNwaV9ubWlfZW5hYmxlKHZvaWQgKl9fdW51c2Vk
KQogLyoKICAqIEVuYWJsZSB0aW1lciBiYXNlZCBOTUlzIG9uIGFsbCBDUFVzOgogICovCi12b2lk
IGFjcGlfbm1pX2VuYWJsZSh2b2lkKQordm9pZCBhcGljX25taV9lbmFibGUodm9pZCkKIHsKIAlp
ZiAoYXRvbWljX3JlYWQoJm5taV9hY3RpdmUpICYmIG5taV93YXRjaGRvZyA9PSBOTUlfSU9fQVBJ
QykKLQkJb25fZWFjaF9jcHUoX19hY3BpX25taV9lbmFibGUsIE5VTEwsIDEpOworCQlvbl9lYWNo
X2NwdShfX2FwaWNfbm1pX2VuYWJsZSwgTlVMTCwgMSk7CiB9CiAKIC8qCiAgKiBEaXNhYmxlIHRp
bWVyIGJhc2VkIE5NSXMgb24gYWxsIENQVXM6CiAgKi8KLXZvaWQgYWNwaV9ubWlfZGlzYWJsZSh2
b2lkKQordm9pZCBhcGljX25taV9kaXNhYmxlKHZvaWQpCiB7CiAJaWYgKGF0b21pY19yZWFkKCZu
bWlfYWN0aXZlKSAmJiBubWlfd2F0Y2hkb2cgPT0gTk1JX0lPX0FQSUMpCi0JCW9uX2VhY2hfY3B1
KF9fYWNwaV9ubWlfZGlzYWJsZSwgTlVMTCwgMSk7CisJCW9uX2VhY2hfY3B1KF9fYXBpY19ubWlf
ZGlzYWJsZSwgTlVMTCwgMSk7CiB9CiAKIC8qCkBAIC0zNDEsNyArMzQxLDcgQEAgdm9pZCBzdG9w
X2FwaWNfbm1pX3dhdGNoZG9nKHZvaWQgKnVudXNlZCkKIAlpZiAobm1pX3dhdGNoZG9nID09IE5N
SV9MT0NBTF9BUElDKQogCQlsYXBpY193YXRjaGRvZ19zdG9wKCk7CiAJZWxzZQotCQlfX2FjcGlf
bm1pX2Rpc2FibGUoTlVMTCk7CisJCV9fYXBpY19ubWlfZGlzYWJsZShOVUxMKTsKIAlfX2dldF9j
cHVfdmFyKHdkX2VuYWJsZWQpID0gMDsKIAlhdG9taWNfZGVjKCZubWlfYWN0aXZlKTsKIH0KQEAg
LTQ3Miw3ICs0NzIsNyBAQCBzdGF0aWMgdm9pZCBlbmFibGVfaW9hcGljX25taV93YXRjaGRvZ19z
aW5nbGUodm9pZCAqdW51c2VkKQogewogCV9fZ2V0X2NwdV92YXIod2RfZW5hYmxlZCkgPSAxOwog
CWF0b21pY19pbmMoJm5taV9hY3RpdmUpOwotCV9fYWNwaV9ubWlfZW5hYmxlKE5VTEwpOworCV9f
YXBpY19ubWlfZW5hYmxlKE5VTEwpOwogfQogCiBzdGF0aWMgdm9pZCBlbmFibGVfaW9hcGljX25t
aV93YXRjaGRvZyh2b2lkKQo=
--000e0cd72db60fc20d0473471346--
