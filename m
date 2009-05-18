Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbZERMls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbZERMls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 08:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZERMlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 08:41:35 -0400
Received: from smtp.nokia.com ([192.100.105.134]:35021 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbZERMle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 08:41:34 -0400
From: <Tero.Kristo@nokia.com>
To: <linux-kernel@vger.kernel.org>
Date: Mon, 18 May 2009 14:40:59 +0200
Subject: Memory management timer optimizations for power saving
Thread-Topic: Memory management timer optimizations for power saving
Thread-Index: AcnXteUzRVEAbZMGSuWeLt62GsWwyg==
Message-ID: <1F18D6510CF0474A8C9500565A7E41A20544D91D8C@NOK-EUMSG-02.mgdnok.nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_1F18D6510CF0474A8C9500565A7E41A20544D91D8CNOKEUMSG02mgd_"
MIME-Version: 1.0
X-OriginalArrivalTime: 18 May 2009 12:41:01.0646 (UTC) FILETIME=[E6B53EE0:01C9D7B5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_1F18D6510CF0474A8C9500565A7E41A20544D91D8CNOKEUMSG02mgd_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I've been looking at some timer optimizations for the kernel to get it to s=
leep as long as possible, and to allow maximum power saving in embedded ARM=
 environment. One of the most severe timer users appears to be memory manag=
ement, with reap_work and wb_timer expiring rather often (I am seeing somet=
hing like one timer expiring every two seconds or so.) In the attached patc=
h I have changed the timers to deferred type, i.e. they can be delayed unti=
l next wakeup occurs from some other source, like another timer or some per=
ipheral I/O. Can you see any problems doing something like this? A potentia=
l issue could be that some data writeback to permanent storage gets delayed=
, and in case of a sudden power loss it might be lost completely.

-Tero

--_002_1F18D6510CF0474A8C9500565A7E41A20544D91D8CNOKEUMSG02mgd_
Content-Type: application/octet-stream;
	name="0001-Memory-management-timer-optimizations-for-power-savi.patch"
Content-Description: 0001-Memory-management-timer-optimizations-for-power-savi.patch
Content-Disposition: attachment;
	filename="0001-Memory-management-timer-optimizations-for-power-savi.patch";
	size=1221; creation-date="Wed, 13 May 2009 14:45:01 GMT";
	modification-date="Wed, 13 May 2009 14:45:01 GMT"
Content-Transfer-Encoding: base64

RnJvbSAxYmVmZWFjYmE5MTA0ZGRkYmIyOGMyZDE3M2U2MGY1ZDI2YjZiMzE0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBUZXJvIEtyaXN0byA8dGVyby5rcmlzdG9Abm9raWEuY29tPgpE
YXRlOiBXZWQsIDEzIE1heSAyMDA5IDE1OjQwOjU0ICswMzAwClN1YmplY3Q6IFtQQVRDSF0gTWVt
b3J5IG1hbmFnZW1lbnQgdGltZXIgb3B0aW1pemF0aW9ucyBmb3IgcG93ZXIgc2F2aW5nCgpTaWdu
ZWQtb2ZmLWJ5OiBUZXJvIEtyaXN0byA8dGVyby5rcmlzdG9Abm9raWEuY29tPgotLS0KIG1tL3Bh
Z2Utd3JpdGViYWNrLmMgfCAgICAxICsKIG1tL3NsYWIuYyAgICAgICAgICAgfCAgICAyICstCiAy
IGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9tbS9wYWdlLXdyaXRlYmFjay5jIGIvbW0vcGFnZS13cml0ZWJhY2suYwppbmRleCAyOTcw
ZTM1Li4zMzY3ZjMzIDEwMDY0NAotLS0gYS9tbS9wYWdlLXdyaXRlYmFjay5jCisrKyBiL21tL3Bh
Z2Utd3JpdGViYWNrLmMKQEAgLTgzNSw2ICs4MzUsNyBAQCB2b2lkIF9faW5pdCBwYWdlX3dyaXRl
YmFja19pbml0KHZvaWQpCiB7CiAJaW50IHNoaWZ0OwogCisJaW5pdF90aW1lcl9kZWZlcnJhYmxl
KCZ3Yl90aW1lcik7CiAJbW9kX3RpbWVyKCZ3Yl90aW1lciwgamlmZmllcyArIGRpcnR5X3dyaXRl
YmFja19pbnRlcnZhbCk7CiAJd3JpdGViYWNrX3NldF9yYXRlbGltaXQoKTsKIAlyZWdpc3Rlcl9j
cHVfbm90aWZpZXIoJnJhdGVsaW1pdF9uYik7CmRpZmYgLS1naXQgYS9tbS9zbGFiLmMgYi9tbS9z
bGFiLmMKaW5kZXggMDkxODc1MS4uYWU1MzYxYiAxMDA2NDQKLS0tIGEvbW0vc2xhYi5jCisrKyBi
L21tL3NsYWIuYwpAQCAtOTQyLDcgKzk0Miw3IEBAIHN0YXRpYyB2b2lkIF9fY3B1aW5pdCBzdGFy
dF9jcHVfdGltZXIoaW50IGNwdSkKIAkgKi8KIAlpZiAoa2V2ZW50ZF91cCgpICYmIHJlYXBfd29y
ay0+d29yay5mdW5jID09IE5VTEwpIHsKIAkJaW5pdF9yZWFwX25vZGUoY3B1KTsKLQkJSU5JVF9E
RUxBWUVEX1dPUksocmVhcF93b3JrLCBjYWNoZV9yZWFwKTsKKwkJSU5JVF9ERUxBWUVEX1dPUktf
REVGRVJSQUJMRShyZWFwX3dvcmssIGNhY2hlX3JlYXApOwogCQlzY2hlZHVsZV9kZWxheWVkX3dv
cmtfb24oY3B1LCByZWFwX3dvcmssCiAJCQkJCV9fcm91bmRfamlmZmllc19yZWxhdGl2ZShIWiwg
Y3B1KSk7CiAJfQotLSAKMS41LjQuMwoK

--_002_1F18D6510CF0474A8C9500565A7E41A20544D91D8CNOKEUMSG02mgd_--
