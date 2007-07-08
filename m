Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbXGHIZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbXGHIZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 04:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXGHIY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 04:24:59 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:13809 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbXGHIY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 04:24:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:mime-version:content-type;
        b=VlTiDMy5geIyuP/haZ7rZeAXU8P/nXIu+dDW1PaNkfLpdKrRNE1oqerOlHZM8MQVeVWmsQGyBj7uguCmlKWL+1VSDbOQsZIBQzHgLQNsEYAaYUZ06s8l77E41G1xei36BkFUUCFOo5lUlFPrDDV3S4qXi2XmXbe5SAqF/WJNCdY=
Message-ID: <3efb10970707080124i7a9323c5o9257b4adcb2ac493@mail.gmail.com>
Date: Sun, 8 Jul 2007 10:24:56 +0200
From: "Remy Bohmer" <l.pinguin@gmail.com>
Reply-To: linux@bohmer.net
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: PI mutex support on ARM
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       linux-rt-users@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_99287_24162445.1183883096032"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_99287_24162445.1183883096032
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Thomas,

I have build an implementation for the routine
futex_atomic_cmpxchg_inatomic() to make PTHREAD_PRIO_INHERIT mutex
work on ARM.
Compared to other architectures where CPU specific assembler is used,
it is probably not the most optimal implementation possible, but I
tested it successfully on a Atmel AT91RM9200 core, and it could work
on other (UP) architectures as well.

What do you think of it?
Or do you know a better solution?

Kind Regards,

Remy

------=_Part_99287_24162445.1183883096032
Content-Type: text/x-patch; name=fix-userspace-prio-inherit.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f3v956lr
Content-Disposition: attachment; filename="fix-userspace-prio-inherit.patch"

