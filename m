Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbXKZNb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbXKZNb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 08:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbXKZNbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 08:31:52 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:48319 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbXKZNbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 08:31:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:x-google-sender-auth;
        b=VrPY+k55AgxRK7EpnbIQIK4UanANr/SyhD1z+MNT+xa2zbrT8nTxZ365cU27mn1L7Z6+tgMEd/G+7aAA5Tf8rcmcnyiCe4Z+RCG9Ncvwjy7WgBkAyakMh5OkYiVoo/uCdbUcEkJ8balt8YhnJa27Vph53vAWLVu64Xp+MqSXYEc=
Message-ID: <3efb10970711260531x5e9f05acgfabdfa885a220192@mail.gmail.com>
Date: Mon, 26 Nov 2007 14:31:46 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>
Subject: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling can/will stall forever
Cc: "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_5352_29347093.1196083906826"
X-Google-Sender-Auth: 29eea0460b2f4e3b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_5352_29347093.1196083906826
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

I use 2.6.23.1-rt5 on the Atmel AT91 series.
Interrupt threading on Preempt-RT and ARM works fine, except for
(edge-triggered) GPIO interrupts. There is a problem when a new
interrupt arives while the interrupt thread is handling the previous
interrupt. If this occurs the interrupt handling stalls forever.

This is caused by a unbalanced interrupt mask/unmask problem in the kernel.
The attached patch fixes this. More information about this problem is
documented inside the patch itself.

This patch is meant for Preempt-RT only.

Kind Regards,

Remy Bohmer

------=_Part_5352_29347093.1196083906826
Content-Type: text/x-patch; name=fix-gpio-irq-stalling-bug.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f9h1bchv
Content-Disposition: attachment; filename=fix-gpio-irq-stalling-bug.patch

