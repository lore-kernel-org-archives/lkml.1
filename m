Return-Path: <linux-kernel-owner+w=401wt.eu-S1764147AbXG0Php@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764147AbXG0Php (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 11:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbXG0Phh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 11:37:37 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:14247 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbXG0Phf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 11:37:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:x-google-sender-auth;
        b=gr8rs9+JJzCiaekilA6FPUckiZ8EYMWgbJ2rwUAe0eomw8By0ORPmMbTniqdORJDXsTYs9MhpgBp7qM3RAiIgNtRPPLKFMkLrA7HcyYJLf3j+SxuZ4BEoZDggI2dKMN+b8Dr/USNc5APR5gjjOKC4AoyVB0bDgBYhM8iEIPloGs=
Message-ID: <3efb10970707270837p130a6f53q58afed9650885672@mail.gmail.com>
Date: Fri, 27 Jul 2007 17:37:34 +0200
From: "Remy Bohmer" <linux@bohmer.net>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH (updated)]: PTHREAD_PRIO_INHERIT support for ARM.
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_3884_25805677.1185550654285"
X-Google-Sender-Auth: 42f02bce8f96d5c9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_3884_25805677.1185550654285
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello All,

Attached I have put a (very simple) patch to make PTHREAD_PRIO_INHERIT
work for ARM.

This patch implements the futex_atomic_cmpxchg_inatomic() for the
ARM architecture. Without this patch the userland PI mutex will
not work on ARM.

I have tested it with pi_stress, classic_pi and our production
environment, on the following Cores:
* Atmel at91rm9200 (ARM-v4)
* Atmel at91sam9261 (ARM-v5)

But it should also work on other ARM cores (like ARM-v6), because it
makes use of a cmpxchg() routine that was already there in the kernel
and that was optimised for pre- and post- ARM-v6 cores. But even if it
doesn't work, it could not make it worse than the current
implementation, that one is completely broken, it allows multiple
threads in the same protected section. So, with this patch it can only
get better ;-)

Coding style checked with checkpatch.pl 0.6 on 2.6.22.1-rt6

So, Please apply.

Kind Regards,

Remy B=F6hmer

------=_Part_3884_25805677.1185550654285
Content-Type: text/x-patch; name=fix-userspace-prio-inherit.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4mtx3mf
Content-Disposition: attachment; filename="fix-userspace-prio-inherit.patch"

