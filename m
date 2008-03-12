Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbYCLBBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbYCLBBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 21:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYCLBBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 21:01:40 -0400
Received: from hs-out-0708.google.com ([64.233.178.241]:9521 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYCLBBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 21:01:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=AhaR+n8GOKMj5pfMiD4MD+Jd7rF5dyzZ/KwMMC3NJyZGcFBKvS1G0IoZy7uBQgHeHpXMMZ2cbQgzynj8rKJh+DL2YMo6yNl3ln5VYG8EO8usBlVRjmtKCelF4+SIFGJV7Cc6/4KfG30QZNlo/xZRbKHWhjqzoKVAxFTrt1Ko5SM=
Message-ID: <86802c440803111801m20349386l58a108cec13eb5ee@mail.gmail.com>
Date: Tue, 11 Mar 2008 18:01:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: [PATCH] mm: fix boundary checking in free_bootmem_core
Cc: "kernel list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_4188_30249127.1205283695291"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_4188_30249127.1205283695291
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[PATCH] mm: fix boundary checking in free_bootmem_core

so call it when numa is enabled, we don't know which node have that range.
and make it more robust.

try to trim it to get valid sidx, and eidx.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

------=_Part_4188_30249127.1205283695291
Content-Type: text/x-patch; name=check_boundary_free_bootmem_x.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdp6ty370
Content-Disposition: attachment;
 filename=check_boundary_free_bootmem_x.patch

SW5kZXg6IGxpbnV4LTIuNi9tbS9ib290bWVtLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9y
aWcvbW0vYm9vdG1lbS5jCisrKyBsaW51eC0yLjYvbW0vYm9vdG1lbS5jCkBAIC0xMjUsNiArMTI1
LDcgQEAgc3RhdGljIGludCBfX2luaXQgcmVzZXJ2ZV9ib290bWVtX2NvcmUoYgogCUJVR19PTigh
c2l6ZSk7CiAJQlVHX09OKFBGTl9ET1dOKGFkZHIpID49IGJkYXRhLT5ub2RlX2xvd19wZm4pOwog
CUJVR19PTihQRk5fVVAoYWRkciArIHNpemUpID4gYmRhdGEtPm5vZGVfbG93X3Bmbik7CisJQlVH
X09OKGFkZHIgPCBiZGF0YS0+bm9kZV9ib290X3N0YXJ0KTsKIAogCXNpZHggPSBQRk5fRE9XTihh
ZGRyIC0gYmRhdGEtPm5vZGVfYm9vdF9zdGFydCk7CiAJZWlkeCA9IFBGTl9VUChhZGRyICsgc2l6
ZSAtIGJkYXRhLT5ub2RlX2Jvb3Rfc3RhcnQpOwpAQCAtMTU2LDIxICsxNTcsMzEgQEAgc3RhdGlj
IHZvaWQgX19pbml0IGZyZWVfYm9vdG1lbV9jb3JlKGJvbwogCXVuc2lnbmVkIGxvbmcgc2lkeCwg
ZWlkeDsKIAl1bnNpZ25lZCBsb25nIGk7CiAKKwlCVUdfT04oIXNpemUpOworCisJLyogb3V0IHJh
bmdlICovCisJaWYgKGFkZHIgKyBzaXplIDwgYmRhdGEtPm5vZGVfYm9vdF9zdGFydCB8fAorCQlQ
Rk5fRE9XTihhZGRyKSA+IGJkYXRhLT5ub2RlX2xvd19wZm4pCisJCXJldHVybjsKIAkvKgogCSAq
IHJvdW5kIGRvd24gZW5kIG9mIHVzYWJsZSBtZW0sIHBhcnRpYWxseSBmcmVlIHBhZ2VzIGFyZQog
CSAqIGNvbnNpZGVyZWQgcmVzZXJ2ZWQuCiAJICovCi0JQlVHX09OKCFzaXplKTsKLQlCVUdfT04o
UEZOX0RPV04oYWRkciArIHNpemUpID4gYmRhdGEtPm5vZGVfbG93X3Bmbik7CiAKLQlpZiAoYWRk
ciA8IGJkYXRhLT5sYXN0X3N1Y2Nlc3MpCisJaWYgKGFkZHIgPj0gYmRhdGEtPm5vZGVfYm9vdF9z
dGFydCAmJiBhZGRyIDwgYmRhdGEtPmxhc3Rfc3VjY2VzcykKIAkJYmRhdGEtPmxhc3Rfc3VjY2Vz
cyA9IGFkZHI7CiAKIAkvKgotCSAqIFJvdW5kIHVwIHRoZSBiZWdpbm5pbmcgb2YgdGhlIGFkZHJl
c3MuCisJICogUm91bmQgdXAgdG8gaW5kZXggdG8gdGhlIHJhbmdlLgogCSAqLwotCXNpZHggPSBQ
Rk5fVVAoYWRkcikgLSBQRk5fRE9XTihiZGF0YS0+bm9kZV9ib290X3N0YXJ0KTsKKwlpZiAoUEZO
X1VQKGFkZHIpID4gUEZOX0RPV04oYmRhdGEtPm5vZGVfYm9vdF9zdGFydCkpCisJCXNpZHggPSBQ
Rk5fVVAoYWRkcikgLSBQRk5fRE9XTihiZGF0YS0+bm9kZV9ib290X3N0YXJ0KTsKKwllbHNlCisJ
CXNpZHggPSAwOworCiAJZWlkeCA9IFBGTl9ET1dOKGFkZHIgKyBzaXplIC0gYmRhdGEtPm5vZGVf
Ym9vdF9zdGFydCk7CisJaWYgKGVpZHggPiBiZGF0YS0+bm9kZV9sb3dfcGZuIC0gUEZOX0RPV04o
YmRhdGEtPm5vZGVfYm9vdF9zdGFydCkpCisJCWVpZHggPSBiZGF0YS0+bm9kZV9sb3dfcGZuIC0g
UEZOX0RPV04oYmRhdGEtPm5vZGVfYm9vdF9zdGFydCk7CiAKIAlmb3IgKGkgPSBzaWR4OyBpIDwg
ZWlkeDsgaSsrKSB7CiAJCWlmICh1bmxpa2VseSghdGVzdF9hbmRfY2xlYXJfYml0KGksIGJkYXRh
LT5ub2RlX2Jvb3RtZW1fbWFwKSkpCg==
------=_Part_4188_30249127.1205283695291--
