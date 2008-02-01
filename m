Return-Path: <linux-kernel-owner+w=401wt.eu-S935630AbYBAHnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935630AbYBAHnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935137AbYBAHjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:39:15 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:42950 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758150AbYBAHjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:39:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=YGFnarTYuePAZDLESE9XTy/pYHOpEClqwwU9KkxrB2JvqozSvBlPNCNa4Fc5oeDgFTs/dIlp+3rQkmRNrGCCBBAHJNk68rzc6kJ5cP5saR51NMA+MfFrVJB55dPQZ+PwMSrSHBW+cSpoD3fwJ8twsaTVxrzPNOk/VUOgEKAFgHM=
Message-ID: <3fd7d7a70801312339p2a142096p83ed286c81379728@mail.gmail.com>
Date: Fri, 1 Feb 2008 16:39:07 +0900
From: "Kenichi Okuyama" <kenichi.okuyama@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [patch] NULL pointer check for vma->vm_mm
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_4980_21923991.1201851547127"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_4980_21923991.1201851547127
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Dear all,

I was looking at the ./mm/rmap.c .. I found that, in function
"page_referenced_one()",
   struct mm_struct *mm = vma->vm_mm;
was being refererred without NULL check.

Though I do agree that this works for most of the cases, I thought it
is better to add
BUG_ON() for case of mm being NULL.

attached is the patch for this

thank you in advance for taking your time.
best regards,
-- 
(Kenichi Okuyama)
URL: http://www.dd.iij4u.or.jp/~okuyamak/

------=_Part_4980_21923991.1201851547127
Content-Type: application/octet-stream; name=patch.mm
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fc4ezkog
Content-Disposition: attachment; filename=patch.mm

LS0tIC4vbW0vcm1hcC5jLm9yaWcJMjAwOC0wMi0wMSAxNTozNjo1MC4wMDAwMDAwMDAgKzA5MDAK
KysrIC4vbW0vcm1hcC5jCTIwMDgtMDItMDEgMTU6NDI6NDMuMDAwMDAwMDAwICswOTAwCkBAIC0y
NzYsNiArMjc2LDggQEAgc3RhdGljIGludCBwYWdlX3JlZmVyZW5jZWRfb25lKHN0cnVjdCBwYQog
CXNwaW5sb2NrX3QgKnB0bDsKIAlpbnQgcmVmZXJlbmNlZCA9IDA7CiAKKwlCVUdfT04oKCBtbSA9
PSBOVUxMICkpOworCiAJYWRkcmVzcyA9IHZtYV9hZGRyZXNzKHBhZ2UsIHZtYSk7CiAJaWYgKGFk
ZHJlc3MgPT0gLUVGQVVMVCkKIAkJZ290byBvdXQ7Cg==
------=_Part_4980_21923991.1201851547127--
