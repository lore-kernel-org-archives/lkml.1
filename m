Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbXGaHsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbXGaHsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 03:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbXGaHsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 03:48:04 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:24434 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbXGaHsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 03:48:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=doUkkrS6rBLzxjL8DUIZTU2S5OL6NrytpD/AvSaqejAbzVTQTWeTVtQXjSV0o/g7A7QsROG7JQ7KEEHkhPezou/tuv3YxJjmvbrqfIMyJpV8WwzGMLmXVe1UvZJ5iflaHJv18zVcNTKBxiqUFhVYhMcOuarZoHgVe/hTh+dfvI0=
Message-ID: <8bd0f97a0707310047u51c6e46l7e57e8f7bfc4e858@mail.gmail.com>
Date: Tue, 31 Jul 2007 03:47:59 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: early_printk accessing __log_buf
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org,
       "Greg Ungerer" <gerg@snapgear.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>, "Tim Bird" <tim.bird@am.sony.com>,
       bryan.wu@analog.com
In-Reply-To: <20070724143004.6325a511.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_44164_32817865.1185868079863"
References: <200707181756.44074.rgetz@blackfin.uclinux.org>
	 <200707241350.45086.rgetz@blackfin.uclinux.org>
	 <20070724111215.8d91dc7c.akpm@linux-foundation.org>
	 <200707241612.56509.rgetz@blackfin.uclinux.org>
	 <20070724143004.6325a511.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_44164_32817865.1185868079863
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 7/24/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 24 Jul 2007 16:12:56 -0400 Robin Getz wrote:
> > On Tue 24 Jul 2007 14:12, Andrew Morton pondered:
> > > Oh well, it sounds like we need the super-duper fast version.  Keep it
> > > as simple as possible, please.
> >
> > What about:
> >
> > int log_buf_copy(void *dest, int idx, size_t n);
> >
> > starting at index idx - copy n bytes to dest, return the number of bytes
> > copied (in case there are not n bytes in the log_buf yet).
>
> Sounds sensible.  I'd make it return size_t and take a char* arg though.
> Or just use `int' - size_t is a bit of a pain and this is all kernel-internal
> anwyay.

attached
-mike

------=_Part_44164_32817865.1185868079863
Content-Type: application/octet-stream; name="linux-log_buf_read.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="linux-log_buf_read.patch"
X-Attachment-Id: f_f4s36fc9

QWRkIHR3byBuZXcgZnVuY3Rpb25zIGZvciByZWFkaW5nIHRoZSBrZXJuZWwgbG9nIGJ1ZmZlci4g
IFRoZWlyIGludGVudGlvbgppcyB0byBiZSB1c2VkIGJ5IHJlY292ZXJ5L2R1bXAvZGVidWcgY29k
ZSBzbyB0aGUga2VybmVsIGxvZyBjYW4gYmUgZWFzaWx5CnJldHJpZXZlZC9wYXJzZWQgaW4gYSBj
cmFzaCBzY2VuYXJpbywgYnV0IHRoZXkgYXJlIGdlbmVyaWMgZW5vdWdoIGZvciBvdGhlcgpwZW9w
bGUgdG8gZHJlYW0gdXAgb3RoZXIgZnVuIHVzZXMuCgpTaWduZWQtb2ZmLWJ5OiBNaWtlIEZyeXNp
bmdlciA8dmFwaWVyQGdlbnRvby5vcmc+Ci0tLQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9r
ZXJuZWwuaCBiL2luY2x1ZGUvbGludXgva2VybmVsLmgKaW5kZXggNDMwMGJiNC4uOGQ1YjZjNyAx
MDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9rZXJuZWwuaAorKysgYi9pbmNsdWRlL2xpbnV4L2tl
cm5lbC5oCkBAIC0xNTYsNiArMTU2LDkgQEAgYXNtbGlua2FnZSBpbnQgdnByaW50ayhjb25zdCBj
aGFyICpmbXQsIHZhX2xpc3QgYXJncykKIAlfX2F0dHJpYnV0ZV9fICgoZm9ybWF0IChwcmludGYs
IDEsIDApKSk7CiBhc21saW5rYWdlIGludCBwcmludGsoY29uc3QgY2hhciAqIGZtdCwgLi4uKQog
CV9fYXR0cmlidXRlX18gKChmb3JtYXQgKHByaW50ZiwgMSwgMikpKSBfX2NvbGQ7CitleHRlcm4g
aW50IGxvZ19idWZfZ2V0X2xlbih2b2lkKTsKK2V4dGVybiBpbnQgbG9nX2J1Zl9yZWFkKGludCBp
ZHgpOworZXh0ZXJuIGludCBsb2dfYnVmX2NvcHkoY2hhciAqZGVzdCwgaW50IGlkeCwgaW50IGxl
bik7CiAjZWxzZQogc3RhdGljIGlubGluZSBpbnQgdnByaW50ayhjb25zdCBjaGFyICpzLCB2YV9s
aXN0IGFyZ3MpCiAJX19hdHRyaWJ1dGVfXyAoKGZvcm1hdCAocHJpbnRmLCAxLCAwKSkpOwpAQCAt
MTYzLDYgKzE2Niw5IEBAIHN0YXRpYyBpbmxpbmUgaW50IHZwcmludGsoY29uc3QgY2hhciAqcywg
dmFfbGlzdCBhcmdzKSB7IHJldHVybiAwOyB9CiBzdGF0aWMgaW5saW5lIGludCBwcmludGsoY29u
c3QgY2hhciAqcywgLi4uKQogCV9fYXR0cmlidXRlX18gKChmb3JtYXQgKHByaW50ZiwgMSwgMikp
KTsKIHN0YXRpYyBpbmxpbmUgaW50IF9fY29sZCBwcmludGsoY29uc3QgY2hhciAqcywgLi4uKSB7
IHJldHVybiAwOyB9CitzdGF0aWMgaW5saW5lIGludCBsb2dfYnVmX2dldF9sZW4odm9pZCkgeyBy
ZXR1cm4gMDsgfQorc3RhdGljIGlubGluZSBpbnQgbG9nX2J1Zl9yZWFkKGludCBpZHgpOyB7IHJl
dHVybiAwOyB9CitzdGF0aWMgaW5saW5lIGludCBsb2dfYnVmX2NvcHkoY2hhciAqZGVzdCwgaW50
IGlkeCwgaW50IGxlbikgeyByZXR1cm4gMDsgfQogI2VuZGlmCiAKIHVuc2lnbmVkIGxvbmcgaW50
X3NxcnQodW5zaWduZWQgbG9uZyk7CmRpZmYgLS1naXQgYS9rZXJuZWwvcHJpbnRrLmMgYi9rZXJu
ZWwvcHJpbnRrLmMKaW5kZXggMDUxZDI3ZS4uMzViMjMxYSAxMDA2NDQKLS0tIGEva2VybmVsL3By
aW50ay5jCisrKyBiL2tlcm5lbC9wcmludGsuYwpAQCAtMTYzLDYgKzE2Myw1NSBAQCBvdXQ6CiBf
X3NldHVwKCJsb2dfYnVmX2xlbj0iLCBsb2dfYnVmX2xlbl9zZXR1cCk7CiAKIC8qCisgKiBSZXR1
cm4gdGhlIG51bWJlciBvZiB1bnJlYWQgY2hhcmFjdGVycyBpbiB0aGUgbG9nIGJ1ZmZlci4KKyAq
LworaW50IGxvZ19idWZfZ2V0X2xlbih2b2lkKQoreworCXJldHVybiBsb2dfZW5kIC0gbG9nX3N0
YXJ0OworfQorCisvKgorICogQ29weSBhIHJhbmdlIG9mIGNoYXJhY3RlcnMgZnJvbSB0aGUgbG9n
IGJ1ZmZlci4KKyAqLworaW50IGxvZ19idWZfY29weShjaGFyICpkZXN0LCBpbnQgaWR4LCBpbnQg
bGVuKQoreworCWludCByZXQsIG1heDsKKworCWlmICghb29wc19pbl9wcm9ncmVzcykKKwkJc3Bp
bl9sb2NrX2lycSgmbG9nYnVmX2xvY2spOworCisJbWF4ID0gbG9nX2J1Zl9nZXRfbGVuKCk7CisJ
aWYgKGlkeCA8IDAgfHwgaWR4ID49IG1heCkKKwkJcmV0ID0gLTE7CisJZWxzZSB7CisJCWlmIChs
ZW4gPiBtYXgpCisJCQlsZW4gPSBtYXg7CisJCXJldCA9IGxlbjsKKwkJd2hpbGUgKGxlbi0tID4g
MCkgeworCQkJKmRlc3QgPSBMT0dfQlVGKGlkeCsrKTsKKwkJCSsrZGVzdDsKKwkJfQorCX0KKwor
CWlmICghb29wc19pbl9wcm9ncmVzcykKKwkJc3Bpbl91bmxvY2tfaXJxKCZsb2didWZfbG9jayk7
CisKKwlyZXR1cm4gcmV0OworfQorCisvKgorICogRXh0cmFjdCBhIHNpbmdsZSBjaGFyYWN0ZXIg
ZnJvbSB0aGUgbG9nIGJ1ZmZlci4KKyAqLworaW50IGxvZ19idWZfcmVhZChpbnQgaWR4KQorewor
CWNoYXIgcmV0OworCWlmIChsb2dfYnVmX2NvcHkoJnJldCwgaWR4LCAxKSA9PSAxKQorCQlyZXR1
cm4gcmV0OworCWVsc2UKKwkJcmV0dXJuIC0xOworfQorCisvKgogICogQ29tbWFuZHMgdG8gZG9f
c3lzbG9nOgogICoKICAqIAkwIC0tIENsb3NlIHRoZSBsb2cuICBDdXJyZW50bHkgYSBOT1AuCg==

------=_Part_44164_32817865.1185868079863--
