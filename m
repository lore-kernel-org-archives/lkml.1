Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbXKZNpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbXKZNpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 08:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbXKZNpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 08:45:34 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:31264 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbXKZNpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 08:45:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:references:x-google-sender-auth;
        b=B1peXdHcoU9+Gd39olfTkTZodf3mLESJOmykLE49pzqfAvbBPBHE9niC8K5J+rrGZG+4J4btif5ALhJXgD3jyZDueGKbQAbN/0K8HYUAo9otkjwnO2XbIBSqpbXbUoXGez9+b1Wc6BYYt5i/o+uDiH7VA6NOLWbl+T0siyIP4R4=
Message-ID: <3efb10970711260545i419a8352o4ca5248b10d81db5@mail.gmail.com>
Date: Mon, 26 Nov 2007 14:45:32 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling can/will stall forever
Cc: "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <3efb10970711260531x5e9f05acgfabdfa885a220192@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_5441_21490065.1196084732436"
References: <3efb10970711260531x5e9f05acgfabdfa885a220192@mail.gmail.com>
X-Google-Sender-Auth: 1c43e0f779acb7a4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_5441_21490065.1196084732436
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Attached the same patch, but it also cleans the manage.c code a bit,
because the IRQ types 'simple IRQ', 'level-IRQ' and 'FastEOI' were
handled differently while they should be handled the same.

Kind Regards,

Remy

2007/11/26, Remy Bohmer <linux@bohmer.net>:
> Hello,
>
> I use 2.6.23.1-rt5 on the Atmel AT91 series.
> Interrupt threading on Preempt-RT and ARM works fine, except for
> (edge-triggered) GPIO interrupts. There is a problem when a new
> interrupt arives while the interrupt thread is handling the previous
> interrupt. If this occurs the interrupt handling stalls forever.
>
> This is caused by a unbalanced interrupt mask/unmask problem in the kernel.
> The attached patch fixes this. More information about this problem is
> documented inside the patch itself.
>
> This patch is meant for Preempt-RT only.
>
> Kind Regards,
>
> Remy Bohmer
>
>

------=_Part_5441_21490065.1196084732436
Content-Type: text/x-patch; name=fix-gpio-irq-stalling-bug.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f9h1zef7
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
bWVyLm5ldD4KLS0tCiBrZXJuZWwvaXJxL21hbmFnZS5jIHwgICAyOSArKystLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMjYgZGVsZXRp
b25zKC0pCgpJbmRleDogbGludXgtMi42LjIzL2tlcm5lbC9pcnEvbWFuYWdlLmMKPT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PQotLS0gbGludXgtMi42LjIzLm9yaWcva2VybmVsL2lycS9tYW5hZ2UuYwkyMDA3LTExLTI2IDEz
OjQ2OjU4LjAwMDAwMDAwMCArMDEwMAorKysgbGludXgtMi42LjIzL2tlcm5lbC9pcnEvbWFuYWdl
LmMJMjAwNy0xMS0yNiAxNDo0MzozMi4wMDAwMDAwMDAgKzAxMDAKQEAgLTY0NiwyOCArNjQ2LDcg
QEAgc3RhdGljIHZvaWQgdGhyZWFkX3NpbXBsZV9pcnEoaXJxX2Rlc2NfdAogCQkJbm90ZV9pbnRl
cnJ1cHQoaXJxLCBkZXNjLCBhY3Rpb25fcmV0KTsKIAl9CiAJZGVzYy0+c3RhdHVzICY9IH5JUlFf
SU5QUk9HUkVTUzsKLX0KLQotLyoKLSAqIHRocmVhZGVkIGxldmVsIHR5cGUgaXJxIGhhbmRsZXIK
LSAqLwotc3RhdGljIHZvaWQgdGhyZWFkX2xldmVsX2lycShpcnFfZGVzY190ICpkZXNjKQotewot
CXVuc2lnbmVkIGludCBpcnEgPSBkZXNjIC0gaXJxX2Rlc2M7Ci0KLQl0aHJlYWRfc2ltcGxlX2ly
cShkZXNjKTsKLQlpZiAoIShkZXNjLT5zdGF0dXMgJiBJUlFfRElTQUJMRUQpICYmIGRlc2MtPmNo
aXAtPnVubWFzaykKLQkJZGVzYy0+Y2hpcC0+dW5tYXNrKGlycSk7Ci19Ci0KLS8qCi0gKiB0aHJl
YWRlZCBmYXN0ZW9pIHR5cGUgaXJxIGhhbmRsZXIKLSAqLwotc3RhdGljIHZvaWQgdGhyZWFkX2Zh
c3Rlb2lfaXJxKGlycV9kZXNjX3QgKmRlc2MpCi17Ci0JdW5zaWduZWQgaW50IGlycSA9IGRlc2Mg
LSBpcnFfZGVzYzsKIAotCXRocmVhZF9zaW1wbGVfaXJxKGRlc2MpOwogCWlmICghKGRlc2MtPnN0
YXR1cyAmIElSUV9ESVNBQkxFRCkgJiYgZGVzYy0+Y2hpcC0+dW5tYXNrKQogCQlkZXNjLT5jaGlw
LT51bm1hc2soaXJxKTsKIH0KQEAgLTc0NywxMiArNzI2LDEwIEBAIHN0YXRpYyB2b2lkIGRvX2hh
cmRpcnEoc3RydWN0IGlycV9kZXNjICoKIAlpZiAoIShkZXNjLT5zdGF0dXMgJiBJUlFfSU5QUk9H
UkVTUykpCiAJCWdvdG8gb3V0OwogCi0JaWYgKGRlc2MtPmhhbmRsZV9pcnEgPT0gaGFuZGxlX3Np
bXBsZV9pcnEpCisJaWYgKChkZXNjLT5oYW5kbGVfaXJxID09IGhhbmRsZV9zaW1wbGVfaXJxKSB8
fAorCSAgICAoZGVzYy0+aGFuZGxlX2lycSA9PSBoYW5kbGVfbGV2ZWxfaXJxKSAgfHwKKwkgICAg
KGRlc2MtPmhhbmRsZV9pcnEgPT0gaGFuZGxlX2Zhc3Rlb2lfaXJxKSkKIAkJdGhyZWFkX3NpbXBs
ZV9pcnEoZGVzYyk7Ci0JZWxzZSBpZiAoZGVzYy0+aGFuZGxlX2lycSA9PSBoYW5kbGVfbGV2ZWxf
aXJxKQotCQl0aHJlYWRfbGV2ZWxfaXJxKGRlc2MpOwotCWVsc2UgaWYgKGRlc2MtPmhhbmRsZV9p
cnEgPT0gaGFuZGxlX2Zhc3Rlb2lfaXJxKQotCQl0aHJlYWRfZmFzdGVvaV9pcnEoZGVzYyk7CiAJ
ZWxzZSBpZiAoZGVzYy0+aGFuZGxlX2lycSA9PSBoYW5kbGVfZWRnZV9pcnEpCiAJCXRocmVhZF9l
ZGdlX2lycShkZXNjKTsKIAllbHNlCg==
------=_Part_5441_21490065.1196084732436--
