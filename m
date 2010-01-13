Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188Ab0AMRX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab0AMRX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 12:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059Ab0AMRXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 12:23:25 -0500
Received: from server109c.appriver.com ([72.32.253.87]:2424 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932167Ab0AMRXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:23:23 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01CA9475.5A6988A7"
Subject: [PATCH 1/2] net: at91_ether.c - Allow transmitter interrupt to be handled first in ISR
Date: Wed, 13 Jan 2010 12:25:07 -0500
Message-ID: <3DBBD805E3BA064A87F551C0E8BD36740289748A@MAILSRV.intcomgrp.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] net: at91_ether.c - Allow transmitter interrupt to be handled first in ISR
Thread-Index: AcqUdVm5vi57RtOxS3KRRBtnGwS5yg==
From: "James Kosin" <JKosin@intcomgrp.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Linux Netdev List" <netdev@vger.kernel.org>,
       "Eric Dumazet" <eric.dumazet@gmail.com>
X-Policy: GLOBAL - intcomgrp.com
X-Policy: GLOBAL - intcomgrp.com
X-Primary: jkosin@intcomgrp.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: JKosin@intcomgrp.com ALLOWED
X-Note: VCH-CT/SI:0-854/SG:1 1/13/2010 11:22:41 AM
X-Virus-Scan: V-X0M0
X-Note: Spam Tests Failed: 
X-Country-Path: UNITED STATES->UNITED STATES
X-Note-Sending-IP: 216.54.13.100
X-Note-Reverse-DNS: mail.intcomgrp.com
X-Note-WHTLIST: JKosin@intcomgrp.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G113 G114 G115 G116 G120 G121 G132 G219 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01CA9475.5A6988A7
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Ok,

This is an optimization to:

  Allow the transmitter to free the skb before the receiver allocates
many skbs from the system.  This should help with skb reuse and in
multi-core ARM systems allow the next transmitter to be started while we
service the receiver DMA blocks.

  This first patch is only a move of the service of the transmitter
interrupt to be first in the ISR.  This is not expensive; because the
transmitter queue to the MAC is only (1) one deep, and the receiver is
currently (9) nine deep.

James Kosin


------_=_NextPart_001_01CA9475.5A6988A7
Content-Type: application/octet-stream;
	name="ether_patch_1.patch"
Content-Transfer-Encoding: base64
Content-Description: ether_patch_1.patch
Content-Disposition: attachment;
	filename="ether_patch_1.patch"

LS0tIEM6L0RvY3VtZW50cyBhbmQgU2V0dGluZ3Mvamtvc2luL015IERvY3VtZW50cy9qdW5rL2tl
cm5lbC9Db3B5IG9mIGxpbnV4LTIuNi4zMS41L2RyaXZlcnMvbmV0L2FybS9hdDkxX2V0aGVyLmMJ
VGh1IE9jdCAyMiAxODo1Nzo1NiAyMDA5DQorKysgQzovRG9jdW1lbnRzIGFuZCBTZXR0aW5ncy9q
a29zaW4vTXkgRG9jdW1lbnRzL2p1bmsva2VybmVsL2xpbnV4LTIuNi4zMS41L2RyaXZlcnMvbmV0
L2FybS9hdDkxX2V0aGVyLmMJV2VkIEphbiAxMyAxMjowNTozOSAyMDEwDQpAQCAtOTI1LDkgKzky
NSw2IEBADQogCSAgIEl0IGlzIGF1dG9tYXRpY2FsbHkgY2xlYXJlZCBvbmNlIHJlYWQuICovDQog
CWludHN0YXR1cyA9IGF0OTFfZW1hY19yZWFkKEFUOTFfRU1BQ19JU1IpOw0KIA0KLQlpZiAoaW50
c3RhdHVzICYgQVQ5MV9FTUFDX1JDT00pCQkvKiBSZWNlaXZlIGNvbXBsZXRlICovDQotCQlhdDkx
ZXRoZXJfcngoZGV2KTsNCi0NCiAJaWYgKGludHN0YXR1cyAmIEFUOTFfRU1BQ19UQ09NKSB7CS8q
IFRyYW5zbWl0IGNvbXBsZXRlICovDQogCQkvKiBUaGUgVENPTSBiaXQgaXMgc2V0IGV2ZW4gaWYg
dGhlIHRyYW5zbWlzc2lvbiBmYWlsZWQuICovDQogCQlpZiAoaW50c3RhdHVzICYgKEFUOTFfRU1B
Q19UVU5EIHwgQVQ5MV9FTUFDX1JUUlkpKQ0KQEAgLTk0MCw2ICs5MzcsOSBAQA0KIAkJfQ0KIAkJ
bmV0aWZfd2FrZV9xdWV1ZShkZXYpOw0KIAl9DQorDQorCWlmIChpbnRzdGF0dXMgJiBBVDkxX0VN
QUNfUkNPTSkJCS8qIFJlY2VpdmUgY29tcGxldGUgKi8NCisJCWF0OTFldGhlcl9yeChkZXYpOw0K
IA0KIAkvKiBXb3JrLWFyb3VuZCBmb3IgRXJyYXRhICMxMSAqLw0KIAlpZiAoaW50c3RhdHVzICYg
QVQ5MV9FTUFDX1JCTkEpIHsNCg==

------_=_NextPart_001_01CA9475.5A6988A7--
