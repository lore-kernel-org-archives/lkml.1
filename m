Return-Path: <linux-kernel-owner+w=401wt.eu-S932778AbYF3Vc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbYF3Vc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760284AbYF3VcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:32:18 -0400
Received: from smtp.nokia.com ([192.100.122.230]:17899 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbYF3VcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:32:17 -0400
Message-ID: <48694F9A.4010008@nokia.com>
Date: Tue, 01 Jul 2008 00:26:50 +0300
From: Stefan Becker <Stefan.Becker@nokia.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: ext David Brownell <david-b@pacbell.net>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] USB: fix interrupt disabling for HCDs with shared interrupt
 handlers
References: <Pine.LNX.4.44L0.0806301532500.2138-100000@iolanthe.rowland.org> <200806301331.21077.david-b@pacbell.net>
In-Reply-To: <200806301331.21077.david-b@pacbell.net>
Content-Type: multipart/mixed;
 boundary="------------080207000302000400010400"
X-OriginalArrivalTime: 30 Jun 2008 21:27:40.0585 (UTC) FILETIME=[20213190:01C8DAF8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080207000302000400010400
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

ext David Brownell wrote:
> On Monday 30 June 2008, Alan Stern wrote:
>> Don't bother with this extra stuff.  All USB host controller drivers
>> want to have interrupts disabled when their IRQ handlers run.
> 
> How about this one instead?  I think it's probably almost midnight
> where Stefan is, so I'd not expect Stefan to have an updated
> patch very soon ... :)

It is, put the rain pouring down on my house is keeping me awake :-)

Looks like you posted the same changes though...

Regards,

	Stefan

---
Stefan Becker
E-Mail: Stefan.Becker@nokia.com

--------------080207000302000400010400
Content-Type: text/plain;
 name="usb-fix-shared-interrupts-disabling.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="usb-fix-shared-interrupts-disabling.patch"

