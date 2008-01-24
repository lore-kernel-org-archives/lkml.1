Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYAXLPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYAXLPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 06:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYAXLPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 06:15:12 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:36433 "EHLO
	outbound10-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606AbYAXLPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 06:15:10 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: [patch] PCI: modify SB700 SATA MSI quirk
Date: Thu, 24 Jan 2008 19:12:49 +0800
Message-ID: <B90463BC30D2E446BA423D888DC85E501BF796@sshaexmb1.amd.com>
In-Reply-To: <B90463BC30D2E446BA423D888DC85E501BF78E@sshaexmb1.amd.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] PCI: modify SB700 SATA MSI quirk
Thread-Index: AcgRZ03q+e8QbKDsTOCx0eCcyylAZBNDi9UAAACvOKA=
References: <5CAB7B5D6F8AB84AA868A46B47A507055D8C1D@sshaexmb1.amd.com>
 <B90463BC30D2E446BA423D888DC85E501BF78E@sshaexmb1.amd.com>
From: "Shane Huang" <Shane.Huang@amd.com>
To: gregkh@suse.de
cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       htejun@gmail.com, "Shane Huang" <Shane.Huang@amd.com>
X-OriginalArrivalTime: 24 Jan 2008 11:12:54.0197 (UTC)
 FILETIME=[10DC8E50:01C85E7A]
X-WSS-ID: 6B86AD6C2IW8645069-01-01
Content-Type: multipart/mixed;
 boundary="----_=_NextPart_001_01C85E7A.0DDB0E3B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C85E7A.0DDB0E3B
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: quoted-printable

SB700 SATA MSI bug will be fixed in SB700 revision A21 at hardware
level,
but the SB700 revision older than A21 will also be found in the market.
This patch modify the original quirk commit
bc38b411fe696fad32b261f492cb4afbf1835256 instead of withdrawing it.


Signed-off-by: Shane Huang <shane.huang@amd.com>


Since there is some word wrapping problem with my mail client MS
outlook, I also attach the patch as an attachment. Please check it.



diff -ruN old/drivers/pci/quirks.c new/drivers/pci/quirks.c
--- old/drivers/pci/quirks.c	2008-01-07 05:45:38.000000000 +0800
+++ new/drivers/pci/quirks.c	2008-01-22 11:31:09.000000000 +0800
@@ -1709,6 +1709,22 @@
 {
 	dev->dev_flags |=3D PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
 }
+static void __devinit quirk_msi_intx_disable_ati_bug(struct pci_dev
*dev)
+{
+	struct pci_dev *p;
+	u8 rev =3D 0;
+
+	/* SB700 MSI issue will be fixed at HW level from revision A21,
+	 * we need check PCI REVISION ID of SMBus controller to get
SB700 revision.
+	 */
+	p =3D pci_get_device(PCI_VENDOR_ID_ATI,
PCI_DEVICE_ID_ATI_SBX00_SMBUS, NULL);
+	if (p!=3DNULL) {
+		pci_read_config_byte(p, PCI_CLASS_REVISION, &rev);
+	}
+	if ((rev < 0x3B) && (rev >=3D 0x30)) {
+		dev->dev_flags |=3D PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
+	}
+}
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
 			PCI_DEVICE_ID_TIGON3_5780,
 			quirk_msi_intx_disable_bug);
@@ -1729,17 +1745,17 @@
 			quirk_msi_intx_disable_bug);
=20
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4390,
-			quirk_msi_intx_disable_bug);
+			quirk_msi_intx_disable_ati_bug);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4391,
-			quirk_msi_intx_disable_bug);
+			quirk_msi_intx_disable_ati_bug);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4392,
-			quirk_msi_intx_disable_bug);
+			quirk_msi_intx_disable_ati_bug);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4393,
-			quirk_msi_intx_disable_bug);
+			quirk_msi_intx_disable_ati_bug);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4394,
-			quirk_msi_intx_disable_bug);
+			quirk_msi_intx_disable_ati_bug);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4395,
-			quirk_msi_intx_disable_bug);
+			quirk_msi_intx_disable_ati_bug);
=20
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4373,
 			quirk_msi_intx_disable_bug);


Thanks
Best Regards
Shane


------_=_NextPart_001_01C85E7A.0DDB0E3B
Content-Type: application/octet-stream;
 name=modify_SB700_MSI_issue.patch
Content-Transfer-Encoding: base64
Content-Description: modify_SB700_MSI_issue.patch
Content-Disposition: attachment;
 filename=modify_SB700_MSI_issue.patch

