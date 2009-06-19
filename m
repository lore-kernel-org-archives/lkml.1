Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbZFSBUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbZFSBUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 21:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZFSBUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 21:20:10 -0400
Received: from mail-yx0-f177.google.com ([209.85.210.177]:51310 "EHLO
	mail-yx0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZFSBUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 21:20:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=lw+T5/Dqq9iYr4jWQaWLJmlgDnySFxGaKYpHBK1qZJM9XSAckk0zzjdHhKCLmVKRpp
         KQ3bgPoV2N3hLZJ0/eN0TiaiHHqsB/48OALJ5H1cqbr6BbtcYSvRhTpn0UGPYYZ7mhMR
         dQ3Hnajo3fJaYbt8Tk29cQYNuBabZnLsXEOeQ=
MIME-Version: 1.0
In-Reply-To: <200906151304.16416.arnd@arndb.de>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org> 
	<1244980878-2124-6-git-send-email-vapier@gentoo.org> <200906151304.16416.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 18 Jun 2009 21:19:41 -0400
Message-ID: <8bd0f97a0906181819u25df402fxfd535030fd180e87@mail.gmail.com>
Subject: Re: [PATCH 05/17] Blackfin: convert to generic checksum code
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: multipart/mixed; boundary=001e680f1678d44460046ca9524d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001e680f1678d44460046ca9524d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Mon, Jun 15, 2009 at 07:04, Arnd Bergmann wrote:
> On Sunday 14 June 2009, Mike Frysinger wrote:
>> The Blackfin port only implemented an optimized version of the
>> csum_tcpudp_nofold function, so convert everything else to the new
>> generic code.
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> Have you tested this one well? I was as careful as possible with the
> version I added, but it was basically only tested on microblaze, which
> has a different endianess from blackfin. Some areas of the code may be
> sensitive to this.

i did some tests and it looks like do_csum() is broken :(

here's the input:
do_csum({ 0xff 0xfb 0x01 }, 3)

and here's the output:
Blackfin: 0xfc00
generic: 0xfcff

if i run the two funcs on my x86, i see similar behavior.  the
attached csum-test.c contains the csum code from lib/checksum.c and
arch/blackfin/lib/checksum.c and shows the problem.
-mike

--001e680f1678d44460046ca9524d
Content-Type: text/x-csrc; charset=US-ASCII; name="csum-test.c"
Content-Disposition: attachment; filename="csum-test.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fw47pmgg0

I2luY2x1ZGUgPHN0ZGlvLmg+CgpzdGF0aWMgaW5saW5lIHVuc2lnbmVkIHNob3J0IGdlbl9mcm9t
MzJ0bzE2KHVuc2lnbmVkIGxvbmcgeCkKewoJLyogYWRkIHVwIDE2LWJpdCBhbmQgMTYtYml0IGZv
ciAxNitjIGJpdCAqLwoJeCA9ICh4ICYgMHhmZmZmKSArICh4ID4+IDE2KTsKCS8qIGFkZCB1cCBj
YXJyeS4uICovCgl4ID0gKHggJiAweGZmZmYpICsgKHggPj4gMTYpOwoJcmV0dXJuIHg7Cn0KCnN0
YXRpYyB1bnNpZ25lZCBpbnQgZ2VuX2RvX2NzdW0oY29uc3QgdW5zaWduZWQgY2hhciAqYnVmZiwg
aW50IGxlbikKewoJaW50IG9kZCwgY291bnQ7Cgl1bnNpZ25lZCBsb25nIHJlc3VsdCA9IDA7CgoJ
aWYgKGxlbiA8PSAwKQoJCWdvdG8gb3V0OwoJb2RkID0gMSAmICh1bnNpZ25lZCBsb25nKSBidWZm
OwoJaWYgKG9kZCkgewoJCXJlc3VsdCA9ICpidWZmOwoJCWxlbi0tOwoJCWJ1ZmYrKzsKCX0KCWNv
dW50ID0gbGVuID4+IDE7CQkvKiBuciBvZiAxNi1iaXQgd29yZHMuLiAqLwoJaWYgKGNvdW50KSB7
CgkJaWYgKDIgJiAodW5zaWduZWQgbG9uZykgYnVmZikgewoJCQlyZXN1bHQgKz0gKih1bnNpZ25l
ZCBzaG9ydCAqKSBidWZmOwoJCQljb3VudC0tOwoJCQlsZW4gLT0gMjsKCQkJYnVmZiArPSAyOwoJ
CX0KCQljb3VudCA+Pj0gMTsJCS8qIG5yIG9mIDMyLWJpdCB3b3Jkcy4uICovCgkJaWYgKGNvdW50
KSB7CgkJCXVuc2lnbmVkIGxvbmcgY2FycnkgPSAwOwoJCQlkbyB7CgkJCQl1bnNpZ25lZCBsb25n
IHcgPSAqKHVuc2lnbmVkIGxvbmcgKikgYnVmZjsKCQkJCWNvdW50LS07CgkJCQlidWZmICs9IDQ7
CgkJCQlyZXN1bHQgKz0gY2Fycnk7CgkJCQlyZXN1bHQgKz0gdzsKCQkJCWNhcnJ5ID0gKHcgPiBy
ZXN1bHQpOwoJCQl9IHdoaWxlIChjb3VudCk7CgkJCXJlc3VsdCArPSBjYXJyeTsKCQkJcmVzdWx0
ID0gKHJlc3VsdCAmIDB4ZmZmZikgKyAocmVzdWx0ID4+IDE2KTsKCQl9CgkJaWYgKGxlbiAmIDIp
IHsKCQkJcmVzdWx0ICs9ICoodW5zaWduZWQgc2hvcnQgKikgYnVmZjsKCQkJYnVmZiArPSAyOwoJ
CX0KCX0KCWlmIChsZW4gJiAxKQoJCXJlc3VsdCArPSAoKmJ1ZmYgPDwgOCk7CglyZXN1bHQgPSBn
ZW5fZnJvbTMydG8xNihyZXN1bHQpOwoJaWYgKG9kZCkKCQlyZXN1bHQgPSAoKHJlc3VsdCA+PiA4
KSAmIDB4ZmYpIHwgKChyZXN1bHQgJiAweGZmKSA8PCA4KTsKb3V0OgoJcmV0dXJuIHJlc3VsdDsK
fQoKc3RhdGljIHVuc2lnbmVkIHNob3J0IGJmX2RvX2NzdW0oY29uc3QgdW5zaWduZWQgY2hhciAq
YnVmZiwgaW50IGxlbikKewoJcmVnaXN0ZXIgdW5zaWduZWQgbG9uZyBzdW0gPSAwOwoJaW50IHN3
YXBwZW0gPSAwOwoKCWlmICgxICYgKHVuc2lnbmVkIGxvbmcpYnVmZikgewoJCXN1bSA9ICpidWZm
IDw8IDg7CgkJYnVmZisrOwoJCWxlbi0tOwoJCSsrc3dhcHBlbTsKCX0KCgl3aGlsZSAobGVuID4g
MSkgewoJCXN1bSArPSAqKHVuc2lnbmVkIHNob3J0ICopYnVmZjsKCQlidWZmICs9IDI7CgkJbGVu
IC09IDI7Cgl9CgoJaWYgKGxlbiA+IDApCgkJc3VtICs9ICpidWZmOwoKCS8qICBGb2xkIDMyLWJp
dCBzdW0gdG8gMTYgYml0cyAqLwoJd2hpbGUgKHN1bSA+PiAxNikKCQlzdW0gPSAoc3VtICYgMHhm
ZmZmKSArIChzdW0gPj4gMTYpOwoKCWlmIChzd2FwcGVtKQoJCXN1bSA9ICgoc3VtICYgMHhmZjAw
KSA+PiA4KSArICgoc3VtICYgMHgwMGZmKSA8PCA4KTsKCglyZXR1cm4gc3VtOwoKfQoKaW50IG1h
aW4oKQp7Cgl1bnNpZ25lZCBjaGFyIGJ1ZltdID0geyAweGZmLCAweGZiLCAweDAxIH07Cgl1bnNp
Z25lZCBzaG9ydCBnZW4gPSBnZW5fZG9fY3N1bShidWYsIDMpOwoJdW5zaWduZWQgc2hvcnQgYmYg
PSBiZl9kb19jc3VtKGJ1ZiwgMyk7CglwcmludGYoIiV4IHZzICV4XG4iLCBnZW4sIGJmKTsKCXJl
dHVybiAwOwp9Cg==
--001e680f1678d44460046ca9524d--
