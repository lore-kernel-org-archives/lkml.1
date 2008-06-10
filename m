Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbYFJE1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbYFJE1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 00:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbYFJE1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 00:27:09 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:45420 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYFJE1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 00:27:08 -0400
Message-ID: <484E0280.2050305@kernel.org>
Date: Mon, 09 Jun 2008 21:26:40 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] bugfix: was Re: [ linus-git ] prctl(PR_SET_KEEPCAPS, ...)
 is broken for some	configs, e.g. CONFIG_SECURITY_SELINUX
References: <1212932321.4675.9.camel@earth> <484BF662.9070100@kernel.org> <20080608110630.08a45cc6.akpm@linux-foundation.org> <484C5E84.2020307@kernel.org> <20080608163926.56f1be3d.akpm@linux-foundation.org> <20080609171741.GA13403@us.ibm.com>
In-Reply-To: <20080609171741.GA13403@us.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------000709050507050406040607"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000709050507050406040607
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I agree. Short term, here is a patch to add dummy support for KEEPCAPS.

Cheers

Andrew

Serge E. Hallyn wrote:
|>> I fear that nothing will happen, and we'll end up wasting a lot of
|> peoples' time sending hey-why-did-my-dhcp-break reports.
|
| If we decide to get rid of dummy long-term, then it's far less
| distasteful to have it lie and claim the keepcaps worked in the
| meantime.
|
| So for 2.6.26 we could have dummy lie, then plan to make capabilities
| the default for 2.6.27?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFITgKA+bHCR3gb8jsRAiQYAJ47VnlBq2GSvLQv40tymjybLhNAtQCgya8G
YZQN/5w1uq+X2MYv1x4T4D4=
=NhwX
-----END PGP SIGNATURE-----

--------------000709050507050406040607
Content-Type: text/plain;
 name="dummy-prctl.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="dummy-prctl.patch"

RnJvbSBiZTE5YTQ3MTZjOTdjNWFhZjRjOTcyMWVlY2NmYWIyZDQ0ODk3Y2UyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBbmRyZXcgRy4gTW9yZ2FuIDxtb3JnYW5Aa2VybmVs
Lm9yZz4KRGF0ZTogTW9uLCA5IEp1biAyMDA4IDIxOjIyOjE4IC0wNzAwClN1YmplY3Q6IFtQ
QVRDSF0gQWRkIChiYWNrKSBkdW1teSBzdXBwb3J0IGZvciBLRUVQQ0FQUy4KClNlZTogaHR0
cDovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTEwNzQ4CgpTaWduZWQt
b2ZmLWJ5OiBBbmRyZXcgRy4gTW9yZ2FuIDxtb3JnYW5Aa2VybmVsLm9yZz4KLS0tCiBzZWN1
cml0eS9kdW1teS5jIHwgICAyNCArKysrKysrKysrKysrKysrKysrKysrKy0KIDEgZmlsZXMg
Y2hhbmdlZCwgMjMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9zZWN1cml0eS9kdW1teS5jIGIvc2VjdXJpdHkvZHVtbXkuYwppbmRleCBmNTBjNmMzLi5i
ODkxNjg4IDEwMDY0NAotLS0gYS9zZWN1cml0eS9kdW1teS5jCisrKyBiL3NlY3VyaXR5L2R1
bW15LmMKQEAgLTI3LDYgKzI3LDggQEAKICNpbmNsdWRlIDxsaW51eC9odWdldGxiLmg+CiAj
aW5jbHVkZSA8bGludXgvcHRyYWNlLmg+CiAjaW5jbHVkZSA8bGludXgvZmlsZS5oPgorI2lu
Y2x1ZGUgPGxpbnV4L3ByY3RsLmg+CisjaW5jbHVkZSA8bGludXgvc2VjdXJlYml0cy5oPgog
CiBzdGF0aWMgaW50IGR1bW15X3B0cmFjZSAoc3RydWN0IHRhc2tfc3RydWN0ICpwYXJlbnQs
IHN0cnVjdCB0YXNrX3N0cnVjdCAqY2hpbGQpCiB7CkBAIC02MDcsNyArNjA5LDI3IEBAIHN0
YXRpYyBpbnQgZHVtbXlfdGFza19raWxsIChzdHJ1Y3QgdGFza19zdHJ1Y3QgKnAsIHN0cnVj
dCBzaWdpbmZvICppbmZvLAogc3RhdGljIGludCBkdW1teV90YXNrX3ByY3RsIChpbnQgb3B0
aW9uLCB1bnNpZ25lZCBsb25nIGFyZzIsIHVuc2lnbmVkIGxvbmcgYXJnMywKIAkJCSAgICAg
dW5zaWduZWQgbG9uZyBhcmc0LCB1bnNpZ25lZCBsb25nIGFyZzUsIGxvbmcgKnJjX3ApCiB7
Ci0JcmV0dXJuIDA7CisJc3dpdGNoIChvcHRpb24pIHsKKwljYXNlIFBSX0NBUEJTRVRfUkVB
RDoKKwkJKnJjX3AgPSAoY2FwX3ZhbGlkKGFyZzIpID8gMSA6IC1FSU5WQUwpOworCQlicmVh
azsKKwljYXNlIFBSX0dFVF9LRUVQQ0FQUzoKKwkJKnJjX3AgPSBpc3NlY3VyZShTRUNVUkVf
S0VFUF9DQVBTKTsKKwkJYnJlYWs7CisJY2FzZSBQUl9TRVRfS0VFUENBUFM6CisJCWlmIChh
cmcyID4gMSkKKwkJCSpyY19wID0gLUVJTlZBTDsKKwkJZWxzZSBpZiAoYXJnMikKKwkJCWN1
cnJlbnQtPnNlY3VyZWJpdHMgfD0gaXNzZWN1cmVfbWFzayhTRUNVUkVfS0VFUF9DQVBTKTsK
KwkJZWxzZQorCQkJY3VycmVudC0+c2VjdXJlYml0cyAmPQorCQkJCX5pc3NlY3VyZV9tYXNr
KFNFQ1VSRV9LRUVQX0NBUFMpOworCQlicmVhazsKKwlkZWZhdWx0OgorCQlyZXR1cm4gMDsK
Kwl9CisKKwlyZXR1cm4gMTsKIH0KIAogc3RhdGljIHZvaWQgZHVtbXlfdGFza19yZXBhcmVu
dF90b19pbml0IChzdHJ1Y3QgdGFza19zdHJ1Y3QgKnApCi0tIAoxLjUuMy43Cgo=
--------------000709050507050406040607--
