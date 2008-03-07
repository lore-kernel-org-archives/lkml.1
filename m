Return-Path: <linux-kernel-owner+w=401wt.eu-S1764423AbYCGCZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764423AbYCGCZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 21:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757253AbYCGCZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 21:25:20 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:56688 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbYCGCZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 21:25:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=WWAywG8Gk74jLBr1euiKIWce8sijWFTbhfq1IdzWdrU6QiN2IWwP7dcDTnfsiz/f+nHgjB9NMVSkR5mZw8hrNecVaB9zYR3HvIUBEzowua2adVedS8sdJYDTSo+s2sLhbs2JfMDky703lqCGpPzqVKgnkb+Op5h74tfprdSi6pc=
Message-ID: <86802c440803061825p5df1cdb7q9655da509ce3ce4a@mail.gmail.com>
Date: Thu, 6 Mar 2008 18:25:16 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86_64: tight online check in setup_per_cpu_areas
Cc: "kernel list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_25101_8801941.1204856716953"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_25101_8801941.1204856716953
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



------=_Part_25101_8801941.1204856716953
Content-Type: text/x-patch; name=x86_64_tight_per_cpu.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdi4l3u70
Content-Disposition: attachment; filename=x86_64_tight_per_cpu.patch

W1BBVENIXSB4ODZfNjQ6IHRpZ2h0IG9ubGluZSBjaGVjayBpbiBzZXR1cF9wZXJfY3B1X2FyZWFz
Cgp3aGVuIG51bWEgZGlzYWJsZWQgZ290IGNvbXBpbGUgd2FybmluZzoKYXJjaC94ODYva2VybmVs
L3NldHVwNjQuYzogSW4gZnVuY3Rpb24g4oCYc2V0dXBfcGVyX2NwdV9hcmVhc+KAmToKYXJjaC94
ODYva2VybmVsL3NldHVwNjQuYzoxNDc6IHdhcm5pbmc6IHRoZSBhZGRyZXNzIG9mIOKAmGNvbnRp
Z19wYWdlX2RhdGHigJkgd2lsbCBhbHdheXMgZXZhbHVhdGUgYXMg4oCYdHJ1ZeKAmQoKaXQgc2Vl
bXMgd2UgbWlzc2VkIGNoZWNraW5nIGlmIHRoZSBub2RlIGlzIG9ubGluZSBiZWZvcmUgd2UgdHJ5
IHRvIHJlZmVyCiBOT0RFX0RBVEEuCnNvIGZpeCBpdAoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBM
dSA8eWhsdS5rZXJuZWxAZ21haWwuY29tPgoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJu
ZWwvc2V0dXA2NC5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2tlcm5l
bC9zZXR1cDY0LmMKKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvc2V0dXA2NC5jCkBAIC0x
NDMsMTQgKzE0MywxNiBAQCB2b2lkIF9faW5pdCBzZXR1cF9wZXJfY3B1X2FyZWFzKHZvaWQpCiAJ
cHJpbnRrKEtFUk5fSU5GTyAiUEVSQ1BVOiBBbGxvY2F0aW5nICVsdSBieXRlcyBvZiBwZXIgY3B1
IGRhdGFcbiIsIHNpemUpOwogCWZvcl9lYWNoX2NwdV9tYXNrIChpLCBjcHVfcG9zc2libGVfbWFw
KSB7CiAJCWNoYXIgKnB0cjsKKyNpZm5kZWYgQ09ORklHX05FRURfTVVMVElQTEVfTk9ERVMKKwkJ
cHRyID0gYWxsb2NfYm9vdG1lbV9wYWdlcyhzaXplKTsKKyNlbHNlCisJCWludCBub2RlID0gZWFy
bHlfY3B1X3RvX25vZGUoaSk7CiAKLQkJaWYgKCFOT0RFX0RBVEEoZWFybHlfY3B1X3RvX25vZGUo
aSkpKSB7Ci0JCQlwcmludGsoImNwdSB3aXRoIG5vIG5vZGUgJWQsIG51bV9vbmxpbmVfbm9kZXMg
JWRcbiIsCi0JCQkgICAgICAgaSwgbnVtX29ubGluZV9ub2RlcygpKTsKKwkJaWYgKCFub2RlX29u
bGluZShub2RlKSB8fCAhTk9ERV9EQVRBKG5vZGUpKQogCQkJcHRyID0gYWxsb2NfYm9vdG1lbV9w
YWdlcyhzaXplKTsKLQkJfSBlbHNlIHsgCi0JCQlwdHIgPSBhbGxvY19ib290bWVtX3BhZ2VzX25v
ZGUoTk9ERV9EQVRBKGVhcmx5X2NwdV90b19ub2RlKGkpKSwgc2l6ZSk7Ci0JCX0KKwkJZWxzZQor
CQkJcHRyID0gYWxsb2NfYm9vdG1lbV9wYWdlc19ub2RlKE5PREVfREFUQShub2RlKSwgc2l6ZSk7
CisjZW5kaWYKIAkJaWYgKCFwdHIpCiAJCQlwYW5pYygiQ2Fubm90IGFsbG9jYXRlIGNwdSBkYXRh
IGZvciBDUFUgJWRcbiIsIGkpOwogCQljcHVfcGRhKGkpLT5kYXRhX29mZnNldCA9IHB0ciAtIF9f
cGVyX2NwdV9zdGFydDsK
------=_Part_25101_8801941.1204856716953--
