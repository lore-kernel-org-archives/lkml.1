Return-Path: <linux-kernel-owner+w=401wt.eu-S935182AbYBCOLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935182AbYBCOLH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 09:11:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759600AbYBCOKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 09:10:53 -0500
Received: from hs-out-0708.google.com ([64.233.178.241]:52438 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758965AbYBCOKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 09:10:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:references:x-google-sender-auth;
        b=sfUXpIA88GHOpiPKRhhiIVgSd1J62RIZRuqBg7WYyX/99xXKGy0XhxZiqsdbm0Fhmir8+FZ+Lsx88x6/9W9fLYxo68MfGfU5zFi7Z3SPlPLoRHRlrAeEg0k03yr/S/AQn80d/Jl1nm3HW1E0zCUC6i2+d5bwyt2AubP6D/hBAhk=
Message-ID: <e9c3a7c20802030610w17386065h6aca1c20bae080f4@mail.gmail.com>
Date: Sun, 3 Feb 2008 07:10:50 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Subject: Re: crypto/async_tx/* doesn't build on s390
Cc: "Cornelia Huck" <cornelia.huck@de.ibm.com>, herbert@gondor.apana.org.au,
       neilb@suse.de, schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080203114056.GB18211@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_1007_26710840.1202047850571"
References: <0C7297FA1D2D244A9C7F6959C0BF1E521D1C6C@azsmsx413.amr.corp.intel.com>
	 <20080201123738.24988af7@gondolin.boeblingen.de.ibm.com>
	 <e9c3a7c20802011331j2064afe5vc6228fe8363e15de@mail.gmail.com>
	 <20080203114056.GB18211@osiris.ibm.com>
X-Google-Sender-Auth: 42c8f531cea6c430
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_1007_26710840.1202047850571
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Feb 3, 2008 4:40 AM, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> On Fri, Feb 01, 2008 at 02:31:28PM -0700, Dan Williams wrote:
[..]
> The fix works for me. Thanks! However your mailer replaced tabs with spaces
> and added an extra line break.
>

The attached patch is slightly cleaner, and still works.  It marks
do_async_xor as '__always_inline'.

I have pushed this out to a git repository [1] and will be requesting
a pull later today.

--
Dan

[1] git://lost.foo-projects.org/~dwillia2/git/iop async-tx-for-linus

------=_Part_1007_26710840.1202047850571
Content-Type: text/x-patch; name=async-tx-fix-xor-compile.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fc7negbg0
Content-Disposition: attachment; filename=async-tx-fix-xor-compile.patch

YXN5bmNfdHg6IGZpeCBjb21waWxlIGJyZWFrYWdlLCBtYXJrIGRvX2FzeW5jX3hvciBfX2Fsd2F5
c19pbmxpbmUKCkZyb206IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPgoK
ZG9fYXN5bmNfeG9yIG11c3QgYmUgY29tcGlsZWQgYXdheSBvbiAhSEFTX0RNQSBhcmNocy4KClNp
Z25lZC1vZmYtYnk6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPgotLS0K
CiBjcnlwdG8vYXN5bmNfdHgvYXN5bmNfeG9yLmMgfCAgICA2ICsrKysrLQogMSBmaWxlcyBjaGFu
Z2VkLCA1IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgoKZGlmZiAtLWdpdCBhL2NyeXB0
by9hc3luY190eC9hc3luY194b3IuYyBiL2NyeXB0by9hc3luY190eC9hc3luY194b3IuYwppbmRl
eCAyNTc1ZjY3Li43MTY4ODVhIDEwMDY0NAotLS0gYS9jcnlwdG8vYXN5bmNfdHgvYXN5bmNfeG9y
LmMKKysrIGIvY3J5cHRvL2FzeW5jX3R4L2FzeW5jX3hvci5jCkBAIC0zMCw3ICszMCwxMSBAQAog
I2luY2x1ZGUgPGxpbnV4L3JhaWQveG9yLmg+CiAjaW5jbHVkZSA8bGludXgvYXN5bmNfdHguaD4K
IAotc3RhdGljIHZvaWQKKy8qIGRvX2FzeW5jX3hvciAtIGRtYSBtYXAgdGhlIHBhZ2VzIGFuZCBw
ZXJmb3JtIHRoZSB4b3Igd2l0aCBhbiBlbmdpbmUuCisgKiAJVGhpcyByb3V0aW5lIGlzIG1hcmtl
ZCBfX2Fsd2F5c19pbmxpbmUgc28gaXQgY2FuIGJlIGNvbXBpbGVkIGF3YXkKKyAqIAl3aGVuIENP
TkZJR19ETUFfRU5HSU5FPW4KKyAqLworc3RhdGljIF9fYWx3YXlzX2lubGluZSB2b2lkCiBkb19h
c3luY194b3Ioc3RydWN0IGRtYV9hc3luY190eF9kZXNjcmlwdG9yICp0eCwgc3RydWN0IGRtYV9k
ZXZpY2UgKmRldmljZSwKIAlzdHJ1Y3QgZG1hX2NoYW4gKmNoYW4sIHN0cnVjdCBwYWdlICpkZXN0
LCBzdHJ1Y3QgcGFnZSAqKnNyY19saXN0LAogCXVuc2lnbmVkIGludCBvZmZzZXQsIHVuc2lnbmVk
IGludCBzcmNfY250LCBzaXplX3QgbGVuLAo=
------=_Part_1007_26710840.1202047850571--
