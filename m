Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbYCLRvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbYCLRvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYCLRv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:51:29 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:33184 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbYCLRv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=WhiVmeL7mUtFyl2glLlizkdSyuQRIXt36mU0s0Z39q0OhdHxrtbL9C7A6GrHf2qrKWhsIniv4dXS1nVe9ANQgCh1NF9RSysFkXuA2CGVwJMSpeOs2xGSE3VOIqvcTqi4KgVdbvIf/sPdJxUJm8LRHLsLrUUaZ8CELzW79T4qhag=
Message-ID: <86802c440803121051q20023badsf8e6e0571f4bb92e@mail.gmail.com>
Date: Wed, 12 Mar 2008 10:51:26 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>
Subject: [PATCH] mm: allocate section_map for sparse_init
Cc: "Mel Gorman" <mel@csn.ul.ie>, "Christoph Lameter" <clameter@sgi.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Andy Whitcroft" <apw@shadowen.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_7440_4611324.1205344286754"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_7440_4611324.1205344286754
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[PATCH] mm: allocate section_map for sparse_init

allocate section_map in bootmem instead of using __initdata.

need to apply it after
        [PATCH] mm: fix boundary checking in free_bootmem_core
        [PATCH] mm: make mem_map allocation continuous.


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

------=_Part_7440_4611324.1205344286754
Content-Type: text/x-patch; name=vmemmap_3.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdq6vno80
Content-Disposition: attachment; filename=vmemmap_3.patch

SW5kZXg6IGxpbnV4LTIuNi9tbS9zcGFyc2UuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3Jp
Zy9tbS9zcGFyc2UuYworKysgbGludXgtMi42L21tL3NwYXJzZS5jCkBAIC0yODUsOCArMjg1LDYg
QEAgc3RydWN0IHBhZ2UgX19pbml0ICpzcGFyc2VfZWFybHlfbWVtX21hcAogCXJldHVybiBOVUxM
OwogfQogCi0vKiBzZWN0aW9uX21hcCBwb2ludGVyIGFycmF5IGlzIDY0ayAqLwotc3RhdGljIF9f
aW5pdGRhdGEgc3RydWN0IHBhZ2UgKnNlY3Rpb25fbWFwW05SX01FTV9TRUNUSU9OU107CiAvKgog
ICogQWxsb2NhdGUgdGhlIGFjY3VtdWxhdGVkIG5vbi1saW5lYXIgc2VjdGlvbnMsIGFsbG9jYXRl
IGEgbWVtX21hcAogICogZm9yIGVhY2ggYW5kIHJlY29yZCB0aGUgcGh5c2ljYWwgdG8gc2VjdGlv
biBtYXBwaW5nLgpAQCAtMjk2LDYgKzI5NCw5IEBAIHZvaWQgX19pbml0IHNwYXJzZV9pbml0KHZv
aWQpCiAJdW5zaWduZWQgbG9uZyBwbnVtOwogCXN0cnVjdCBwYWdlICptYXA7CiAJdW5zaWduZWQg
bG9uZyAqdXNlbWFwOworCXN0cnVjdCBwYWdlICoqc2VjdGlvbl9tYXA7CisJaW50IHNpemU7CisJ
aW50IG5vZGU7CiAKIAkvKgogCSAqIG1hcCBpcyB1c2luZyBiaWcgcGFnZSAoYWthIDJNIGluIHg4
NiA2NCBiaXQpCkBAIC0zMDUsMTMgKzMwNiwxNyBAQCB2b2lkIF9faW5pdCBzcGFyc2VfaW5pdCh2
b2lkKQogCSAqIHRoZW4gaW4gYmlnIHN5c3RlbSwgdGhlIG1lbW1vcnkgd2lsbCBoYXZlIGEgbG90
IGhvbGUuLi4KIAkgKiBoZXJlIHRyeSB0byBhbGxvY2F0ZSAyTSBwYWdlcyBjb250aW5vdXNseS4K
IAkgKi8KKwlzaXplID0gc2l6ZW9mKHN0cnVjdCBwYWdlICopICogTlJfTUVNX1NFQ1RJT05TOwor
CXNlY3Rpb25fbWFwID0gYWxsb2NfYm9vdG1lbShzaXplKTsKKwlpZiAoIXNlY3Rpb25fbWFwKQor
CQlwYW5pYygiY2FuIG5vdCBhbGxvY2F0ZSBzZWN0aW9uX21hcFxuIik7CisKIAlmb3IgKHBudW0g
PSAwOyBwbnVtIDwgTlJfTUVNX1NFQ1RJT05TOyBwbnVtKyspIHsKIAkJaWYgKCFwcmVzZW50X3Nl
Y3Rpb25fbnIocG51bSkpCiAJCQljb250aW51ZTsKIAkJc2VjdGlvbl9tYXBbcG51bV0gPSBzcGFy
c2VfZWFybHlfbWVtX21hcF9hbGxvYyhwbnVtKTsKIAl9CiAKLQogCWZvciAocG51bSA9IDA7IHBu
dW0gPCBOUl9NRU1fU0VDVElPTlM7IHBudW0rKykgewogCQlpZiAoIXByZXNlbnRfc2VjdGlvbl9u
cihwbnVtKSkKIAkJCWNvbnRpbnVlOwpAQCAtMzI3LDYgKzMzMiw5IEBAIHZvaWQgX19pbml0IHNw
YXJzZV9pbml0KHZvaWQpCiAJCXNwYXJzZV9pbml0X29uZV9zZWN0aW9uKF9fbnJfdG9fc2VjdGlv
bihwbnVtKSwgcG51bSwgbWFwLAogCQkJCQkJCQl1c2VtYXApOwogCX0KKworCWZvcl9lYWNoX29u
bGluZV9ub2RlKG5vZGUpCisJCWZyZWVfYm9vdG1lbV9ub2RlKE5PREVfREFUQShub2RlKSwgX19w
YShzZWN0aW9uX21hcCksIHNpemUpOwogfQogCiAjaWZkZWYgQ09ORklHX01FTU9SWV9IT1RQTFVH
Cg==
------=_Part_7440_4611324.1205344286754--
