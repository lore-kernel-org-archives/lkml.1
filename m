Return-Path: <linux-kernel-owner+w=401wt.eu-S1761464AbXIUSNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464AbXIUSNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757175AbXIUSM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:12:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:1169 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbXIUSM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:12:56 -0400
Message-ID: <e6c711510709211112v3123e792g6b2ba1f3057afbd0@mail.gmail.com>
Date: Fri, 21 Sep 2007 11:12:52 -0700
From: "Ed Swierk" <eswierk@arastra.com>
To: "Ayaz Abdulla" <aabdulla@nvidia.com>, netdev@vger.kernel.org
Subject: [updated PATCH] forcedeth: power down phy when interface is down
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46F1D83B.5070100@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_10937_27058755.1190398372090"
References: <e6c711510709180958j41265e87kd5126b7d5e832c0e@mail.gmail.com>
	 <46F1D83B.5070100@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_10937_27058755.1190398372090
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 9/19/07, Ayaz Abdulla <aabdulla@nvidia.com> wrote:
> It seems that you are powering down the phy even if WOL is enabled.

Right; I've updated the patch to skip powering down the phy when wol is enabled.

> Secondly, can you powerdown the phy at the same time you start
> performing autoneg restart?

This seems to work fine with a BCM5461S phy; it would be worth testing
with other phys to be sure.

--Ed

------=_Part_10937_27058755.1190398372090
Content-Type: application/octet-stream;
 name="forcedeth-phy-power-down.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="forcedeth-phy-power-down.patch"
X-Attachment-Id: f_f6v0cjei