RnJvbSAzNjAyN2MxMDMzMGJkZjA4ZDRiYTU5NGMzNzkxM2VkZGE2ZGYzOTgzIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBTdGVmYW4gQmVja2VyIDxzdGVmYW4uYmVja2VyQG5v
a2lhLmNvbT4KRGF0ZTogTW9uLCAzMCBKdW4gMjAwOCAyMToxODoyOSArMDMwMApTdWJqZWN0
OiBbUEFUQ0hdIFVTQjogZml4IGludGVycnVwdCBkaXNhYmxpbmcgZm9yIEhDRHMgd2l0aCBz
aGFyZWQgaW50ZXJydXB0IGhhbmRsZXJzCgpBcyBoYXMgYmVlbiBkaXNjdXNzZWQgc2V2ZXJh
bCB0aW1lcyBvbiBMS01MLCBJUlFGX1NIQVJFRCB8IElSUUZfRElTQUJMRUQKZG9lc24ndCB3
b3JrIHJlbGlhYmx5LCBpLmUuIGEgc2hhcmVkIGludGVycnVwdCBoYW5kbGVyIENBTidUIGJl
IGNlcnRhaW4gdG8KYmUgY2FsbGVkIHdpdGggaW50ZXJydXB0cyBkaXNhYmxlZC4gTW9zdCBV
U0IgSENEIGhhbmRsZXJzIHVzZSBJUlFGX0RJU0FCTEVECmFuZCB0aGVyZWZvcmUgaGF2b2Mg
Y2FuIGJyZWFrIG91dCBpZiB0aGV5IHNoYXJlIHRoZWlyIGludGVycnVwdCB3aXRoIGEKaGFu
ZGxlciB0aGF0IGRvZXNuJ3QgdXNlIGl0LgoKT24gbXkgdGVzdCBtYWNoaW5lIHRoZSB5ZW50
YV9zb2NrZXQgaW50ZXJydXB0IGhhbmRsZXIgKG5vIElSUUZfRElTQUJMRUQpCndhcyByZWdp
c3RlcmVkIGJlZm9yZSBlaGNpX2hjZCBhbmQgb25lIHVoY2lfaGNkIGluc3RhbmNlLiBUaGVy
ZWZvcmUgYWxsCnVzYl9oY2RfaXJxKCkgaW52b2NhdGlvbnMgZm9yIGVoY2lfaGNkIGFuZCBm
b3Igb25lIHVoY2lfaGNkIGluc3RhbmNlCmhhcHBlbmVkIHdpdGggaW50ZXJydXB0cyBlbmFi
bGVkLiBUaGF0IGxlZCB0byByYW5kb20gbG9ja3VwcyBhcyBVU0IgY29yZQpIQ0QgZnVuY3Rp
b25zIHRoYXQgYWNxdWlyZSB0aGUgc2FtZSBzcGlubG9jayBjb3VsZCBiZSBjYWxsZWQgdHdp
Y2UKZnJvbSBpbnRlcnJ1cHQgaGFuZGxlcnMuCgpUaGlzIHBhdGNoIHVwZGF0ZXMgdXNiX2hj
ZF9pcnEoKSB0byBhbHdheXMgZGlzYWJsZS9yZXN0b3JlIGludGVycnVwdHMuCnVzYl9hZGRf
aGNkKCkgd2lsbCBzaWxlbnRseSByZW1vdmUgYW55IElSUUZfRElTQUJMRUQgcmVxdWVzdGVk
IGZyb20gSENEIGNvZGUuCgpTaWduZWQtb2ZmLWJ5OiBTdGVmYW4gQmVja2VyIDxzdGVmYW4u
YmVja2VyQG5va2lhLmNvbT4KCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9jb3JlL2hjZC5j
IGIvZHJpdmVycy91c2IvY29yZS9oY2QuYwppbmRleCAwOWE1M2U3Li4zZDM1NmJkIDEwMDY0
NAotLS0gYS9kcml2ZXJzL3VzYi9jb3JlL2hjZC5jCisrKyBiL2RyaXZlcnMvdXNiL2NvcmUv
aGNkLmMKQEAgLTE2ODMsMjAgKzE2ODMsMjcgQEAgRVhQT1JUX1NZTUJPTF9HUEwodXNiX2J1
c19zdGFydF9lbnVtKTsKICAqLwogaXJxcmV0dXJuX3QgdXNiX2hjZF9pcnEgKGludCBpcnEs
IHZvaWQgKl9faGNkKQogewotCXN0cnVjdCB1c2JfaGNkCQkqaGNkID0gX19oY2Q7Ci0JaW50
CQkJc3RhcnQgPSBoY2QtPnN0YXRlOworCXN0cnVjdCB1c2JfaGNkCQkqaGNkICA9IF9faGNk
OworCXVuc2lnbmVkIGludCAgICAgICAgICAgIGZsYWdzID0gMDsKKwlpcnFyZXR1cm5fdCAg
ICAgICAgICAgICByYzsKIAotCWlmICh1bmxpa2VseShzdGFydCA9PSBIQ19TVEFURV9IQUxU
IHx8Ci0JICAgICF0ZXN0X2JpdChIQ0RfRkxBR19IV19BQ0NFU1NJQkxFLCAmaGNkLT5mbGFn
cykpKQotCQlyZXR1cm4gSVJRX05PTkU7Ci0JaWYgKGhjZC0+ZHJpdmVyLT5pcnEgKGhjZCkg
PT0gSVJRX05PTkUpCi0JCXJldHVybiBJUlFfTk9ORTsKKwlsb2NhbF9pcnFfc2F2ZShmbGFn
cyk7CiAKLQlzZXRfYml0KEhDRF9GTEFHX1NBV19JUlEsICZoY2QtPmZsYWdzKTsKKwlpZiAo
dW5saWtlbHkoaGNkLT5zdGF0ZSA9PSBIQ19TVEFURV9IQUxUIHx8CisJCSAgICAgIXRlc3Rf
Yml0KEhDRF9GTEFHX0hXX0FDQ0VTU0lCTEUsICZoY2QtPmZsYWdzKSkpIHsKKwkJcmMgPSBJ
UlFfTk9ORTsKKwl9IGVsc2UgaWYgKGhjZC0+ZHJpdmVyLT5pcnEgKGhjZCkgPT0gSVJRX05P
TkUpIHsKKwkJcmMgPSBJUlFfTk9ORTsKKwl9IGVsc2UgeworCQlzZXRfYml0KEhDRF9GTEFH
X1NBV19JUlEsICZoY2QtPmZsYWdzKTsKKworCQlpZiAodW5saWtlbHkoaGNkLT5zdGF0ZSA9
PSBIQ19TVEFURV9IQUxUKSkKKwkJCXVzYl9oY19kaWVkIChoY2QpOworCQlyYyA9IElSUV9I
QU5ETEVEOworCX0KIAotCWlmICh1bmxpa2VseShoY2QtPnN0YXRlID09IEhDX1NUQVRFX0hB
TFQpKQotCQl1c2JfaGNfZGllZCAoaGNkKTsKLQlyZXR1cm4gSVJRX0hBTkRMRUQ7CisJbG9j
YWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOworCXJldHVybiByYzsKIH0KIAogLyotLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tKi8KQEAgLTE4NjAsNiArMTg2NywxMyBAQCBpbnQgdXNiX2FkZF9oY2Qoc3Ry
dWN0IHVzYl9oY2QgKmhjZCwKIAogCS8qIGVuYWJsZSBpcnFzIGp1c3QgYmVmb3JlIHdlIHN0
YXJ0IHRoZSBjb250cm9sbGVyICovCiAJaWYgKGhjZC0+ZHJpdmVyLT5pcnEpIHsKKworCQkv
KiBJUlFGX0RJU0FCTEVEIGRvZXNuJ3Qgd29yayBhcyBhZHZlcnRpc2VkIHdoZW4gdXNlZCB0
b2dldGhlcgorCQkgKiB3aXRoIElSUUZfU0hBUkVELiBBcyB1c2JfaGNkX2lycSgpIHdpbGwg
YWx3YXlzIGRpc2FibGUKKwkJICogaW50ZXJydXB0cyB3ZSBjYW4gcmVtb3ZlIGl0IGhlcmUu
CisJCSAqLworCQlpcnFmbGFncyAmPSB+SVJRRl9ESVNBQkxFRDsKKwogCQlzbnByaW50Ziho
Y2QtPmlycV9kZXNjciwgc2l6ZW9mKGhjZC0+aXJxX2Rlc2NyKSwgIiVzOnVzYiVkIiwKIAkJ
CQloY2QtPmRyaXZlci0+ZGVzY3JpcHRpb24sIGhjZC0+c2VsZi5idXNudW0pOwogCQlpZiAo
KHJldHZhbCA9IHJlcXVlc3RfaXJxKGlycW51bSwgJnVzYl9oY2RfaXJxLCBpcnFmbGFncywK

--------------080207000302000400010400--
