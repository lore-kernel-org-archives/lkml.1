Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbXDMMf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbXDMMf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 08:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbXDMMf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 08:35:28 -0400
Received: from mail-gw3.adaptec.com ([216.52.22.36]:34665 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbXDMMf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 08:35:27 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C77DC8.35EF5408"
Subject: [PATCH] aacraid: 2.6.21-rc6-mm1 aacraid not finding device
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Fri, 13 Apr 2007 08:35:25 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF018164DE@otce2k301.adaptec.com>
In-Reply-To: <1176243661.5949.59.camel@drfickle.rchland.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] aacraid: 2.6.21-rc6-mm1 aacraid not finding device
Thread-Index: Acd7vofyq0IR5hiNTwyvDhJJ+USWsQCCAwPw
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, <linux-scsi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, "Duane Cox" <dcox@conxxus.com>,
       <James.Bottomley@SteelEye.com>,
       "Steve Fox" <drfickle@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C77DC8.35EF5408
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Thanks for the help from Steve Fox and Duane Cox investigating this
issue, I'd like to report that we found the problem. The issue is with
the patch Steve Fox isolated below, by not accommodating older adapters
properly and issuing a command they do not support when retrieving
storage parameters about the arrays. This simple patch resolves the
problem (and more accurately mimics the logic of the original code
before the patch).

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patches.

This attached patch is against current scsi-misc-2.6 and can apply to
2.6.21-rc6-mm1. Please consider it for expedited inclusion.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

---

Sincerely -- Mark Salyzyn


> -----Original Message-----
> From: Steve Fox [mailto:drfickle@linux.vnet.ibm.com]=20
> Sent: Tuesday, April 10, 2007 6:21 PM
> To: Andrew Morton
> Cc: linux-kernel@vger.kernel.org; Salyzyn, Mark;=20
> markh@linux-foundation.org; James.Bottomley@SteelEye.com;=20
> linux-scsi@vger.kernel.org
> Subject: Re: 2.6.21-rc6-mm1 aacraid not finding device
>=20
>=20
> On Sun, 2007-04-08 at 14:35 -0700, Andrew Morton wrote:
> >=20
>
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6
/2.6.21-rc6-mm1/

Since 2.6.21-rc5-mm1, one of the test.kernel.org machines (elm3b239) has
not been able to boot because it cannot find the SCSI device. You can
view http://test.kernel.org/abat/82623/debug/console.log for the latest
boot log (rc6-mm1).

I tracked this down to the git-scsi-misc patch in the -mm tree and then
bisected the scsi-misc git tree until I reached the commit below from
Mark Salyzyn:

fe76df4235986cfacc2d3b71cef7c42bc1a6dd6c

[SCSI] aacraid: Fix blocking issue with container probing function (cast
update)

This is a pretty big patch, so hopefully Mark can take a look at it.
lspci shows

01:02.0 RAID bus controller: Adaptec AAC-RAID (rev 02)
0f:02.0 SCSI storage controller: Adaptec AIC-9410W SAS (Razor ASIC
non-RAID) (rev 08)
1d:02.0 SCSI storage controller: Adaptec AIC-9410W SAS (Razor ASIC
non-RAID) (rev 08)
2b:02.0 SCSI storage controller: Adaptec AIC-9410W SAS (Razor ASIC
non-RAID) (rev 08)

on 2.6.21-rc6. Let me know if I can provide more details.

--=20

Steve Fox
IBM Linux Technology Center


------_=_NextPart_001_01C77DC8.35EF5408
Content-Type: application/octet-stream;
	name="aacraid_logical_bugfix.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_logical_bugfix.patch
Content-Disposition: attachment;
	filename="aacraid_logical_bugfix.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDct
MDQtMTIgMTU6NTQ6MjUuMjQ0Mzk5MTAyIC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDctMDQtMTIgMTU6NTc6MDMuODA2NDY4Mjk3IC0wNDAwCkBAIC01MDMsOCAr
NTAzLDcgQEAKIAlkcmVzcCA9IChzdHJ1Y3QgYWFjX21vdW50ICopIGZpYl9kYXRhKGZpYnB0cik7
CiAJZHJlc3AtPm1udFswXS5jYXBhY2l0eWhpZ2ggPSAwOwogCWlmICgobGUzMl90b19jcHUoZHJl
c3AtPnN0YXR1cykgIT0gU1RfT0spIHx8Ci0JICAgICgobGUzMl90b19jcHUoZHJlc3AtPm1udFsw
XS52b2wpICE9IENUX05PTkUpICYmCi0JICAgICAobGUzMl90b19jcHUoZHJlc3AtPm1udFswXS5z
dGF0ZSkgPT0gRlNDU19ISURERU4pKSkKKwkgICAgKGxlMzJfdG9fY3B1KGRyZXNwLT5tbnRbMF0u
dm9sKSAhPSBDVF9OT05FKSkKIAkJcmV0dXJuIF9hYWNfcHJvYmVfY29udGFpbmVyMihjb250ZXh0
LCBmaWJwdHIpOwogCXNjc2ljbWQgPSAoc3RydWN0IHNjc2lfY21uZCAqKSBjb250ZXh0OwogCXNj
c2ljbWQtPlNDcC5waGFzZSA9IEFBQ19PV05FUl9NSURMRVZFTDsK

------_=_NextPart_001_01C77DC8.35EF5408--
