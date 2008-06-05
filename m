Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbYFEPE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbYFEPE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758816AbYFEPEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:04:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9200 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbYFEPEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:04:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:mime-version:content-type;
	b=vvb7SCtkh5M+bfQdS9zW/65Il54esazEyOhljoZCvEqA40/LetTMheIVMKvI3WTYO
	blMg+5CbK4KmWR4R79IZA==
Message-ID: <4ca0a85e0806050804s798bba46wcb29d2582120bfab@mail.gmail.com>
Date: Thu, 5 Jun 2008 11:04:33 -0400
From: "Thomas Tuttle" <ttuttle@google.com>
To: mpm@selenic.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] pagemap: Change kpagecount to return the map count, not the reference count, of a page.
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_783_29067150.1212678274037"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_783_29067150.1212678274037
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

When trying to use pagemap to calculate the "proportional set size"
[1] of a process, I discovered that there were often references to
pages that could not be discovered by kpagecount.  I changed
kpagecount to return the number of times a page is mapped, rather than
referenced, so kpagecount is more useful for determining how many
processes are using a page.


[1] PSS is the amount of memory used by a process, weighted by 1 / the
number of processes sharing the memory -- so a 128K library shared by
2 processes counts as 64K PSS for each of them.

------=_Part_783_29067150.1212678274037
Content-Type: text/x-patch;
 name=0002-Changed-kpagecount-to-return-the-map-count-not-the.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fh3haq7u0
Content-Disposition: attachment;
 filename=0002-Changed-kpagecount-to-return-the-map-count-not-the.patch

RnJvbSBmZjJlMjg0MmI3NjYyMzIyMDY4ZTU2MDJhZmM4MmQ1YWQyZWU4MjdmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBUaG9tYXMgVHV0dGxlIDx0dHV0dGxlQGdvb2dsZS5jb20+CkRh
dGU6IFRodSwgNSBKdW4gMjAwOCAwOTozOToxMiAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIENoYW5n
ZWQga3BhZ2Vjb3VudCB0byByZXR1cm4gdGhlIG1hcCBjb3VudCwgbm90IHRoZSByZWZlcmVuY2Ug
Y291bnQsIG9mIGEgcGFnZS4KIFRoaXMgZW5zdXJlcyB0aGF0LCBpZiB5b3UgcmVhZCB0aGUgcGFn
ZW1hcCBvZiBldmVyeSBwcm9jZXNzLCBhbmQgdGFsbHkgdGhlCiBudW1iZXIgb2YgcmVmZXJlbmNl
cyB0byBhIHBhZ2UsIGl0IG1hdGNoZXMgd2hhdCBpcyBpbiBrcGFnZWNvdW50LgoKLS0tCiBmcy9w
cm9jL3Byb2NfbWlzYy5jIHwgICAgMiArLQogMSBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvcHJvYy9wcm9jX21pc2MuYyBiL2Zz
L3Byb2MvcHJvY19taXNjLmMKaW5kZXggMzJkYzE0Yy4uNWExNjA5MCAxMDA2NDQKLS0tIGEvZnMv
cHJvYy9wcm9jX21pc2MuYworKysgYi9mcy9wcm9jL3Byb2NfbWlzYy5jCkBAIC03MjYsNyArNzI2
LDcgQEAgc3RhdGljIHNzaXplX3Qga3BhZ2Vjb3VudF9yZWFkKHN0cnVjdCBmaWxlICpmaWxlLCBj
aGFyIF9fdXNlciAqYnVmLAogCQlpZiAoIXBwYWdlKQogCQkJcGNvdW50ID0gMDsKIAkJZWxzZQot
CQkJcGNvdW50ID0gYXRvbWljX3JlYWQoJnBwYWdlLT5fY291bnQpOworCQkJcGNvdW50ID0gcGFn
ZV9tYXBjb3VudChwcGFnZSk7CiAKIAkJaWYgKHB1dF91c2VyKHBjb3VudCwgb3V0KyspKSB7CiAJ
CQlyZXQgPSAtRUZBVUxUOwotLSAKMS41LjMuNgoK
------=_Part_783_29067150.1212678274037--