T24gQVJNIHRoZXJlIGlzIGEgcHJvYmxlbSB3aGVyZSB0aGUgaW50ZXJydXB0IGhhbmRsZXIgc3Rh
bGxzIHdoZW4gdGhleSBhcmUgCmNvbWluZyBmYXN0ZXIgdGhhbiB0aGUga2VybmVsIGNhbiBoYW5k
bGUuCgpUaGUgcHJvYmxlbSBvY2N1cnMgd2hlbiB0aGUgcm91dGluZSBoYW5kbGVfc2ltcGxlX2ly
cSgpIG1hc2tzIHRoZSBpbnRlcnJ1cHQgCndoZW4gYW4gSVJRLXRocmVhZCBpcyBoYW5kbGluZyB0
aGUgaW50ZXJydXB0IGF0IHRoZSBzYW1lIHRpbWUuIChJUlFfSU5QUk9HUkVTUwppcyBzZXQpLiBU
aGUgaW50ZXJydXB0IHRocmVhZCwgaG93ZXZlciBkb2VzICoqbmV2ZXIqKiBhIApkZXNjLT5jaGlw
LT51bm1hc2soKSwgc28gdGhlIGludGVycnVwdCBiZWNvbWVzIGRpc2FibGVkIGZvcmV2ZXIuCgpJ
UlFfRElTQUJMRUQgaXMgdXN1YWxseSBub3Qgc2V0IGZvciB0aGlzIGludGVycnVwdAoKVGhpcyBp
cyBpbiBrZXJuZWwvaXJxL2NoaXAuYywgd2hlcmUgdGhlIGlycSBpcyBtYXNrZWQgd2hlbiBhIElS
US10aHJlYWQgaXMKcnVubmluZzogCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCnZvaWQgZmFzdGNhbGwKaGFu
ZGxlX3NpbXBsZV9pcnEodW5zaWduZWQgaW50IGlycSwgc3RydWN0IGlycV9kZXNjICpkZXNjKQp7
CgouLi4uCi4uLi4KCglpZiAodW5saWtlbHkoIWFjdGlvbiB8fCAoZGVzYy0+c3RhdHVzICYgKElS
UV9JTlBST0dSRVNTIHwKCQkJCQkJIElSUV9ESVNBQkxFRCkpKSkgewooISEpLT4JCWlmIChkZXNj
LT5jaGlwLT5tYXNrKQooISEpLT4JCQlkZXNjLT5jaGlwLT5tYXNrKGlycSk7CgkJZGVzYy0+c3Rh
dHVzICY9IH4oSVJRX1JFUExBWSB8IElSUV9XQUlUSU5HKTsKCQlkZXNjLT5zdGF0dXMgfD0gSVJR
X1BFTkRJTkc7CgkJZ290byBvdXRfdW5sb2NrOwoJfQoKLi4uLgouLi4uCn0KLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0KCk1hc2tpbmcgdGhlIGludGVycnVwdCBzZWVtcyB2YWxpZCwgYmVjYXVzZSB0aGUgaW50
ZXJydXB0IGhhbmRsZXIgdGhyZWFkIGlzIApzdGlsbCBydW5uaW5nLCBzbyBpdCBjYW4gaGFuZGxl
IHRoZSBuZXcgcGVuZGluZyBpbnRlcnJ1cHQuIEJ1dCwgaXQgaGFzIHRvIGJlCnVtYXNrZWQgc29t
ZXdoZXJlLiBUaGUgbG9naWNhbCBwbGFjZSBpcyB0byBkbyB0aGlzIGluIGtlcm5lbC9pcnEvbWFu
YWdlLmMsIApiZWNhdXNlIHRoaXMgc2l0dWF0aW9uIGlzIGFsc28gaGFuZGxlZCBmb3IgdGhlIHRo
cmVhZF9sZXZlbF9pcnEoKSBhbmQgCnRocmVhZF9mYXN0ZW9pX2lycSgpLCBidXQgbm90IGZvciB0
aHJlYWRfc2ltcGxlX2lycSgpLiBUaGlzIHBhdGNoIGFkZHMgdGhpcwpmb3IgdGhlc2Uga2luZCBv
ZiBpbnRlcnJ1cHRzIGFsc28uCgpTaWduZWQtb2ZmLWJ5OiBSZW15IEJvaG1lciA8bGludXhAYm9o
bWVyLm5ldD4KLS0tCiBrZXJuZWwvaXJxL21hbmFnZS5jIHwgICAgMyArKysKIDEgZmlsZSBjaGFu
Z2VkLCAzIGluc2VydGlvbnMoKykKCkluZGV4OiBsaW51eC0yLjYuMjMva2VybmVsL2lycS9tYW5h
Z2UuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYuMjMub3JpZy9rZXJuZWwvaXJxL21hbmFnZS5j
CTIwMDctMTEtMjYgMTM6NDY6NTguMDAwMDAwMDAwICswMTAwCisrKyBsaW51eC0yLjYuMjMva2Vy
bmVsL2lycS9tYW5hZ2UuYwkyMDA3LTExLTI2IDEzOjQ4OjMwLjAwMDAwMDAwMCArMDEwMApAQCAt
NjQ2LDYgKzY0Niw5IEBAIHN0YXRpYyB2b2lkIHRocmVhZF9zaW1wbGVfaXJxKGlycV9kZXNjX3QK
IAkJCW5vdGVfaW50ZXJydXB0KGlycSwgZGVzYywgYWN0aW9uX3JldCk7CiAJfQogCWRlc2MtPnN0
YXR1cyAmPSB+SVJRX0lOUFJPR1JFU1M7CisKKwlpZiAoIShkZXNjLT5zdGF0dXMgJiBJUlFfRElT
QUJMRUQpICYmIGRlc2MtPmNoaXAtPnVubWFzaykKKwkJZGVzYy0+Y2hpcC0+dW5tYXNrKGlycSk7
CiB9CiAKIC8qCg==
------=_Part_5352_29347093.1196083906826--
