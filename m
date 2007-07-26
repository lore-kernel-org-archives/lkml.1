Return-Path: <linux-kernel-owner+w=401wt.eu-S936764AbXGZUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936764AbXGZUQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936091AbXGZUPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:15:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:60810 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935884AbXGZUPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:15:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=Xm7Xg6lJvYKUdwfuHeuuXDxdC0D5no2WVuBkGaOj4xaT+0Sh9wGYNdhPTXrS9n4dm9AKeAKhfZhYRvnQ5NTsn43e1n3gHNKMazi2+gwi5WgSPhnMtmpu2SBVqIROa8xnPnibjDBH6rVw56YMbGouGk2H51k3BqMAutI8dp2eRFw=
Message-ID: <86802c440707261315w238d8cf0l1a4e7414fb2de58f@mail.gmail.com>
Date: Thu, 26 Jul 2007 13:15:44 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: [PATCH 02/05] x86_64: use core id bits for apicid_to_node initialization
Cc: linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_205828_21926551.1185480944890"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_205828_21926551.1185480944890
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



------=_Part_205828_21926551.1185480944890
Content-Type: text/x-patch; name=apicid_to_node_2.diff; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4losf10
Content-Disposition: attachment; filename="apicid_to_node_2.diff"

W1BBVENIIDAyLzA1XSB4ODZfNjQ6IHVzZSBjb3JlIGlkIGJpdHMgZm9yIGFwaWNpZF90b19ub2Rl
IGluaXRpYWxpemF0aW9uCgpXZSBzaG91ZCB1c2UgY29yZSBpZCBiaXRzIGluc3RlYWQgb2YgbWF4
IGNvcmVzLCBpbiBjYXNlIGxhdGVyIHdpdGggQU1ECmRvd25jb3JlcyBRdWFkIGNvcmUgT3B0ZXJv
bi4KClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlobHUua2VybmVsQGdtYWlsLmNvbT4KCmRp
ZmYgLS1naXQgYS9hcmNoL3g4Nl82NC9tbS9rOHRvcG9sb2d5LmMgYi9hcmNoL3g4Nl82NC9tbS9r
OHRvcG9sb2d5LmMKaW5kZXggYTk2MDA2Zi4uN2NiZDU4YSAxMDA2NDQKLS0tIGEvYXJjaC94ODZf
NjQvbW0vazh0b3BvbG9neS5jCisrKyBiL2FyY2gveDg2XzY0L21tL2s4dG9wb2xvZ3kuYwpAQCAt
NDQsMTIgKzQ0LDE0IEBAIGludCBfX2luaXQgazhfc2Nhbl9ub2Rlcyh1bnNpZ25lZCBsb25nIHN0
YXJ0LCB1bnNpZ25lZCBsb25nIGVuZCkKIHsgCiAJdW5zaWduZWQgbG9uZyBwcmV2YmFzZTsKIAlz
dHJ1Y3QgYm9vdG5vZGUgbm9kZXNbOF07Ci0JaW50IG5vZGVpZCwgaSwgaiwgbmI7CisJaW50IG5v
ZGVpZCwgaSwgbmI7CiAJdW5zaWduZWQgY2hhciBub2RlaWRzWzhdOwogCWludCBmb3VuZCA9IDA7
CiAJdTMyIHJlZzsKIAl1bnNpZ25lZCBudW1ub2RlczsKLQl1bnNpZ25lZCBudW1fY29yZXM7CisJ
dW5zaWduZWQgY29yZXM7CisJdW5zaWduZWQgYml0czsKKwlpbnQgajsKIAogCWlmICghZWFybHlf
cGNpX2FsbG93ZWQoKSkKIAkJcmV0dXJuIC0xOwpAQCAtNjAsOSArNjIsNiBAQCBpbnQgX19pbml0
IGs4X3NjYW5fbm9kZXModW5zaWduZWQgbG9uZyBzdGFydCwgdW5zaWduZWQgbG9uZyBlbmQpCiAK
IAlwcmludGsoS0VSTl9JTkZPICJTY2FubmluZyBOVU1BIHRvcG9sb2d5IGluIE5vcnRoYnJpZGdl
ICVkXG4iLCBuYik7IAogCi0JbnVtX2NvcmVzID0gKGNwdWlkX2VjeCgweDgwMDAwMDA4KSAmIDB4
ZmYpICsgMTsKLQlwcmludGsoS0VSTl9JTkZPICJDUFUgaGFzICVkIG51bV9jb3Jlc1xuIiwgbnVt
X2NvcmVzKTsKLQogCXJlZyA9IHJlYWRfcGNpX2NvbmZpZygwLCBuYiwgMCwgMHg2MCk7IAogCW51
bW5vZGVzID0gKChyZWcgPj4gNCkgJiAweEYpICsgMTsKIAlpZiAobnVtbm9kZXMgPD0gMSkKQEAg
LTE2OCwxMSArMTY3LDE1IEBAIGludCBfX2luaXQgazhfc2Nhbl9ub2Rlcyh1bnNpZ25lZCBsb25n
IHN0YXJ0LCB1bnNpZ25lZCBsb25nIGVuZCkKIAl9IAogCXByaW50ayhLRVJOX0lORk8gIlVzaW5n
IG5vZGUgaGFzaCBzaGlmdCBvZiAlZFxuIiwgbWVtbm9kZV9zaGlmdCk7IAogCisJLyogdXNlIHRo
ZSBjb3JlaWQgYml0cyBmcm9tIGVhcmx5X2lkZW50aWZ5X2NwdSAqLworCWJpdHMgPSBib290X2Nw
dV9kYXRhLng4Nl9jb3JlaWRfYml0czsKKwljb3JlcyA9ICgxPDxiaXRzKTsKKwogCWZvciAoaSA9
IDA7IGkgPCA4OyBpKyspIHsKIAkJaWYgKG5vZGVzW2ldLnN0YXJ0ICE9IG5vZGVzW2ldLmVuZCkg
eyAKIAkJCW5vZGVpZCA9IG5vZGVpZHNbaV07Ci0JCQlmb3IgKGogPSAwOyBqIDwgbnVtX2NvcmVz
OyBqKyspCi0JCQkJYXBpY2lkX3RvX25vZGVbKG5vZGVpZCAqIG51bV9jb3JlcykgKyBqXSA9IGk7
CisJCQlmb3IgKGogPSAwOyBqIDwgY29yZXM7IGorKykKKwkJCQlhcGljaWRfdG9fbm9kZVsobm9k
ZWlkIDw8IGJpdHMpICsgal0gPSBpOwogCQkJc2V0dXBfbm9kZV9ib290bWVtKGksIG5vZGVzW2ld
LnN0YXJ0LCBub2Rlc1tpXS5lbmQpOyAKIAkJfSAKIAl9Cg==
------=_Part_205828_21926551.1185480944890--
