Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbYEDAmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbYEDAmo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 20:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbYEDAmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 20:42:35 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:32611 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbYEDAme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 20:42:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=j32NQzF5TR5ppWEnVmQ1EdH0K1Q6kpbr0ByS8JQkK0hnQ7CqTu7lJn3J/WnM2sBmsUWEaBXLT2p4tL1ztIPW7WCRrfZtfXjK16M0Ez8wMJ6p7v/Po2LLzg2ITzitbAGyfLF8UkHZamEDvPW34QQH8ySRu6c4PssGRf9V+PPE1n8=
Message-ID: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com>
Date: Sat, 3 May 2008 20:42:34 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] default to n for GROUP_SCHED and FAIR_GROUP_SCHED
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "akpm@osdl.org" <akpm@osdl.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <peterz@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_13654_4952093.1209861754332"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_13654_4952093.1209861754332
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

GROUP_SCHED is confirmed to cause unacceptable latencies -
http://lkml.org/lkml/2008/5/2/370.

Besides there is no reason for it to be on by default.

Mark it EXPERIMENTAL and default to no.

Patch also attached.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

--- linux-2.6/init/Kconfig.orig	2008-05-03 20:14:41.000000000 -0400
+++ linux-2.6/init/Kconfig	2008-05-03 20:29:06.000000000 -0400
@@ -318,7 +318,8 @@

 config GROUP_SCHED
 	bool "Group CPU scheduler"
-	default y
+	depends on EXPERIMENTAL
+	default n
 	help
 	  This feature lets CPU scheduler recognize task groups and control CPU
 	  bandwidth allocation to such task groups.
@@ -326,7 +327,7 @@
 config FAIR_GROUP_SCHED
 	bool "Group scheduling for SCHED_OTHER"
 	depends on GROUP_SCHED
-	default y
+	default GROUP_SCHED

 config RT_GROUP_SCHED
 	bool "Group scheduling for SCHED_RR/FIFO"

------=_Part_13654_4952093.1209861754332
Content-Type: text/x-diff; name=init_kconfig.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ffswfif60
Content-Disposition: attachment; filename=init_kconfig.patch

R1JPVVBfU0NIRUQgaXMgY29uZmlybWVkIHRvIGNhdXNlIHVuYWNjZXB0YWJsZSBsYXRlbmNpZXMg
LQpodHRwOi8vbGttbC5vcmcvbGttbC8yMDA4LzUvMi8zNzAuIAoKQmVzaWRlcyB0aGVyZSBpcyBu
byByZWFzb24gZm9yIGl0IHRvIGJlIG9uIGJ5IGRlZmF1bHQuCgpNYXJrIGl0IEVYUEVSSU1FTlRB
TCBhbmQgZGVmYXVsdCB0byBuby4KClNpZ25lZC1vZmYtYnk6IFBhcmFnIFdhcnVka2FyIDxwYXJh
Zy53YXJ1ZGthckBnbWFpbC5jb20+CgotLS0gbGludXgtMi42L2luaXQvS2NvbmZpZy5vcmlnCTIw
MDgtMDUtMDMgMjA6MTQ6NDEuMDAwMDAwMDAwIC0wNDAwCisrKyBsaW51eC0yLjYvaW5pdC9LY29u
ZmlnCTIwMDgtMDUtMDMgMjA6Mjk6MDYuMDAwMDAwMDAwIC0wNDAwCkBAIC0zMTgsNyArMzE4LDgg
QEAKIAogY29uZmlnIEdST1VQX1NDSEVECiAJYm9vbCAiR3JvdXAgQ1BVIHNjaGVkdWxlciIKLQlk
ZWZhdWx0IHkKKwlkZXBlbmRzIG9uIEVYUEVSSU1FTlRBTAorCWRlZmF1bHQgbgogCWhlbHAKIAkg
IFRoaXMgZmVhdHVyZSBsZXRzIENQVSBzY2hlZHVsZXIgcmVjb2duaXplIHRhc2sgZ3JvdXBzIGFu
ZCBjb250cm9sIENQVQogCSAgYmFuZHdpZHRoIGFsbG9jYXRpb24gdG8gc3VjaCB0YXNrIGdyb3Vw
cy4KQEAgLTMyNiw3ICszMjcsNyBAQAogY29uZmlnIEZBSVJfR1JPVVBfU0NIRUQKIAlib29sICJH
cm91cCBzY2hlZHVsaW5nIGZvciBTQ0hFRF9PVEhFUiIKIAlkZXBlbmRzIG9uIEdST1VQX1NDSEVE
Ci0JZGVmYXVsdCB5CisJZGVmYXVsdCBHUk9VUF9TQ0hFRAogCiBjb25maWcgUlRfR1JPVVBfU0NI
RUQKIAlib29sICJHcm91cCBzY2hlZHVsaW5nIGZvciBTQ0hFRF9SUi9GSUZPIgo=
------=_Part_13654_4952093.1209861754332--
