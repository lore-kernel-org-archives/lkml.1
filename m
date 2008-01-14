Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbYANGjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbYANGjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 01:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYANGi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 01:38:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:37162 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYANGi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 01:38:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=arhCAQNzGDjSDEynBr/EK3n8+Si/6Pm3FKJACaU3d+8mmkgcpEturK3oxA8egFpgPcpXei3CzYXmIdNiDsfubmMyW/O2DpoBPEPr2dQb67f5N1FRJj0R8ZxUme9DuXkg0sAmMxu5OlHOfKNBUgYuDFqZzXcWOqghnWyITt4wW48=
Message-ID: <aa79d98a0801132238o72266a91p78ae3a0c1476607c@mail.gmail.com>
Date: Mon, 14 Jan 2008 09:38:57 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH] driver: ip27-rtc - convert ioctl to unlocked_ioctl
Cc: "Paul Gortmaker" <p_gortmaker@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>, "Andi Kleen" <ak@suse.de>,
       "Alexey Dobriyan" <adobriyan@gmail.com>
In-Reply-To: <aa79d98a0801131332w45d6e0e9r13e96b69e7e1b70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_9919_10320393.1200292737101"
References: <20080113203223.GA6723@cvg> <478A8131.9050500@gmail.com>
	 <478A82AD.3070904@gmail.com>
	 <aa79d98a0801131332w45d6e0e9r13e96b69e7e1b70@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_9919_10320393.1200292737101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch converts ioctl call to unlocked_ioctl form. It's possible
due to rtl_lock spinlock protection.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
The patch is *not* tested but the patch does not bring _much_ changes
so it wouldn't break the compilation procedure.

If there is problem with attachment - i could send it as inline
form today evening.

Andi, Jiri, Alexey the only thing I do complain about -
is time set/read from several user threads that uses same
(duplicated) file descriptor. Could there be useless thread
spins instead of sleep (in case if this unlocked_ioctl were
protected by mutex)?

------=_Part_9919_10320393.1200292737101
Content-Type: application/octet-stream; name=ip27-rtc-unlocked-ioctl.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fbelsf3k0
Content-Disposition: attachment; filename=ip27-rtc-unlocked-ioctl.patch

IGRyaXZlcnMvY2hhci9pcDI3LXJ0Yy5jIHwgICAgOSArKysrLS0tLS0KIDEgZmlsZXMgY2hhbmdl
ZCwgNCBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
Y2hhci9pcDI3LXJ0Yy5jIGIvZHJpdmVycy9jaGFyL2lwMjctcnRjLmMKaW5kZXggOTMyMjY0YS4u
ODZlNjUzOCAxMDA2NDQKLS0tIGEvZHJpdmVycy9jaGFyL2lwMjctcnRjLmMKKysrIGIvZHJpdmVy
cy9jaGFyL2lwMjctcnRjLmMKQEAgLTQ2LDggKzQ2LDggQEAKICNpbmNsdWRlIDxhc20vc24vc24w
L2h1Yi5oPgogI2luY2x1ZGUgPGFzbS9zbi9zbl9wcml2YXRlLmg+CiAKLXN0YXRpYyBpbnQgcnRj
X2lvY3RsKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlLAotCQkgICAgIHVu
c2lnbmVkIGludCBjbWQsIHVuc2lnbmVkIGxvbmcgYXJnKTsKK3N0YXRpYyBsb25nIHJ0Y19pb2N0
bChzdHJ1Y3QgZmlsZSAqZmlscCwgdW5zaWduZWQgaW50IGNtZCwKKwkJCXVuc2lnbmVkIGxvbmcg
YXJnKTsKIAogc3RhdGljIGludCBydGNfcmVhZF9wcm9jKGNoYXIgKnBhZ2UsIGNoYXIgKipzdGFy
dCwgb2ZmX3Qgb2ZmLAogICAgICAgICAgICAgICAgICAgICAgICAgIGludCBjb3VudCwgaW50ICpl
b2YsIHZvaWQgKmRhdGEpOwpAQCAtNzUsOCArNzUsNyBAQCBzdGF0aWMgdW5zaWduZWQgbG9uZyBl
cG9jaCA9IDE5NzA7CS8qIHllYXIgY29ycmVzcG9uZGluZyB0byAweDAwCSovCiBzdGF0aWMgY29u
c3QgdW5zaWduZWQgY2hhciBkYXlzX2luX21vW10gPQogezAsIDMxLCAyOCwgMzEsIDMwLCAzMSwg
MzAsIDMxLCAzMSwgMzAsIDMxLCAzMCwgMzF9OwogCi1zdGF0aWMgaW50IHJ0Y19pb2N0bChzdHJ1
Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSwgdW5zaWduZWQgaW50IGNtZCwKLQkJ
ICAgICB1bnNpZ25lZCBsb25nIGFyZykKK3N0YXRpYyBsb25nIHJ0Y19pb2N0bChzdHJ1Y3QgZmls
ZSAqZmlscCwgdW5zaWduZWQgaW50IGNtZCwgdW5zaWduZWQgbG9uZyBhcmcpCiB7CiAKIAlzdHJ1
Y3QgcnRjX3RpbWUgd3RpbWU7CkBAIC0xOTcsNyArMTk2LDcgQEAgc3RhdGljIGludCBydGNfcmVs
ZWFzZShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKIAogc3RhdGljIGNv
bnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgcnRjX2ZvcHMgPSB7CiAJLm93bmVyCQk9IFRISVNf
TU9EVUxFLAotCS5pb2N0bAkJPSBydGNfaW9jdGwsCisJLnVubG9ja2VkX2lvY3RsCT0gcnRjX2lv
Y3RsLAogCS5vcGVuCQk9IHJ0Y19vcGVuLAogCS5yZWxlYXNlCT0gcnRjX3JlbGVhc2UsCiB9Owo=

------=_Part_9919_10320393.1200292737101--
