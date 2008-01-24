Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYAXLBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYAXLBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 06:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbYAXLB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 06:01:28 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:42555 "EHLO
	outbound3-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754083AbYAXLB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 06:01:27 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: [patch] PCI: disable the MSI of AMD RS690
Date: Thu, 24 Jan 2008 18:59:04 +0800
Message-ID: <B90463BC30D2E446BA423D888DC85E501BF78E@sshaexmb1.amd.com>
In-Reply-To: <5CAB7B5D6F8AB84AA868A46B47A507055D8C1D@sshaexmb1.amd.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] PCI: disable the MSI of AMD RS690
Thread-Index: AcgRZ03q+e8QbKDsTOCx0eCcyylAZBNDi9UA
References: <5CAB7B5D6F8AB84AA868A46B47A507055D8C1D@sshaexmb1.amd.com>
From: "Shane Huang" <Shane.Huang@amd.com>
To: gregkh@suse.de
cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       htejun@gmail.com, "Shane Huang" <Shane.Huang@amd.com>
X-OriginalArrivalTime: 24 Jan 2008 10:59:07.0525 (UTC)
 FILETIME=[24206B50:01C85E78]
X-WSS-ID: 6B86B0F72IW8644485-01-01
Content-Type: multipart/mixed;
 boundary="----_=_NextPart_001_01C85E78.21D0FAE3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C85E78.21D0FAE3
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: quoted-printable

This patch recover Tejun's commit
4be8f906435a6af241821ab5b94b2b12cb7d57d8
 because there is one MSI bug on RS690+SB600 board which will lead to
boot failure. This bug is NOT same as the one in SB700 SATA controller,
quirk_msi_intx_disable_bug does not work to SB600. Disablement the MSI
of RS690 is the workaround.

Signed-off-by: Shane Huang <shane.huang@amd.com>


Since there is some word wrapping problem with my mail client MS outlook
if I copy the patch into the text, so I'll also attach the patch as an
attachment. Please check it.


diff -ruN old/drivers/pci/quirks.c new/drivers/pci/quirks.c
--- old/drivers/pci/quirks.c	2008-01-07 05:45:38.000000000 +0800
+++ new/drivers/pci/quirks.c	2008-01-22 11:02:00.000000000 +0800
@@ -1623,6 +1623,7 @@
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS,
PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200,
quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480,
quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS690,
quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3351,
quirk_disable_all_msi);
=20
 /* Disable MSI on chipsets that are known to not support it */
diff -ruN old/include/linux/pci_ids.h new/include/linux/pci_ids.h
--- old/include/linux/pci_ids.h	2008-01-07 05:45:38.000000000 +0800
+++ new/include/linux/pci_ids.h	2008-01-22 11:01:55.000000000 +0800
@@ -360,6 +360,7 @@
 #define PCI_DEVICE_ID_ATI_RS400_166     0x5a32
 #define PCI_DEVICE_ID_ATI_RS400_200     0x5a33
 #define PCI_DEVICE_ID_ATI_RS480         0x5950
+#define PCI_DEVICE_ID_ATI_RS690         0x7910
 /* ATI IXP Chipset */
 #define PCI_DEVICE_ID_ATI_IXP200_IDE	0x4349
 #define PCI_DEVICE_ID_ATI_IXP200_SMBUS	0x4353



Thanks
Best Regards
Shane


------_=_NextPart_001_01C85E78.21D0FAE3
Content-Type: application/octet-stream;
 name=disable_RS690_MSI.patch
Content-Transfer-Encoding: base64
Content-Description: disable_RS690_MSI.patch
Content-Disposition: attachment;
 filename=disable_RS690_MSI.patch