ZGlmZiAtcnVOIG9sZC9kcml2ZXJzL3BjaS9xdWlya3MuYyBuZXcvZHJpdmVycy9wY2kvcXVpcmtz
LmMKLS0tIG9sZC9kcml2ZXJzL3BjaS9xdWlya3MuYwkyMDA4LTAxLTA3IDA1OjQ1OjM4LjAwMDAw
MDAwMCArMDgwMAorKysgbmV3L2RyaXZlcnMvcGNpL3F1aXJrcy5jCTIwMDgtMDEtMjIgMTE6MzE6
MDkuMDAwMDAwMDAwICswODAwCkBAIC0xNzA5LDYgKzE3MDksMjIgQEAKIHsKIAlkZXYtPmRldl9m
bGFncyB8PSBQQ0lfREVWX0ZMQUdTX01TSV9JTlRYX0RJU0FCTEVfQlVHOwogfQorc3RhdGljIHZv
aWQgX19kZXZpbml0IHF1aXJrX21zaV9pbnR4X2Rpc2FibGVfYXRpX2J1ZyhzdHJ1Y3QgcGNpX2Rl
diAqZGV2KQoreworCXN0cnVjdCBwY2lfZGV2ICpwOworCXU4IHJldiA9IDA7CisKKwkvKiBTQjcw
MCBNU0kgaXNzdWUgd2lsbCBiZSBmaXhlZCBhdCBIVyBsZXZlbCBmcm9tIHJldmlzaW9uIEEyMSwK
KwkgKiB3ZSBuZWVkIGNoZWNrIFBDSSBSRVZJU0lPTiBJRCBvZiBTTUJ1cyBjb250cm9sbGVyIHRv
IGdldCBTQjcwMCByZXZpc2lvbi4KKwkgKi8KKwlwID0gcGNpX2dldF9kZXZpY2UoUENJX1ZFTkRP
Ul9JRF9BVEksIFBDSV9ERVZJQ0VfSURfQVRJX1NCWDAwX1NNQlVTLCBOVUxMKTsKKwlpZiAocCE9
TlVMTCkgeworCQlwY2lfcmVhZF9jb25maWdfYnl0ZShwLCBQQ0lfQ0xBU1NfUkVWSVNJT04sICZy
ZXYpOworCX0KKwlpZiAoKHJldiA8IDB4M0IpICYmIChyZXYgPj0gMHgzMCkpIHsKKwkJZGV2LT5k
ZXZfZmxhZ3MgfD0gUENJX0RFVl9GTEFHU19NU0lfSU5UWF9ESVNBQkxFX0JVRzsKKwl9Cit9CiBE
RUNMQVJFX1BDSV9GSVhVUF9GSU5BTChQQ0lfVkVORE9SX0lEX0JST0FEQ09NLAogCQkJUENJX0RF
VklDRV9JRF9USUdPTjNfNTc4MCwKIAkJCXF1aXJrX21zaV9pbnR4X2Rpc2FibGVfYnVnKTsKQEAg
LTE3MjksMTcgKzE3NDUsMTcgQEAKIAkJCXF1aXJrX21zaV9pbnR4X2Rpc2FibGVfYnVnKTsKIAog
REVDTEFSRV9QQ0lfRklYVVBfRklOQUwoUENJX1ZFTkRPUl9JRF9BVEksIDB4NDM5MCwKLQkJCXF1
aXJrX21zaV9pbnR4X2Rpc2FibGVfYnVnKTsKKwkJCXF1aXJrX21zaV9pbnR4X2Rpc2FibGVfYXRp
X2J1Zyk7CiBERUNMQVJFX1BDSV9GSVhVUF9GSU5BTChQQ0lfVkVORE9SX0lEX0FUSSwgMHg0Mzkx
LAotCQkJcXVpcmtfbXNpX2ludHhfZGlzYWJsZV9idWcpOworCQkJcXVpcmtfbXNpX2ludHhfZGlz
YWJsZV9hdGlfYnVnKTsKIERFQ0xBUkVfUENJX0ZJWFVQX0ZJTkFMKFBDSV9WRU5ET1JfSURfQVRJ
LCAweDQzOTIsCi0JCQlxdWlya19tc2lfaW50eF9kaXNhYmxlX2J1Zyk7CisJCQlxdWlya19tc2lf
aW50eF9kaXNhYmxlX2F0aV9idWcpOwogREVDTEFSRV9QQ0lfRklYVVBfRklOQUwoUENJX1ZFTkRP
Ul9JRF9BVEksIDB4NDM5MywKLQkJCXF1aXJrX21zaV9pbnR4X2Rpc2FibGVfYnVnKTsKKwkJCXF1
aXJrX21zaV9pbnR4X2Rpc2FibGVfYXRpX2J1Zyk7CiBERUNMQVJFX1BDSV9GSVhVUF9GSU5BTChQ
Q0lfVkVORE9SX0lEX0FUSSwgMHg0Mzk0LAotCQkJcXVpcmtfbXNpX2ludHhfZGlzYWJsZV9idWcp
OworCQkJcXVpcmtfbXNpX2ludHhfZGlzYWJsZV9hdGlfYnVnKTsKIERFQ0xBUkVfUENJX0ZJWFVQ
X0ZJTkFMKFBDSV9WRU5ET1JfSURfQVRJLCAweDQzOTUsCi0JCQlxdWlya19tc2lfaW50eF9kaXNh
YmxlX2J1Zyk7CisJCQlxdWlya19tc2lfaW50eF9kaXNhYmxlX2F0aV9idWcpOwogCiBERUNMQVJF
X1BDSV9GSVhVUF9GSU5BTChQQ0lfVkVORE9SX0lEX0FUSSwgMHg0MzczLAogCQkJcXVpcmtfbXNp
X2ludHhfZGlzYWJsZV9idWcpOwo=

------_=_NextPart_001_01C85E7A.0DDB0E3B--


