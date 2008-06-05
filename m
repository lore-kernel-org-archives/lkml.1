Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbYFEPEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbYFEPEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYFEPEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:04:33 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9160 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbYFEPEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:04:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:mime-version:content-type;
	b=Isiv7jt+SFsH3Pgh9u0yxWRLY8DxIG7tEFZU67v7KYqoCUWWkjrZ5G1lHfNR3nPpW
	p/XP8OYiF6EVchvDhLBRg==
Message-ID: <4ca0a85e0806050804q4c164105uc386dcae2ccd21d@mail.gmail.com>
Date: Thu, 5 Jun 2008 11:04:21 -0400
From: "Thomas Tuttle" <ttuttle@google.com>
To: mpm@selenic.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] pagemap: Modify add_to_pagemap to use copy_to_user instead of put_user.
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_779_990246.1212678261265"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_779_990246.1212678261265
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

While fiddling with pagemap, I discovered a bug in add_to_pagemap.
When it is copying an entry that is not at the end of the buffer, it
uses put_user to copy a u64 into a char* buffer.  The problem is that
put_user determines how much to copy based on the size of the
*destination*, not the source, so it only copied one byte.  To fix
this, I replaced the call to put_user with a call to copy_to_user, as
is used when copying the last (possibly partial) PFN into the buffer.

------=_Part_779_990246.1212678261265
Content-Type: text/x-patch;
 name=0001-Modified-add_to_pagemap-to-use-copy_to_user-instead.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fh3hbi0r0
Content-Disposition: attachment;
 filename=0001-Modified-add_to_pagemap-to-use-copy_to_user-instead.patch

RnJvbSAzMjQwYmUwZDQ4OWU5MTRiYmI1YTU1OWMyMTQxM2UzOTg4OTkzNGVmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBUaG9tYXMgVHV0dGxlIDx0dHV0dGxlQGdvb2dsZS5jb20+CkRh
dGU6IFRodSwgNSBKdW4gMjAwOCAwOTozNzoyNCAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIE1vZGlm
aWVkIGFkZF90b19wYWdlbWFwIHRvIHVzZSBjb3B5X3RvX3VzZXIgaW5zdGVhZCBvZiBwdXRfdXNl
ci4KIFVzaW5nIHB1dF91c2VyIG9ubHkgY29waWVzIHRoZSBsb3cgYnl0ZSBvZiB0aGUgcGFnZWNv
dW50LCBiZWNhdXNlIHRoZQogZGVzdGluYXRpb24gYnVmZmVyIGlzIGEgY2hhciouCgpTaWduZWQt
b2ZmLWJ5OiBUaG9tYXMgVHV0dGxlIDx0dHV0dGxlQGdvb2dsZS5jb20+Ci0tLQogZnMvcHJvYy90
YXNrX21tdS5jIHwgICAgMiArLQogMSBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbnMoKyksIDEg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvcHJvYy90YXNrX21tdS5jIGIvZnMvcHJvYy90
YXNrX21tdS5jCmluZGV4IDg4NzE3YzAuLjk5MTUyMDIgMTAwNjQ0Ci0tLSBhL2ZzL3Byb2MvdGFz
a19tbXUuYworKysgYi9mcy9wcm9jL3Rhc2tfbW11LmMKQEAgLTUzMSw3ICs1MzEsNyBAQCBzdGF0
aWMgaW50IGFkZF90b19wYWdlbWFwKHVuc2lnbmVkIGxvbmcgYWRkciwgdTY0IHBmbiwKIAkJcmV0
dXJuIFBNX0VORF9PRl9CVUZGRVI7CiAJfQogCi0JaWYgKHB1dF91c2VyKHBmbiwgcG0tPm91dCkp
CisJaWYgKGNvcHlfdG9fdXNlcihwbS0+b3V0LCAmcGZuLCBQTV9FTlRSWV9CWVRFUykpCiAJCXJl
dHVybiAtRUZBVUxUOwogCXBtLT5vdXQgKz0gUE1fRU5UUllfQllURVM7CiAJcmV0dXJuIDA7Ci0t
IAoxLjUuMy42Cgo=
------=_Part_779_990246.1212678261265--