QnJpbmcgdGhlIHBoeXNpY2FsIGxpbmsgZG93biB3aGVuIHRoZSBpbnRlcmZhY2UgaXMgZG93biBi
eSBwbGFjaW5nIHRoZSBQSFkKaW4gcG93ZXItZG93biBzdGF0ZSwgdW5sZXNzIFdPTCBpcyBlbmFi
bGVkLiAgVGhpcyBtaXJyb3JzIHRoZSBiZWhhdmlvciBvZgpvdGhlciBkcml2ZXJzIGluY2x1ZGlu
ZyBlMTAwMCBhbmQgdGczLgoKU2lnbmVkLW9mZi1ieTogRWQgU3dpZXJrIDxlc3dpZXJrQGFyYXN0
cmEuY29tPgoKSW5kZXg6IGxpbnV4LTIuNi4yMi4xL2RyaXZlcnMvbmV0L2ZvcmNlZGV0aC5jCj09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0KLS0tIGxpbnV4LTIuNi4yMi4xLm9yaWcvZHJpdmVycy9uZXQvZm9yY2VkZXRoLmMK
KysrIGxpbnV4LTIuNi4yMi4xL2RyaXZlcnMvbmV0L2ZvcmNlZGV0aC5jCkBAIC0xMTIsNiArMTEy
LDcgQEAKICAqCTAuNTg6IDMwIE9jdCAyMDA2OiBBZGRlZCBzdXBwb3J0IGZvciBzaWRlYmFuZCBt
YW5hZ2VtZW50IHVuaXQuCiAgKgkwLjU5OiAzMCBPY3QgMjAwNjogQWRkZWQgc3VwcG9ydCBmb3Ig
cmVjb3ZlcmFibGUgZXJyb3IuCiAgKgkwLjYwOiAyMCBKYW4gMjAwNzogQ29kZSBvcHRpbWl6YXRp
b25zIGZvciByaW5ncywgcnggJiB0eCBkYXRhIHBhdGhzLCBhbmQgc3RhdHMuCisgKgkwLjYxOiAy
MSBTZXAgMjAwNzogUG93ZXIgZG93biBwaHkgd2hlbiBpbnRlcmZhY2UgZG93biBhbmQgd29sIGRp
c2FibGVkLgogICoKICAqIEtub3duIGJ1Z3M6CiAgKiBXZSBzdXNwZWN0IHRoYXQgb24gc29tZSBo
YXJkd2FyZSBubyBUWCBkb25lIGludGVycnVwdHMgYXJlIGdlbmVyYXRlZC4KQEAgLTEyOCw3ICsx
MjksNyBAQAogI2Vsc2UKICNkZWZpbmUgRFJJVkVSTkFQSQogI2VuZGlmCi0jZGVmaW5lIEZPUkNF
REVUSF9WRVJTSU9OCQkiMC42MCIKKyNkZWZpbmUgRk9SQ0VERVRIX1ZFUlNJT04JCSIwLjYxIgog
I2RlZmluZSBEUlZfTkFNRQkJCSJmb3JjZWRldGgiCiAKICNpbmNsdWRlIDxsaW51eC9tb2R1bGUu
aD4KQEAgLTExNzAsOSArMTE3MSw5IEBAIHN0YXRpYyBpbnQgcGh5X2luaXQoc3RydWN0IG5ldF9k
ZXZpY2UgKmQKIAkvKiBzb21lIHBoeXMgY2xlYXIgb3V0IHBhdXNlIGFkdmVydGlzbWVudCBvbiBy
ZXNldCwgc2V0IGl0IGJhY2sgKi8KIAltaWlfcncoZGV2LCBucC0+cGh5YWRkciwgTUlJX0FEVkVS
VElTRSwgcmVnKTsKIAotCS8qIHJlc3RhcnQgYXV0byBuZWdvdGlhdGlvbiAqLworCS8qIHJlc3Rh
cnQgYXV0byBuZWdvdGlhdGlvbiwgcG93ZXIgZG93biBwaHkgKi8KIAltaWlfY29udHJvbCA9IG1p
aV9ydyhkZXYsIG5wLT5waHlhZGRyLCBNSUlfQk1DUiwgTUlJX1JFQUQpOwotCW1paV9jb250cm9s
IHw9IChCTUNSX0FOUkVTVEFSVCB8IEJNQ1JfQU5FTkFCTEUpOworCW1paV9jb250cm9sIHw9IChC
TUNSX0FOUkVTVEFSVCB8IEJNQ1JfQU5FTkFCTEUgfCBCTUNSX1BET1dOKTsKIAlpZiAobWlpX3J3
KGRldiwgbnAtPnBoeWFkZHIsIE1JSV9CTUNSLCBtaWlfY29udHJvbCkpIHsKIAkJcmV0dXJuIFBI
WV9FUlJPUjsKIAl9CkBAIC00Njk0LDYgKzQ2OTUsMTAgQEAgc3RhdGljIGludCBudl9vcGVuKHN0
cnVjdCBuZXRfZGV2aWNlICpkZQogCiAJZHByaW50ayhLRVJOX0RFQlVHICJudl9vcGVuOiBiZWdp
blxuIik7CiAKKwkvKiBwb3dlciB1cCBwaHkgKi8KKwltaWlfcncoZGV2LCBucC0+cGh5YWRkciwg
TUlJX0JNQ1IsCisJICAgICAgIG1paV9ydyhkZXYsIG5wLT5waHlhZGRyLCBNSUlfQk1DUiwgTUlJ
X1JFQUQpICYgfkJNQ1JfUERPV04pOworCiAJLyogZXJhc2UgcHJldmlvdXMgbWlzY29uZmlndXJh
dGlvbiAqLwogCWlmIChucC0+ZHJpdmVyX2RhdGEgJiBERVZfSEFTX1BPV0VSX0NOVFJMKQogCQlu
dl9tYWNfcmVzZXQoZGV2KTsKQEAgLTQ4NzIsNiArNDg3NywxMCBAQCBzdGF0aWMgaW50IG52X2Ns
b3NlKHN0cnVjdCBuZXRfZGV2aWNlICpkCiAJaWYgKG5wLT53b2xlbmFibGVkKSB7CiAJCXdyaXRl
bChOVlJFR19QRkZfQUxXQVlTfE5WUkVHX1BGRl9NWUFERFIsIGJhc2UgKyBOdlJlZ1BhY2tldEZp
bHRlckZsYWdzKTsKIAkJbnZfc3RhcnRfcngoZGV2KTsKKwl9IGVsc2UgeworCQkvKiBwb3dlciBk
b3duIHBoeSAqLworCQltaWlfcncoZGV2LCBucC0+cGh5YWRkciwgTUlJX0JNQ1IsCisJCSAgICAg
ICBtaWlfcncoZGV2LCBucC0+cGh5YWRkciwgTUlJX0JNQ1IsIE1JSV9SRUFEKSB8IEJNQ1JfUERP
V04pOwogCX0KIAogCS8qIEZJWE1FOiBwb3dlciBkb3duIG5pYyAqLwo=
------=_Part_10937_27058755.1190398372090--
