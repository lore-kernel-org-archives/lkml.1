Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbXEMFdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbXEMFdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 01:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbXEMFdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 01:33:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:23127 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbXEMFdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 01:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=lJZP414/3yxdlfdnjPBQPyyXkVRBigpHN3lAczKs+ZxIDPiDyJMrjrhQRXRq3sfEjjIKx5DiFlWuI9lhbHj8jPtoHiKCcDNeqH0TeIYohuCAyWyjN23OmRLesBc9R1m14ZVeZn3kSnMiVD90ZgtI9GPBNlLHOjo6pdX2A7+0WTM=
Message-ID: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
Date: Sat, 12 May 2007 22:33:14 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, "Andi Kleen" <ak@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>
Subject: [PATCH]x86_64: build and use GDT on copied compressed kernel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yinghai.lu@sun.com
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_196047_27671147.1179034394061"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_196047_27671147.1179034394061
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

please check the patch.

YH

------=_Part_196047_27671147.1179034394061
Content-Type: text/x-patch; name=bzImage_x86_64_head_gdt.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f1n2zsiz
Content-Disposition: attachment; filename="bzImage_x86_64_head_gdt.patch"

W1BBVENIXXg4Nl82NDogYnVpbGQgYW5kIHVzZSBHRFQgb24gY29waWVkIGNvbXByZXNzZWQga2Vy
bmVsIAoKQnVpbGQgYW5kIHVzZSBHRFQgb24gY29waWVkIGNvbXByZXNzZWQga2VybmVsIHBvc3Rp
b24sIGluc3RlYWQgb2YgdXNpbmcgR0RUIAppbiBkYXRhIHNlZ21lbnQgb2YgbG9hZGVkIGNvbXBy
ZXNzZWQga2VybmVsLiBPdGhlcndpc2UgZGVjb21wcmVzc2luZyAKY29tcHJlc3NlZCBrZXJuZWwg
aW1hZ2UgbGF0ZXIgaW4gNjRiaXQgbG9uZ21vZGUsIHdpbGwgb3ZlcndyaXRlIEdEVC4KIApTaWdu
ZWQtb2ZmLWJ5OiBZaW5naGFpIEx1IDx5aW5naGFpLmx1QHN1bi5jb20+CgpkaWZmIC0tZ2l0IGEv
YXJjaC94ODZfNjQvYm9vdC9jb21wcmVzc2VkL2hlYWQuUyBiL2FyY2gveDg2XzY0L2Jvb3QvY29t
cHJlc3NlZC9oZWFkLlMKaW5kZXggZjlkNTY5Mi4uMWY1YWM3YyAxMDA2NDQKLS0tIGEvYXJjaC94
ODZfNjQvYm9vdC9jb21wcmVzc2VkL2hlYWQuUworKysgYi9hcmNoL3g4Nl82NC9ib290L2NvbXBy
ZXNzZWQvaGVhZC5TCkBAIC05NCwxMCArOTQsMjMgQEAgc3RhcnR1cF8zMjoKICAqIFByZXBhcmUg
Zm9yIGVudGVyaW5nIDY0IGJpdCBtb2RlCiAgKi8KIAorLyoKKyAqIEJ1aWxkIGVhcmx5IEdEVCB0
YWJsZSBvbiBjb3BpZWQgY29tcHJlc3NlZCBrZXJuZWwgaW1hZ2UgcG9zaXRpb24sIFNvIEdEVAor
ICogaXMgbm90IGJlIG92ZXJ3cml0ZW4gd2hlbiBkZWNvbXByZXNzaW5nIHRoZSBjb21wcmVzc2Vk
IGtlcm5lbC4gCisgKi8KKwltb3Z3CSQweDAwMjAsIGdkdCsweDAwKCVlYngpCisJbW92dwkkMHgw
MDAwLCBnZHQrMHgwNiglZWJ4KQorCW1vdmwJJDB4MDAwMDAwMDAsIGdkdCsweDA4KCVlYngpIC8q
IE5VTEwgZGVzY3JpcHRvciAqLworCW1vdmwJJDB4MDAwMDAwMDAsIGdkdCsweDBjKCVlYngpCisJ
bW92bAkkMHgwMDAwZmZmZiwgZ2R0KzB4MTAoJWVieCkgLyogX19LRVJORUxfQ1MgKi8KKwltb3Zs
CSQweDAwYWY5YTAwLCBnZHQrMHgxNCglZWJ4KQorCW1vdmwJJDB4MDAwMGZmZmYsIGdkdCsweDE4
KCVlYngpIC8qIF9fS0VSTkVMX0RTICovCisJbW92bAkkMHgwMGNmOTIwMCwgZ2R0KzB4MWMoJWVi
eCkKKwogCS8qIExvYWQgbmV3IEdEVCB3aXRoIHRoZSA2NGJpdCBzZWdtZW50cyB1c2luZyAzMmJp
dCBkZXNjcmlwdG9yICovCi0JbGVhbAlnZHQoJWVicCksICVlYXgKLQltb3ZsCSVlYXgsIGdkdCsy
KCVlYnApCi0JbGdkdAlnZHQoJWVicCkKKwlsZWFsCWdkdCglZWJ4KSwgJWVheAorCW1vdmwJJWVh
eCwgZ2R0KzIoJWVieCkKKwlsZ2R0CWdkdCglZWJ4KQogCiAJLyogRW5hYmxlIFBBRSBtb2RlICov
CiAJeG9ybAklZWF4LCAlZWF4CkBAIC0xODIsNyArMTk1LDcgQEAgbm9fbG9uZ21vZGU6CiAJICog
aXQgbWF5IGNoYW5nZSBpbiB0aGUgZnV0dXJlLgogCSAqLwogCS5jb2RlNjQKLQkub3JnIDB4MjAw
CisJLm9yZyAweDQwMAogRU5UUlkoc3RhcnR1cF82NCkKIAkvKiBXZSBjb21lIGhlcmUgZWl0aGVy
IGZyb20gc3RhcnR1cF8zMiBvciBkaXJlY3RseSBmcm9tIGEKIAkgKiA2NGJpdCBib290bG9hZGVy
LiAgSWYgd2UgY29tZSBoZXJlIGZyb20gYSBib290bG9hZGVyIHdlIGRlcGVuZCBvbgpAQCAtMjg3
LDE1ICszMDAsNiBAQCByZWxvY2F0ZWQ6CiAgKi8KIAlqbXAJKiVyYnAKIAotCS5kYXRhCi1nZHQ6
Ci0JLndvcmQJZ2R0X2VuZCAtIGdkdAotCS5sb25nCWdkdAotCS53b3JkCTAKLQkucXVhZAkweDAw
MDAwMDAwMDAwMDAwMDAJLyogTlVMTCBkZXNjcmlwdG9yICovCi0JLnF1YWQJMHgwMGFmOWEwMDAw
MDBmZmZmCS8qIF9fS0VSTkVMX0NTICovCi0JLnF1YWQJMHgwMGNmOTIwMDAwMDBmZmZmCS8qIF9f
S0VSTkVMX0RTICovCi1nZHRfZW5kOgogCS5ic3MKIC8qIFN0YWNrIGZvciB1bmNvbXByZXNzaW9u
ICovCiAJLmJhbGlnbiA0CmRpZmYgLS1naXQgYS9hcmNoL3g4Nl82NC9ib290L2NvbXByZXNzZWQv
dm1saW51eC5sZHMgYi9hcmNoL3g4Nl82NC9ib290L2NvbXByZXNzZWQvdm1saW51eC5sZHMKaW5k
ZXggOTRjMTNlNS4uNmUwNDFlZiAxMDA2NDQKLS0tIGEvYXJjaC94ODZfNjQvYm9vdC9jb21wcmVz
c2VkL3ZtbGludXgubGRzCisrKyBiL2FyY2gveDg2XzY0L2Jvb3QvY29tcHJlc3NlZC92bWxpbnV4
LmxkcwpAQCAtMzYsNiArMzYsOCBAQCBTRUNUSU9OUwogCQkqKENPTU1PTikKIAkJLiA9IEFMSUdO
KDgpOwogCQlfZW5kID0gLiA7CisJCWdkdCA9IC4gOworCQkuID0gLiArIDggKiA0OwogCQkuID0g
QUxJR04oNDA5Nik7CiAJCXBndGFibGUgPSAuIDsKIAkJLiA9IC4gKyA0MDk2ICogNjsK
------=_Part_196047_27671147.1179034394061--
