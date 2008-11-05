Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbYKEJwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbYKEJwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYKEJwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:52:24 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:2694 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbYKEJwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:52:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=O5a5W4uw36bE9UipPQVM3DatDFEy0FWO2So06c3cggDa+O9vOan152BXdPt6XpJkDa
         IFxPtMikAStZeFMm58JTN7DjKNfTI+LfqlltHUxoePgHIh/tB803nL5UMK7+iIGvTksq
         F1T+NJN5lnCjkfhK5aOyqtfD5bnkFb4IliwGQ=
Message-ID: <49116CD1.7090907@gmail.com>
Date: Wed, 05 Nov 2008 11:52:17 +0200
From: Lior Dotan <liodot@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>, gregkh@suse.de
CC: linux-kernel@vger.kernel.org, charrer@alacritech.com
Subject: Re: [STAGING] slicoss - use kzalloc
References: <491077E3.4010702@gmail.com> <4910C63F.7040309@gmail.com> <491166F5.7030102@gmail.com> <491168DC.6070508@gmail.com>
In-Reply-To: <491168DC.6070508@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050300090801050700050906"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050300090801050700050906
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> On 11/05/2008 10:27 AM, Lior Dotan wrote:
>> This patch uses kzalloc() where really applicable.
> 
> ack this, but there is another problem.
> 
> sizeof(struct physcard *) is wrong size for that allocation, care to send a fix
> for this (and revice the rest of allocations)? I wonder how this could work with
Fix attached. I only found two other places with the same problem.

> SLAB_DEBUG on, maybe nobody tried...
AFAIK there aren't a lot of testers for this drivers so the few that 
does probably didn't try it.



Fix sizeof to use the right type

Signed-off-by: Lior Dotan <liodot@gmail.com>

--------------050300090801050700050906
Content-Type: text/plain;
 name="slicoss-fix-sizeof.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="slicoss-fix-sizeof.patch"

LS0tIGIvZHJpdmVycy9zdGFnaW5nL3NsaWNvc3Mvc2xpY29zcy5jCTIwMDgtMTEtMDUgMTE6
Mzk6NDIuMDE3NzkxMDg4ICswMjAwCisrKyBhL2RyaXZlcnMvc3RhZ2luZy9zbGljb3NzL3Ns
aWNvc3MuYwkyMDA4LTExLTA1IDExOjQ4OjE2LjIzNzgwODk5NiArMDIwMApAQCAtMzIzLDcg
KzMyMyw3IEBAIHN0YXRpYyB2b2lkIHNsaWNfaW5pdF9hZGFwdGVyKHN0cnVjdCBuZXQKIAlp
bmRleCwgcHNsaWNfaGFuZGxlLCBhZGFwdGVyLT5wZnJlZV9zbGljX2hhbmRsZXMsIHBzbGlj
X2hhbmRsZS0+bmV4dCk7Ki8KIAlhZGFwdGVyLT5wc2htZW0gPSAoc3RydWN0IHNsaWNfc2ht
ZW0gKikKIAkJCQkJcGNpX2FsbG9jX2NvbnNpc3RlbnQoYWRhcHRlci0+cGNpZGV2LAotCQkJ
CQlzaXplb2Yoc3RydWN0IHNsaWNfc2htZW0gKiksCisJCQkJCXNpemVvZihzdHJ1Y3Qgc2xp
Y19zaG1lbSksCiAJCQkJCSZhZGFwdGVyLT4KIAkJCQkJcGh5c19zaG1lbSk7CiAvKgpAQCAt
MTQzMiw3ICsxNDMyLDcgQEAgc3RhdGljIHZvaWQgc2xpY19pbml0X2NsZWFudXAoc3RydWN0
IGFkYQogCQlEQkdfTVNHKCJhZGFwdGVyWyVwXSBwb3J0ICVkIHBzaG1lbVslcF0gRnJlZVNo
bWVtICIsCiAJCQlhZGFwdGVyLCBhZGFwdGVyLT5wb3J0LCAodm9pZCAqKSBhZGFwdGVyLT5w
c2htZW0pOwogCQlwY2lfZnJlZV9jb25zaXN0ZW50KGFkYXB0ZXItPnBjaWRldiwKLQkJCQkg
ICAgc2l6ZW9mKHN0cnVjdCBzbGljX3NobWVtICopLAorCQkJCSAgICBzaXplb2Yoc3RydWN0
IHNsaWNfc2htZW0pLAogCQkJCSAgICBhZGFwdGVyLT5wc2htZW0sIGFkYXB0ZXItPnBoeXNf
c2htZW0pOwogCQlhZGFwdGVyLT5wc2htZW0gPSBOVUxMOwogCQlhZGFwdGVyLT5waHlzX3No
bWVtID0gKGRtYV9hZGRyX3QpIE5VTEw7CkBAIC0yODMzLDcgKzI4MzMsNyBAQCBzdGF0aWMg
dTMyIHNsaWNfY2FyZF9sb2NhdGUoc3RydWN0IGFkYXB0CiAJfQogCWlmICghcGh5c2NhcmQp
IHsKIAkJLyogbm8gc3RydWN0dXJlIGFsbG9jYXRlZCBmb3IgdGhpcyBwaHlzaWNhbCBjYXJk
IHlldCAqLwotCQlwaHlzY2FyZCA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBwaHlzY2FyZCAq
KSwgR0ZQX0FUT01JQyk7CisJCXBoeXNjYXJkID0ga3phbGxvYyhzaXplb2Yoc3RydWN0IHBo
eXNjYXJkKSwgR0ZQX0FUT01JQyk7CiAJCUFTU0VSVChwaHlzY2FyZCk7CiAKIAkJREJHX01T
Rwo=
--------------050300090801050700050906--