SW5kZXg6IGxpbnV4LTIuNi4yMS9pbmNsdWRlL2FzbS9mdXRleC5oCj09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxp
bnV4LTIuNi4yMS5vcmlnL2luY2x1ZGUvYXNtL2Z1dGV4LmgJMjAwNy0wNC0yNiAwNTowODozMi4w
MDAwMDAwMDAgKzAyMDAKKysrIGxpbnV4LTIuNi4yMS9pbmNsdWRlL2FzbS9mdXRleC5oCTIwMDct
MDctMDYgMTU6MTE6MDEuMDAwMDAwMDAwICswMjAwCkBAIC0xLDYgKzEsNzkgQEAKLSNpZm5kZWYg
X0FTTV9GVVRFWF9ICi0jZGVmaW5lIF9BU01fRlVURVhfSAorI2lmbmRlZiBfQVNNX0FSTV9GVVRF
WF9ICisjZGVmaW5lIF9BU01fQVJNX0ZVVEVYX0gKIAotI2luY2x1ZGUgPGFzbS1nZW5lcmljL2Z1
dGV4Lmg+CisjaWZkZWYgX19LRVJORUxfXworCisjaW5jbHVkZSA8bGludXgvZnV0ZXguaD4KKyNp
bmNsdWRlIDxhc20vZXJybm8uaD4KKyNpbmNsdWRlIDxhc20vdWFjY2Vzcy5oPgorCitzdGF0aWMg
aW5saW5lIGludAorZnV0ZXhfYXRvbWljX29wX2ludXNlciAoaW50IGVuY29kZWRfb3AsIGludCBf
X3VzZXIgKnVhZGRyKQoreworCWludCBvcCA9IChlbmNvZGVkX29wID4+IDI4KSAmIDc7CisJaW50
IGNtcCA9IChlbmNvZGVkX29wID4+IDI0KSAmIDE1OworCWludCBvcGFyZyA9IChlbmNvZGVkX29w
IDw8IDgpID4+IDIwOworCWludCBjbXBhcmcgPSAoZW5jb2RlZF9vcCA8PCAyMCkgPj4gMjA7CisJ
aW50IG9sZHZhbCA9IDAsIHJldDsKKwlpZiAoZW5jb2RlZF9vcCAmIChGVVRFWF9PUF9PUEFSR19T
SElGVCA8PCAyOCkpCisJCW9wYXJnID0gMSA8PCBvcGFyZzsKKworCWlmICghIGFjY2Vzc19vayAo
VkVSSUZZX1dSSVRFLCB1YWRkciwgc2l6ZW9mKGludCkpKQorCQlyZXR1cm4gLUVGQVVMVDsKKwor
CXBhZ2VmYXVsdF9kaXNhYmxlKCk7CisKKwlzd2l0Y2ggKG9wKSB7CisJY2FzZSBGVVRFWF9PUF9T
RVQ6CisJY2FzZSBGVVRFWF9PUF9BREQ6CisJY2FzZSBGVVRFWF9PUF9PUjoKKwljYXNlIEZVVEVY
X09QX0FORE46CisJY2FzZSBGVVRFWF9PUF9YT1I6CisJZGVmYXVsdDoKKwkJcmV0ID0gLUVOT1NZ
UzsKKwl9CisKKwlwYWdlZmF1bHRfZW5hYmxlKCk7CisKKwlpZiAoIXJldCkgeworCQlzd2l0Y2gg
KGNtcCkgeworCQljYXNlIEZVVEVYX09QX0NNUF9FUTogcmV0ID0gKG9sZHZhbCA9PSBjbXBhcmcp
OyBicmVhazsKKwkJY2FzZSBGVVRFWF9PUF9DTVBfTkU6IHJldCA9IChvbGR2YWwgIT0gY21wYXJn
KTsgYnJlYWs7CisJCWNhc2UgRlVURVhfT1BfQ01QX0xUOiByZXQgPSAob2xkdmFsIDwgY21wYXJn
KTsgYnJlYWs7CisJCWNhc2UgRlVURVhfT1BfQ01QX0dFOiByZXQgPSAob2xkdmFsID49IGNtcGFy
Zyk7IGJyZWFrOworCQljYXNlIEZVVEVYX09QX0NNUF9MRTogcmV0ID0gKG9sZHZhbCA8PSBjbXBh
cmcpOyBicmVhazsKKwkJY2FzZSBGVVRFWF9PUF9DTVBfR1Q6IHJldCA9IChvbGR2YWwgPiBjbXBh
cmcpOyBicmVhazsKKwkJZGVmYXVsdDogcmV0ID0gLUVOT1NZUzsKKwkJfQorCX0KKwlyZXR1cm4g
cmV0OworfQorCitzdGF0aWMgaW5saW5lIGludAorZnV0ZXhfYXRvbWljX2NtcHhjaGdfaW5hdG9t
aWMoaW50IF9fdXNlciAqdWFkZHIsIGludCBvbGR2YWwsIGludCBuZXd2YWwpCit7CisJaW50IGVy
ciA9IDA7CisJaW50IHV2YWw7CisJdW5zaWduZWQgbG9uZyBmbGFnczsKKworCWlmICghYWNjZXNz
X29rKFZFUklGWV9XUklURSwgdWFkZHIsIHNpemVvZihpbnQpKSkKKwkJcmV0dXJuIC1FRkFVTFQ7
CisKKwlsb2NhbF9pcnFfc2F2ZShmbGFncyk7CisKKwllcnIgPSBnZXRfdXNlcih1dmFsLCB1YWRk
cik7CisJaWYgKGVycikKKwl7CisJCWxvY2FsX2lycV9yZXN0b3JlKGZsYWdzKTsKKwkJIHJldHVy
biAtRUZBVUxUOworCX0KKwlpZiAodXZhbCA9PSBvbGR2YWwpCisJCWVyciA9IHB1dF91c2VyKG5l
d3ZhbCwgdWFkZHIpOworCisJbG9jYWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOworCisJaWYgKGVycikg
cmV0dXJuIC1FRkFVTFQ7CisJcmV0dXJuIHV2YWw7Cit9CiAKICNlbmRpZgo=
------=_Part_99287_24162445.1183883096032--
