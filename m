Return-Path: <linux-kernel-owner+w=401wt.eu-S1763947AbYJJUCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763947AbYJJUCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761470AbYJJUCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:02:04 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36183 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760704AbYJJUCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:02:01 -0400
Message-ID: <48EFB4B2.2020508@canonical.com>
Date: Fri, 10 Oct 2008 16:01:54 -0400
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: stable@kernel.org
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in used_vectors bitmap
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------090606050700010608050601"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090606050700010608050601
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Affected: 2.6.24-2.6.27

Someone from the community found out, that after repeatedly unloading and
loading a device driver that uses MSI IRQs, the system eventually assigned
the vector initially reserved for IRQ0 to the device driver.

The reason for this is, that although IRQ0 is tied to the FIRST_DEVICE_VECTOR
when declaring the irq_vector table, the corresponding bit in the used_vectors
map is not set. So, if vectors are released and assigned often enough, the
vector will get assigned to another interrupt. This happens more often with
MSI interrupts as those are exclusively using a vector.

Fix this by setting the bit for the FIRST_DEVICE_VECTOR in the bitmap.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
-- 

When all other means of communication fail, try words!



--------------090606050700010608050601
Content-Type: application/mbox;
 name="0001-x86-Reserve-FIRST_DEVICE_VECTOR-in-used_vectors-bit.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename*0="0001-x86-Reserve-FIRST_DEVICE_VECTOR-in-used_vectors-bit.pat";
 filename*1="ch"

RnJvbSBhMjcyYTI4ZjUyMGM1OGE4NDg1M2UwOThiNGVlNTY1NDg2Y2E1MDYyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBTdGVmYW4gQmFkZXIgPHN0ZWZhbi5iYWRlckBjYW5v
bmljYWwuY29tPgpEYXRlOiBTYXQsIDI3IFNlcCAyMDA4IDExOjA3OjMwIC0wNDAwClN1Ympl
Y3Q6IFtQQVRDSF0geDg2OiBSZXNlcnZlIEZJUlNUX0RFVklDRV9WRUNUT1IgaW4gdXNlZF92
ZWN0b3JzIGJpdG1hcC4KClNvbWVvbmUgZnJvbSB0aGUgY29tbXVuaXR5IGZvdW5kIG91dCwg
dGhhdCBhZnRlciByZXBlYXRlZGx5IHVubG9hZGluZyBhbmQKbG9hZGluZyBhIGRldmljZSBk
cml2ZXIgdGhhdCB1c2VzIE1TSSBJUlFzLCB0aGUgc3lzdGVtIGV2ZW50dWFsbHkgYXNzaWdu
ZWQKdGhlIHZlY3RvciBpbml0aWFsbHkgcmVzZXJ2ZWQgZm9yIElSUTAgdG8gdGhlIGRldmlj
ZSBkcml2ZXIuCgpUaGUgcmVhc29uIGZvciB0aGlzIGlzLCB0aGF0IGFsdGhvdWdoIElSUTAg
aXMgdGllZCB0byB0aGUgRklSU1RfREVWSUNFX1ZFQ1RPUgp3aGVuIGRlY2xhcmluZyB0aGUg
aXJxX3ZlY3RvciB0YWJsZSwgdGhlIGNvcnJlc3BvbmRpbmcgYml0IGluIHRoZSB1c2VkX3Zl
Y3RvcnMKbWFwIGlzIG5vdCBzZXQuIFNvLCBpZiB2ZWN0b3JzIGFyZSByZWxlYXNlZCBhbmQg
YXNzaWduZWQgb2Z0ZW4gZW5vdWdoLCB0aGUKdmVjdG9yIHdpbGwgZ2V0IGFzc2lnbmVkIHRv
IGFub3RoZXIgaW50ZXJydXB0LiBUaGlzIGhhcHBlbnMgbW9yZSBvZnRlbiB3aXRoCk1TSSBp
bnRlcnJ1cHRzIGFzIHRob3NlIGFyZSBleGNsdXNpdmVseSB1c2luZyBhIHZlY3Rvci4KCkZp
eCB0aGlzIGJ5IHNldHRpbmcgdGhlIGJpdCBmb3IgdGhlIEZJUlNUX0RFVklDRV9WRUNUT1Ig
aW4gdGhlIGJpdG1hcC4KClNpZ25lZC1vZmYtYnk6IFN0ZWZhbiBCYWRlciA8c3RlZmFuLmJh
ZGVyQGNhbm9uaWNhbC5jb20+Ci0tLQogYXJjaC94ODYva2VybmVsL2lvX2FwaWNfMzIuYyB8
ICAgIDMgKysrCiAxIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvaW9fYXBpY18zMi5jIGIvYXJj
aC94ODYva2VybmVsL2lvX2FwaWNfMzIuYwppbmRleCAwOWNkZGI1Li5iZmQ5ZmM1IDEwMDY0
NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvaW9fYXBpY18zMi5jCisrKyBiL2FyY2gveDg2L2tl
cm5lbC9pb19hcGljXzMyLmMKQEAgLTIzMTQsNiArMjMxNCw5IEBAIHZvaWQgX19pbml0IHNl
dHVwX0lPX0FQSUModm9pZCkKIAlmb3IgKGkgPSBmaXJzdF9zeXN0ZW1fdmVjdG9yOyBpIDwg
TlJfVkVDVE9SUzsgaSsrKQogCQlzZXRfYml0KGksIHVzZWRfdmVjdG9ycyk7CiAKKwkvKiBN
YXJrIEZJUlNUX0RFVklDRV9WRUNUT1Igd2hpY2ggaXMgYXNzaWduZWQgdG8gSVJRMCBhcyB1
c2VkLiAqLworCXNldF9iaXQoRklSU1RfREVWSUNFX1ZFQ1RPUiwgdXNlZF92ZWN0b3JzKTsK
KwogCWVuYWJsZV9JT19BUElDKCk7CiAKIAlpb19hcGljX2lycXMgPSB+UElDX0lSUVM7Ci0t
IAoxLjUuNC4zCgo=
--------------090606050700010608050601--