UFRIUkVBRF9QUklPX0lOSEVSSVQgc3VwcG9ydCBmb3IgQVJNLgoKVGhpcyBwYXRjaCBpbXBsZW1l
bnRzIHRoZSBmdXRleF9hdG9taWNfY21weGNoZ19pbmF0b21pYygpIGZvciB0aGUKQVJNIGFyY2hp
dGVjdHVyZS4gV2l0aG91dCB0aGlzIHBhdGNoIHRoZSB1c2VybGFuZCBQSSBtdXRleCB3aWxsCm5v
dCB3b3JrLgoKU2lnbmVkLW9mZi1ieTogUmVteSBCb2htZXIgPGxpbnV4QGJvaG1lci5uZXQ+Ci0t
LQojIGluY2x1ZGUvYXNtLWFybS9mdXRleC5oIHwgICA2NCArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKystLS0KIyAxIGZpbGUgY2hhbmdlZCwgNjEgaW5zZXJ0aW9u
cygrKSwgMyBkZWxldGlvbnMoLSkKIwpJbmRleDogbGludXgtMi42LjIyL2luY2x1ZGUvYXNtLWFy
bS9mdXRleC5oCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi4yMi5vcmlnL2luY2x1ZGUvYXNtLWFy
bS9mdXRleC5oCTIwMDctMDctMDkgMDE6MzI6MTcuMDAwMDAwMDAwICswMjAwCisrKyBsaW51eC0y
LjYuMjIvaW5jbHVkZS9hc20tYXJtL2Z1dGV4LmgJMjAwNy0wNy0yNCAxNzowNToyNi4wMDAwMDAw
MDAgKzAyMDAKQEAgLTEsNiArMSw2NCBAQAotI2lmbmRlZiBfQVNNX0ZVVEVYX0gKLSNkZWZpbmUg
X0FTTV9GVVRFWF9ICisjaWZuZGVmIF9BU01fQVJNX0ZVVEVYX0gKKyNkZWZpbmUgX0FTTV9BUk1f
RlVURVhfSAogCi0jaW5jbHVkZSA8YXNtLWdlbmVyaWMvZnV0ZXguaD4KKyNpZmRlZiBfX0tFUk5F
TF9fCiAKKyNpbmNsdWRlIDxsaW51eC9mdXRleC5oPgorI2luY2x1ZGUgPGxpbnV4L2Vycm5vLmg+
CisjaW5jbHVkZSA8bGludXgvdWFjY2Vzcy5oPgorI2luY2x1ZGUgPGFzbS9hdG9taWMuaD4KKwor
c3RhdGljIGlubGluZSBpbnQKK2Z1dGV4X2F0b21pY19vcF9pbnVzZXIoaW50IGVuY29kZWRfb3As
IGludCBfX3VzZXIgKnVhZGRyKQoreworCWludCBvcCA9IChlbmNvZGVkX29wID4+IDI4KSAmIDc7
CisJaW50IGNtcCA9IChlbmNvZGVkX29wID4+IDI0KSAmIDE1OworCWludCBvcGFyZyA9IChlbmNv
ZGVkX29wIDw8IDgpID4+IDIwOworCWludCBjbXBhcmcgPSAoZW5jb2RlZF9vcCA8PCAyMCkgPj4g
MjA7CisJaW50IG9sZHZhbCA9IDA7CisJaW50IHJldDsKKwlpZiAoZW5jb2RlZF9vcCAmIChGVVRF
WF9PUF9PUEFSR19TSElGVCA8PCAyOCkpCisJCW9wYXJnID0gMSA8PCBvcGFyZzsKKworCWlmICgh
YWNjZXNzX29rIChWRVJJRllfV1JJVEUsIHVhZGRyLCBzaXplb2YoaW50KSkpCisJCXJldHVybiAt
RUZBVUxUOworCisJcGFnZWZhdWx0X2Rpc2FibGUoKTsKKworCXN3aXRjaCAob3ApIHsKKwljYXNl
IEZVVEVYX09QX1NFVDoKKwljYXNlIEZVVEVYX09QX0FERDoKKwljYXNlIEZVVEVYX09QX09SOgor
CWNhc2UgRlVURVhfT1BfQU5ETjoKKwljYXNlIEZVVEVYX09QX1hPUjoKKwlkZWZhdWx0OgorCQly
ZXQgPSAtRU5PU1lTOworCX0KKworCXBhZ2VmYXVsdF9lbmFibGUoKTsKKworCWlmICghcmV0KSB7
CisJCXN3aXRjaCAoY21wKSB7CisJCWNhc2UgRlVURVhfT1BfQ01QX0VROiByZXQgPSAob2xkdmFs
ID09IGNtcGFyZyk7IGJyZWFrOworCQljYXNlIEZVVEVYX09QX0NNUF9ORTogcmV0ID0gKG9sZHZh
bCAhPSBjbXBhcmcpOyBicmVhazsKKwkJY2FzZSBGVVRFWF9PUF9DTVBfTFQ6IHJldCA9IChvbGR2
YWwgPCBjbXBhcmcpOyBicmVhazsKKwkJY2FzZSBGVVRFWF9PUF9DTVBfR0U6IHJldCA9IChvbGR2
YWwgPj0gY21wYXJnKTsgYnJlYWs7CisJCWNhc2UgRlVURVhfT1BfQ01QX0xFOiByZXQgPSAob2xk
dmFsIDw9IGNtcGFyZyk7IGJyZWFrOworCQljYXNlIEZVVEVYX09QX0NNUF9HVDogcmV0ID0gKG9s
ZHZhbCA+IGNtcGFyZyk7IGJyZWFrOworCQlkZWZhdWx0OiByZXQgPSAtRU5PU1lTOworCQl9CisJ
fQorCXJldHVybiByZXQ7Cit9CisKK3N0YXRpYyBpbmxpbmUgaW50CitmdXRleF9hdG9taWNfY21w
eGNoZ19pbmF0b21pYyhpbnQgX191c2VyICp1YWRkciwgaW50IG9sZHZhbCwgaW50IG5ld3ZhbCkK
K3sKKwlpZiAoIWFjY2Vzc19vayhWRVJJRllfV1JJVEUsIHVhZGRyLCBzaXplb2YoaW50KSkpCisJ
CXJldHVybiAtRUZBVUxUOworCisJcmV0dXJuIGNtcHhjaGcodWFkZHIsIG9sZHZhbCwgbmV3dmFs
KTsKK30KKworI2VuZGlmCiAjZW5kaWYK
------=_Part_3884_25805677.1185550654285--
