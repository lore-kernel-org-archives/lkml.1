Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYJGSBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYJGSBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 14:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbYJGSBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 14:01:36 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:44684 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYJGSBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 14:01:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=T2fspnKwM7fnTVh4cFSX6DY/1y/Hv7W2lDQPtf5FhELUDe9M77UObjM4HmdnNPbTxf
         pcWSS7565kIPLOI8DnSTkKBUXtt4bJn0Y0/Muc/WUXm5j/Le1HyZ1pI4NMUu6tgkJdDZ
         8R9GDDG6R1syDWlr7qsYnvNZ1A8F57tQtw0Qs=
Message-ID: <81b0412b0810071101l40b74e82o808cb6998148428c@mail.gmail.com>
Date: Tue, 7 Oct 2008 20:01:33 +0200
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: sdhci: Loads of scary messages during suspend/resume with SD card inserted
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx, linux-pm@lists.linux-foundation.org
In-Reply-To: <200809292000.19489.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_49010_8429751.1223402493805"
References: <200809282146.57960.elendil@planet.nl>
	 <20080929113857.GA17379@srcf.ucam.org>
	 <20080929121142.GA18486@srcf.ucam.org>
	 <200809292000.19489.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_49010_8429751.1223402493805
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/9/29 Frans Pop <elendil@planet.nl>:
> On Monday 29 September 2008, Matthew Garrett wrote:
>> More to the point, how about this one? It should also handle the resume
>> case, but I haven't tested it yet.
>
> Thanks Matthew.
>
> For the second part of the quirk the device name is incorrect. It should
> be r5c832 instead of rl5c832 and the DECLAREs also have the wrong device.

I'm attaching my patch with these corrections.

> After fixing that it compiles correctly and does improve things a lot, but
> there are still remaining issues. I suspect these are probably unrelated
> to the proprietary controller though.

Confirm that for Dell XPS M1330.

> All that was still without having a partition mounted. After resume a vfat
> partition on the card can be mounted successfully.

This works here (Ubuntu 8.04.1, v2.6.27-rc9). It is likely the hald
configuration
on Ubuntu as to why it works:

Oct  7 19:52:34 blimp hald: unmounted /dev/mmcblk0p1 from
'/media/disk' on behalf of uid 0

------=_Part_49010_8429751.1223402493805
Content-Type: text/x-diff; name=fixed-ricoh-mmc-pci-quirk.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fm0u36eg0
Content-Disposition: attachment; filename=fixed-ricoh-mmc-pci-quirk.patch

RnJvbSA2MzVkODEwMjUzNWZiMThlMDcxOTc2NzdhNDI2YWY5MzA5OTQ4YjQ5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IFJpZXNlbiA8cmFhQGJsaW1wLmxvY2FsaG9zdD4KRGF0
ZTogVHVlLCA3IE9jdCAyMDA4IDE5OjQ2OjAxICswMjAwClN1YmplY3Q6IFtQQVRDSF0gRml4IHRo
ZSBwY2kgcXVpcmsgZm9yIFJpY29oIFI1QzgzMiB3aGljaCBkaXNhYmxlcyB0aGUgbW1jIGNvbnRy
b2xsZXIKCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9wY2kvcXVpcmtzLmMgYi9kcml2ZXJzL3BjaS9x
dWlya3MuYwppbmRleCA0NTU3ZmEzLi4wNzM3ZmU5IDEwMDY0NAotLS0gYS9kcml2ZXJzL3BjaS9x
dWlya3MuYworKysgYi9kcml2ZXJzL3BjaS9xdWlya3MuYwpAQCAtMTgzNSw3ICsxODM1LDcgQEAg
REVDTEFSRV9QQ0lfRklYVVBfUkVTVU1FX0VBUkxZKFBDSV9WRU5ET1JfSURfUklDT0gsCiAJCQkg
ICAgICAgUENJX0RFVklDRV9JRF9SSUNPSF9STDVDNDc2LAogCQkJICAgICAgIHF1aXJrX3JpY29o
X3JsNWM0NzZfbW1jX2Rpc2FibGUpOwogCi1zdGF0aWMgdm9pZCBxdWlya19yaWNvaF9ybDVjODMy
X21tY19kaXNhYmxlKHN0cnVjdCBwY2lfZGV2ICpkZXYpCitzdGF0aWMgdm9pZCBxdWlya19yaWNv
aF9yNWM4MzJfbW1jX2Rpc2FibGUoc3RydWN0IHBjaV9kZXYgKmRldikKIHsKIAl1OCBkaXNhYmxl
OwogCXU4IHdyaXRlX2VuYWJsZTsKQEAgLTE4NTIsMTEgKzE4NTIsMTEgQEAgc3RhdGljIHZvaWQg
cXVpcmtfcmljb2hfcmw1YzgzMl9tbWNfZGlzYWJsZShzdHJ1Y3QgcGNpX2RldiAqZGV2KQogfQog
CiBERUNMQVJFX1BDSV9GSVhVUF9IRUFERVIoUENJX1ZFTkRPUl9JRF9SSUNPSCwKLQkJCSBQQ0lf
REVWSUNFX0lEX1JJQ09IX1JMNUM0NzYsCi0JCQkgcXVpcmtfcmljb2hfcmw1YzgzMl9tbWNfZGlz
YWJsZSk7CisJCQkgUENJX0RFVklDRV9JRF9SSUNPSF9SNUM4MzIsCisJCQkgcXVpcmtfcmljb2hf
cjVjODMyX21tY19kaXNhYmxlKTsKIERFQ0xBUkVfUENJX0ZJWFVQX1JFU1VNRV9FQVJMWShQQ0lf
VkVORE9SX0lEX1JJQ09ILAotCQkJICAgICAgIFBDSV9ERVZJQ0VfSURfUklDT0hfUkw1QzQ3NiwK
LQkJCSAgICAgICBxdWlya19yaWNvaF9ybDVjODMyX21tY19kaXNhYmxlKTsKKwkJCSAgICAgICBQ
Q0lfREVWSUNFX0lEX1JJQ09IX1I1QzgzMiwKKwkJCSAgICAgICBxdWlya19yaWNvaF9yNWM4MzJf
bW1jX2Rpc2FibGUpOwogCiAjaWZkZWYgQ09ORklHX1BDSV9NU0kKIC8qIFNvbWUgY2hpcHNldHMg
ZG8gbm90IHN1cHBvcnQgTVNJLiBXZSBjYW5ub3QgZWFzaWx5IHJlbHkgb24gc2V0dGluZwo=
------=_Part_49010_8429751.1223402493805--