ZGlmZiAtcnVOIG9sZC9kcml2ZXJzL3BjaS9xdWlya3MuYyBuZXcvZHJpdmVycy9wY2kvcXVpcmtz
LmMKLS0tIG9sZC9kcml2ZXJzL3BjaS9xdWlya3MuYwkyMDA4LTAxLTA3IDA1OjQ1OjM4LjAwMDAw
MDAwMCArMDgwMAorKysgbmV3L2RyaXZlcnMvcGNpL3F1aXJrcy5jCTIwMDgtMDEtMjIgMTE6MDI6
MDAuMDAwMDAwMDAwICswODAwCkBAIC0xNjIzLDYgKzE2MjMsNyBAQAogREVDTEFSRV9QQ0lfRklY
VVBfRklOQUwoUENJX1ZFTkRPUl9JRF9TRVJWRVJXT1JLUywgUENJX0RFVklDRV9JRF9TRVJWRVJX
T1JLU19HQ05CX0xFLCBxdWlya19kaXNhYmxlX2FsbF9tc2kpOwogREVDTEFSRV9QQ0lfRklYVVBf
RklOQUwoUENJX1ZFTkRPUl9JRF9BVEksIFBDSV9ERVZJQ0VfSURfQVRJX1JTNDAwXzIwMCwgcXVp
cmtfZGlzYWJsZV9hbGxfbXNpKTsKIERFQ0xBUkVfUENJX0ZJWFVQX0ZJTkFMKFBDSV9WRU5ET1Jf
SURfQVRJLCBQQ0lfREVWSUNFX0lEX0FUSV9SUzQ4MCwgcXVpcmtfZGlzYWJsZV9hbGxfbXNpKTsK
K0RFQ0xBUkVfUENJX0ZJWFVQX0ZJTkFMKFBDSV9WRU5ET1JfSURfQVRJLCBQQ0lfREVWSUNFX0lE
X0FUSV9SUzY5MCwgcXVpcmtfZGlzYWJsZV9hbGxfbXNpKTsKIERFQ0xBUkVfUENJX0ZJWFVQX0ZJ
TkFMKFBDSV9WRU5ET1JfSURfVklBLCBQQ0lfREVWSUNFX0lEX1ZJQV9WVDMzNTEsIHF1aXJrX2Rp
c2FibGVfYWxsX21zaSk7CiAKIC8qIERpc2FibGUgTVNJIG9uIGNoaXBzZXRzIHRoYXQgYXJlIGtu
b3duIHRvIG5vdCBzdXBwb3J0IGl0ICovCmRpZmYgLXJ1TiBvbGQvaW5jbHVkZS9saW51eC9wY2lf
aWRzLmggbmV3L2luY2x1ZGUvbGludXgvcGNpX2lkcy5oCi0tLSBvbGQvaW5jbHVkZS9saW51eC9w
Y2lfaWRzLmgJMjAwOC0wMS0wNyAwNTo0NTozOC4wMDAwMDAwMDAgKzA4MDAKKysrIG5ldy9pbmNs
dWRlL2xpbnV4L3BjaV9pZHMuaAkyMDA4LTAxLTIyIDExOjAxOjU1LjAwMDAwMDAwMCArMDgwMApA
QCAtMzYwLDYgKzM2MCw3IEBACiAjZGVmaW5lIFBDSV9ERVZJQ0VfSURfQVRJX1JTNDAwXzE2NiAg
ICAgMHg1YTMyCiAjZGVmaW5lIFBDSV9ERVZJQ0VfSURfQVRJX1JTNDAwXzIwMCAgICAgMHg1YTMz
CiAjZGVmaW5lIFBDSV9ERVZJQ0VfSURfQVRJX1JTNDgwICAgICAgICAgMHg1OTUwCisjZGVmaW5l
IFBDSV9ERVZJQ0VfSURfQVRJX1JTNjkwICAgICAgICAgMHg3OTEwCiAvKiBBVEkgSVhQIENoaXBz
ZXQgKi8KICNkZWZpbmUgUENJX0RFVklDRV9JRF9BVElfSVhQMjAwX0lERQkweDQzNDkKICNkZWZp
bmUgUENJX0RFVklDRV9JRF9BVElfSVhQMjAwX1NNQlVTCTB4NDM1Mwo=

------_=_NextPart_001_01C85E78.21D0FAE3--


