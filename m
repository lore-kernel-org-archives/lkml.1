Return-Path: <linux-kernel-owner+w=401wt.eu-S1759617AbYBOTR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617AbYBOTR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYBOTRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:17:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:23208 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbYBOTRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:17:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:references:x-google-sender-auth;
        b=ipUVC+g7f4cADjOkpUTFrryqzjzcYzpxw+83HiXI8/z7fl5VUk7u2kV/JFMk+rQrU7YiOQwzhSpHijrQhsAHI5agiU3X7Kol6bgFqmxlyhKXDWCyej1PMrEtuAzLC5WPNzRje/R15zrsoJsznHe3GfM71KT/3C2cnOg+g+c/+L0=
Message-ID: <e9c3a7c20802151117i4e8a3f1bq7be1e94433702fbf@mail.gmail.com>
Date: Fri, 15 Feb 2008 12:17:43 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Laurent CORBES" <laurent.corbes@smartjog.com>
Subject: Re: [BUG] OOPS 2.6.24.2 raid5 write with ioatdma
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Shannon Nelson" <shannon.nelson@intel.com>, maciej.sosnowski@intel.com
In-Reply-To: <20080215171905.2e5c6bee@smartjog.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_4752_2546834.1203103063267"
References: <20080215171905.2e5c6bee@smartjog.com>
X-Google-Sender-Auth: cf1b2cc0e5ea1b7c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_4752_2546834.1203103063267
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Feb 15, 2008 at 9:19 AM, Laurent CORBES
<laurent.corbes@smartjog.com> wrote:
> Hi all,
>
>  I got a raid5 oops when trying to write on a raid 5 array, with ioatdma loaded
>  and without DCA activated in bios:
>

At first glance I believe the attached patch may fix the issue, I'll
try to reproduce this locally.

Regards,
Dan

------=_Part_4752_2546834.1203103063267
Content-Type: text/x-patch; name=ioat-init-ack.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fcp4ebul0
Content-Disposition: attachment; filename=ioat-init-ack.patch

aW9hdDogZml4ICdhY2snIGhhbmRsaW5nLCBkcml2ZXIgbXVzdCBlbnN1cmUgdGhhdCAnYWNrJyBp
cyB6ZXJvCgpGcm9tOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4KCklu
aXRpYWxpemUgJ2FjaycgdG8gemVybyBpbiBjYXNlIHRoZSBkZXNjcmlwdG9yIGhhcyBiZWVuIHJl
Y3ljbGVkLgoKU2lnbmVkLW9mZi1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRl
bC5jb20+Ci0tLQoKIGRyaXZlcnMvZG1hL2lvYXRfZG1hLmMgfCAgICAyICsrCiAxIGZpbGVzIGNo
YW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9kbWEvaW9hdF9kbWEuYyBiL2RyaXZlcnMvZG1hL2lvYXRfZG1hLmMKaW5kZXggNDVlN2I0
Ni4uOGNmNTQyYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9kbWEvaW9hdF9kbWEuYworKysgYi9kcml2
ZXJzL2RtYS9pb2F0X2RtYS5jCkBAIC03MjYsNiArNzI2LDcgQEAgc3RhdGljIHN0cnVjdCBkbWFf
YXN5bmNfdHhfZGVzY3JpcHRvciAqaW9hdDFfZG1hX3ByZXBfbWVtY3B5KAogCiAJaWYgKG5ldykg
ewogCQluZXctPmxlbiA9IGxlbjsKKwkJbmV3LT5hc3luY190eC5hY2sgPSAwOwogCQlyZXR1cm4g
Jm5ldy0+YXN5bmNfdHg7CiAJfSBlbHNlCiAJCXJldHVybiBOVUxMOwpAQCAtNzQ5LDYgKzc1MCw3
IEBAIHN0YXRpYyBzdHJ1Y3QgZG1hX2FzeW5jX3R4X2Rlc2NyaXB0b3IgKmlvYXQyX2RtYV9wcmVw
X21lbWNweSgKIAogCWlmIChuZXcpIHsKIAkJbmV3LT5sZW4gPSBsZW47CisJCW5ldy0+YXN5bmNf
dHguYWNrID0gMDsKIAkJcmV0dXJuICZuZXctPmFzeW5jX3R4OwogCX0gZWxzZQogCQlyZXR1cm4g
TlVMTDsK
------=_Part_4752_2546834.1203103063267--
