Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbZDVUDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbZDVUDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbZDVUDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:03:12 -0400
Received: from exprod6ob113.obsmtp.com ([64.18.1.30]:58080 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752420AbZDVUDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:03:11 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C9C385.5A5A92C3"
Subject: RE: [PATCH]  usb/core/hub.c: fix sparse warnings
Date: Wed, 22 Apr 2009 16:03:05 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090165F056@mi8nycmail19.Mi8.com>
In-Reply-To: <20090422055118.GE9009@kroah.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH]  usb/core/hub.c: fix sparse warnings
Thread-Index: AcnDENEXZEazks3mQCyIKgKQBxZi8QAc/jFQ
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8DF9@mi8nycmail19.Mi8.com> <20090422055118.GE9009@kroah.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Greg KH" <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Apr 2009 20:03:08.0713 (UTC) FILETIME=[5B54F190:01C9C385]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C9C385.5A5A92C3
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Fix sparse warning in drivers/usb/core/hub.c.

The following sparse warning is seen when building on ARM due
do the macro raw_local_irq_save():

	warning: symbol 'temp' shadows an earlier one

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

Patch is also attached in case of line-wrapping.


diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index be86ae3..c7a1a1d 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -457,13 +457,13 @@ static void hub_tt_kevent (struct work_struct
*work)
=20
 	spin_lock_irqsave (&hub->tt.lock, flags);
 	while (--limit && !list_empty (&hub->tt.clear_list)) {
-		struct list_head	*temp;
+		struct list_head	*next;
 		struct usb_tt_clear	*clear;
 		struct usb_device	*hdev =3D hub->hdev;
 		int			status;
=20
-		temp =3D hub->tt.clear_list.next;
-		clear =3D list_entry (temp, struct usb_tt_clear,
clear_list);
+		next =3D hub->tt.clear_list.next;
+		clear =3D list_entry (next, struct usb_tt_clear,
clear_list);
 		list_del (&clear->clear_list);
=20
 		/* drop lock so HCD can concurrently report other TT
errors */=20

------_=_NextPart_001_01C9C385.5A5A92C3
Content-Type: application/octet-stream;
	name="usb_core_hub_c_sparse.patch"
Content-Transfer-Encoding: base64
Content-Description: usb_core_hub_c_sparse.patch
Content-Disposition: attachment;
	filename="usb_core_hub_c_sparse.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NvcmUvaHViLmMgYi9kcml2ZXJzL3VzYi9jb3JlL2h1
Yi5jCmluZGV4IGJlODZhZTMuLmM3YTFhMWQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdXNiL2NvcmUv
aHViLmMKKysrIGIvZHJpdmVycy91c2IvY29yZS9odWIuYwpAQCAtNDU3LDEzICs0NTcsMTMgQEAg
c3RhdGljIHZvaWQgaHViX3R0X2tldmVudCAoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCiAJ
c3Bpbl9sb2NrX2lycXNhdmUgKCZodWItPnR0LmxvY2ssIGZsYWdzKTsKIAl3aGlsZSAoLS1saW1p
dCAmJiAhbGlzdF9lbXB0eSAoJmh1Yi0+dHQuY2xlYXJfbGlzdCkpIHsKLQkJc3RydWN0IGxpc3Rf
aGVhZAkqdGVtcDsKKwkJc3RydWN0IGxpc3RfaGVhZAkqbmV4dDsKIAkJc3RydWN0IHVzYl90dF9j
bGVhcgkqY2xlYXI7CiAJCXN0cnVjdCB1c2JfZGV2aWNlCSpoZGV2ID0gaHViLT5oZGV2OwogCQlp
bnQJCQlzdGF0dXM7CiAKLQkJdGVtcCA9IGh1Yi0+dHQuY2xlYXJfbGlzdC5uZXh0OwotCQljbGVh
ciA9IGxpc3RfZW50cnkgKHRlbXAsIHN0cnVjdCB1c2JfdHRfY2xlYXIsIGNsZWFyX2xpc3QpOwor
CQluZXh0ID0gaHViLT50dC5jbGVhcl9saXN0Lm5leHQ7CisJCWNsZWFyID0gbGlzdF9lbnRyeSAo
bmV4dCwgc3RydWN0IHVzYl90dF9jbGVhciwgY2xlYXJfbGlzdCk7CiAJCWxpc3RfZGVsICgmY2xl
YXItPmNsZWFyX2xpc3QpOwogCiAJCS8qIGRyb3AgbG9jayBzbyBIQ0QgY2FuIGNvbmN1cnJlbnRs
eSByZXBvcnQgb3RoZXIgVFQgZXJyb3JzICovCg==

------_=_NextPart_001_01C9C385.5A5A92C3--
