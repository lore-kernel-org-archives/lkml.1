Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbYJ0KJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbYJ0KJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 06:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbYJ0KJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 06:09:29 -0400
Received: from dakia3.marvell.com ([65.219.4.28]:43233 "EHLO
	dakia3.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbYJ0KJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:09:28 -0400
X-ASG-Debug-ID: 1225102168-33e401fc0000-xx1T2L
X-Barracuda-URL: http://dakia3.marvell.com:80/cgi-bin/mark.cgi
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-Barracuda-BBL-IP: 10.68.76.102
X-Barracuda-RBL-IP: 10.68.76.102
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C9381C.189E9596"
X-ASG-Orig-Subj: RE: CONFIG_LEDS_DA903X=m breaks 2.6.28-rc2-git1 build on x86-64
Subject: RE: CONFIG_LEDS_DA903X=m breaks 2.6.28-rc2-git1 build on x86-64
Date: Mon, 27 Oct 2008 03:09:25 -0700
Message-ID: <E913911567467945BBEB9277E27868B0013A5EEA@msiexch01.marvell.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: CONFIG_LEDS_DA903X=m breaks 2.6.28-rc2-git1 build on x86-64
thread-index: Ack4EF032fo3oAQPRce3n00urxdr9QABbZBg
References: <20081027094509.302401e4@hyperion.delvare>
From: "Eric Miao" <ymiao3@marvell.com>
To: "Jean Delvare" <khali@linux-fr.org>, "Mike Rapoport" <mike@compulab.co.il>,
       "Richard Purdie" <rpurdie@linux.intel.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1225102168
X-Barracuda-Virus-Scanned: by Marvell Mail Gateway at marvell.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C9381C.189E9596
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This is strange, it compiles OK on ARM, I don't know why this
failed on x86-64. But anyway, <linux/workqueue.h> should really
be explicitly included here.

The attached patch should fix this.

- eric

-----Original Message-----
From: Jean Delvare [mailto:khali@linux-fr.org]=20
Sent: Monday, October 27, 2008 4:45 PM
To: Mike Rapoport; Eric Miao; Richard Purdie
Cc: LKML; Linus Torvalds
Subject: CONFIG_LEDS_DA903X=3Dm breaks 2.6.28-rc2-git1 build on x86-64

Hi Mike, Eric, Richard,

With CONFIG_LEDS_DA903X=3Dm, kernel 2.6.28-rc2-git1 fails to build on
x86-64 with the following error:

  CC [M]  drivers/leds/leds-da903x.o
drivers/leds/leds-da903x.c:35: error: field "work" has incomplete type
drivers/leds/leds-da903x.c: In function "da903x_led_work":
drivers/leds/leds-da903x.c:47: warning: type defaults to "int" in
declaration of "__mptr"
drivers/leds/leds-da903x.c:47: warning: initialization from incompatible
pointer type
drivers/leds/leds-da903x.c: In function "da903x_led_set":
drivers/leds/leds-da903x.c:89: error: implicit declaration of function
"schedule_work"
drivers/leds/leds-da903x.c: In function "da903x_led_probe":
drivers/leds/leds-da903x.c:125: error: implicit declaration of function
"INIT_WORK"

Can we PLEASE stick to the plan and ONLY have bug FIXES after rc1 (and
even more so after rc2)?

Thanks,
--=20
Jean Delvare

------_=_NextPart_001_01C9381C.189E9596
Content-Type: application/octet-stream;
	name="0001-leds-da903x-fix-the-building-failure-of-incomplete.patch"
Content-Transfer-Encoding: base64
Content-Description: 0001-leds-da903x-fix-the-building-failure-of-incomplete.patch
Content-Disposition: attachment;
	filename="0001-leds-da903x-fix-the-building-failure-of-incomplete.patch"

RnJvbSAyZDgyMTIxYWFlY2Y3M2I2NjI4NWNjMWMwYmYyNDFjODdhZmU3MjkzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFcmljIE1pYW8gPGVyaWMubWlhb0BtYXJ2ZWxsLmNvbT4KRGF0
ZTogTW9uLCAyNyBPY3QgMjAwOCAxNzo0ODo1MCArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIGxlZHM6
IGRhOTAzeDogZml4IHRoZSBidWlsZGluZyBmYWlsdXJlIG9mIGluY29tcGxldGUgdHlwZSBvZiAn
d29yaycKCldpdGggQ09ORklHX0xFRFNfREE5MDNYPW0sIGtlcm5lbCAyLjYuMjgtcmMyLWdpdDEg
ZmFpbHMgdG8gYnVpbGQgb24KeDg2LTY0IHdpdGggdGhlIGZvbGxvd2luZyBlcnJvcjoKCiAgQ0Mg
W01dICBkcml2ZXJzL2xlZHMvbGVkcy1kYTkwM3gubwpkcml2ZXJzL2xlZHMvbGVkcy1kYTkwM3gu
YzozNTogZXJyb3I6IGZpZWxkICJ3b3JrIiBoYXMgaW5jb21wbGV0ZSB0eXBlCmRyaXZlcnMvbGVk
cy9sZWRzLWRhOTAzeC5jOiBJbiBmdW5jdGlvbiAiZGE5MDN4X2xlZF93b3JrIjoKZHJpdmVycy9s
ZWRzL2xlZHMtZGE5MDN4LmM6NDc6IHdhcm5pbmc6IHR5cGUgZGVmYXVsdHMgdG8gImludCIgaW4g
ZGVjbGFyYXRpb24gb2YgIl9fbXB0ciIKZHJpdmVycy9sZWRzL2xlZHMtZGE5MDN4LmM6NDc6IHdh
cm5pbmc6IGluaXRpYWxpemF0aW9uIGZyb20gaW5jb21wYXRpYmxlIHBvaW50ZXIgdHlwZQpkcml2
ZXJzL2xlZHMvbGVkcy1kYTkwM3guYzogSW4gZnVuY3Rpb24gImRhOTAzeF9sZWRfc2V0IjoKZHJp
dmVycy9sZWRzL2xlZHMtZGE5MDN4LmM6ODk6IGVycm9yOiBpbXBsaWNpdCBkZWNsYXJhdGlvbiBv
ZiBmdW5jdGlvbiAic2NoZWR1bGVfd29yayIKZHJpdmVycy9sZWRzL2xlZHMtZGE5MDN4LmM6IElu
IGZ1bmN0aW9uICJkYTkwM3hfbGVkX3Byb2JlIjoKZHJpdmVycy9sZWRzL2xlZHMtZGE5MDN4LmM6
MTI1OiBlcnJvcjogaW1wbGljaXQgZGVjbGFyYXRpb24gb2YgZnVuY3Rpb24gIklOSVRfV09SSyIK
CkluY2x1ZGUgdGhlIDxsaW51eC93b3JrcXVldWUuaD4gZXhwbGljaXRseSBoZXJlIHRvIGZpeCB0
aGUgYWJvdmUgaXNzdWUuCgpSZXBvcnRlZC1ieTogSmVhbiBEZWx2YXJlIDxraGFsaUBsaW51eC1m
ci5vcmc+ClNpZ25lZC1vZmYtYnk6IEVyaWMgTWlhbyA8ZXJpYy5taWFvQG1hcnZlbGwuY29tPgot
LS0KIGRyaXZlcnMvbGVkcy9sZWRzLWRhOTAzeC5jIHwgICAgMSArCiAxIGZpbGVzIGNoYW5nZWQs
IDEgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2xl
ZHMvbGVkcy1kYTkwM3guYyBiL2RyaXZlcnMvbGVkcy9sZWRzLWRhOTAzeC5jCmluZGV4IGYxZmRk
YjEuLjI3NjhjNjkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbGVkcy9sZWRzLWRhOTAzeC5jCisrKyBi
L2RyaXZlcnMvbGVkcy9sZWRzLWRhOTAzeC5jCkBAIC0xNyw2ICsxNyw3IEBACiAjaW5jbHVkZSA8
bGludXgvaW5pdC5oPgogI2luY2x1ZGUgPGxpbnV4L3BsYXRmb3JtX2RldmljZS5oPgogI2luY2x1
ZGUgPGxpbnV4L2xlZHMuaD4KKyNpbmNsdWRlIDxsaW51eC93b3JrcXVldWUuaD4KICNpbmNsdWRl
IDxsaW51eC9tZmQvZGE5MDN4Lmg+CiAKICNkZWZpbmUgREE5MDMwX0xFRDFfQ09OVFJPTAkweDIw
Ci0tIAoxLjYuMC4yCgo=

------_=_NextPart_001_01C9381C.189E9596--
