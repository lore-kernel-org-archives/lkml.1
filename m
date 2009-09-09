Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbZIIBZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbZIIBZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 21:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbZIIBZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 21:25:55 -0400
Received: from mail-px0-f177.google.com ([209.85.216.177]:57536 "EHLO
	mail-px0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbZIIBZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 21:25:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=SDbXr1atyvlmpJzbSkJgxGgF+aSB+Damtw2DbKtJuVbRujNHa83qMrHHoaNE4FX8Xz
         pT4cnYeU5Styu+BOlc9fI/pdeAGn+yiUQYRJxCnUzMyOxJk2V50q5mDjxF/zh4lV0KzV
         PpyiBsILTT0fAMRB72yiP2IYApnbY3n8vkpbM=
MIME-Version: 1.0
In-Reply-To: <200907050145.15122.rjw@sisk.pl>
References: <20090624092306.14276.127.sendpatchset@rx1.opensource.se>
	 <200907050145.15122.rjw@sisk.pl>
Date: Tue, 8 Sep 2009 18:25:55 -0700
X-Google-Sender-Auth: cf9b55ccddc80847
Message-ID: <e9c3a7c20909081825i1578a522w5d7f4e5d678b5d74@mail.gmail.com>
Subject: Re: [PATCH 00/07] pm: remove late/early platform driver pm callbacks 
	V2
From: Dan Williams <dan.j.williams@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, pavel@ucw.cz, hskinnemoen@atmel.com,
       anemo@mba.ocn.ne.jp, linux-usb@vger.kernel.org,
       akpm@linux-foundation.org, stern@rowland.harvard.edu,
       ben-linux@fluff.org, linux-omap@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, felipe.balbi@nokia.com,
       nicolas.ferre@atmel.com, linux-next@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd32810ea5aad04731af68a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd32810ea5aad04731af68a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2009/7/4 Rafael J. Wysocki <rjw@sisk.pl>:
> On Wednesday 24 June 2009, Magnus Damm wrote:
>> pm: remove late/early platform driver pm callbacks V2
>>
>> [PATCH 01/07] arm: rework omap suspend_late()/resume_early()
>> [PATCH 02/07] dma: rework dw_dmac suspend_late()/resume_early()
>> [PATCH 03/07] dma: rework txx9dmac suspend_late()/resume_early()
>> [PATCH 04/07] i2c: rework i2c-pxa suspend_late()/resume_early()
>> [PATCH 05/07] i2c: rework i2c-s3c2410 suspend_late()/resume() V2
>> [PATCH 06/07] usb: rework musb suspend()/resume_early()
>> [PATCH 07/07] pm: remove platform device suspend_late()/resume_early() V=
2
>>
>> These patches simply remove ->suspend_late() and ->resume_early()
>> from struct platform_driver. Drivers are converted to dev_pm_ops
>> with CONFIG_SUSPEND in mind. Untested.
>>
>> All patches except [02/07] are known to compile.
>>
>> Signed-off-by: Magnus Damm <damm@igel.co.jp>
[..]
>
> The series is now in the linux-next branch of the suspend-2.6 tree. =A0I'=
ll move
> it into the for-linus branch, which is not rebased, if the patches are no=
t
> reported to cause any problems in the next few days.
>

Hi,

My linux-next test builds for drivers/dma/ caught a missed conversion
of the at_hdmac driver.  Please check the attached fix (compile tested
only) and include it in this series.

Thanks and regards,
Dan

--000e0cd32810ea5aad04731af68a
Content-Type: application/octet-stream; name="at-hdmac-rework-suspend.patch"
Content-Disposition: attachment; filename="at-hdmac-rework-suspend.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fzddz1gn0

YXRfaGRtYWM6IFJld29yayBzdXNwZW5kX2xhdGUoKS9yZXN1bWVfZWFybHkoKQoKRnJvbTogRGFu
IFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+CgpUaGlzIHBhdGNoIHJld29ya3Mg
cGxhdGZvcm0gZHJpdmVyIHBvd2VyIG1hbmFnZW1lbnQgY29kZQpmb3IgYXRfaGRtYWMgZnJvbSBs
ZWdhY3kgbGF0ZS9lYXJseSBjYWxsYmFja3MgdG8gZGV2X3BtX29wcy4KClRoZSBjYWxsYmFja3Mg
YXJlIGNvbnZlcnRlZCBmb3IgQ09ORklHX1NVU1BFTkQgbGlrZSB0aGlzOgogIHN1c3BlbmRfbGF0
ZSgpIC0+IHN1c3BlbmRfbm9pcnEoKQogIHJlc3VtZV9lYXJseSgpIC0+IHJlc3VtZV9ub2lycSgp
CgpDYzogTWFnbnVzIERhbW0gPGRhbW1AaWdlbC5jby5qcD4KQ2M6IEdyZWcgS3JvYWgtSGFydG1h
biA8Z3JlZ2toQHN1c2UuZGU+CkNjOiBQYXZlbCBNYWNoZWsgPHBhdmVsQHVjdy5jej4KQ2M6IFJh
ZmFlbCBKLiBXeXNvY2tpIDxyandAc2lzay5wbD4KQ2M6IE5pY29sYXMgRmVycmUgPG5pY29sYXMu
ZmVycmVAYXRtZWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxp
YW1zQGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL2RtYS9hdF9oZG1hYy5jIHwgICAxOSArKysrKysr
KysrKystLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDcgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9kbWEvYXRfaGRtYWMuYyBiL2RyaXZlcnMvZG1h
L2F0X2hkbWFjLmMKaW5kZXggMGFlYjU3OC4uNzU4NWM0MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9k
bWEvYXRfaGRtYWMuYworKysgYi9kcml2ZXJzL2RtYS9hdF9oZG1hYy5jCkBAIC0xMTY4LDMyICsx
MTY4LDM3IEBAIHN0YXRpYyB2b2lkIGF0X2RtYV9zaHV0ZG93bihzdHJ1Y3QgcGxhdGZvcm1fZGV2
aWNlICpwZGV2KQogCWNsa19kaXNhYmxlKGF0ZG1hLT5jbGspOwogfQogCi1zdGF0aWMgaW50IGF0
X2RtYV9zdXNwZW5kX2xhdGUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldiwgcG1fbWVzc2Fn
ZV90IG1lc2cpCitzdGF0aWMgaW50IGF0X2RtYV9zdXNwZW5kX25vaXJxKHN0cnVjdCBkZXZpY2Ug
KmRldikKIHsKLQlzdHJ1Y3QgYXRfZG1hCSphdGRtYSA9IHBsYXRmb3JtX2dldF9kcnZkYXRhKHBk
ZXYpOworCXN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYgPSB0b19wbGF0Zm9ybV9kZXZpY2Uo
ZGV2KTsKKwlzdHJ1Y3QgYXRfZG1hICphdGRtYSA9IHBsYXRmb3JtX2dldF9kcnZkYXRhKHBkZXYp
OwogCiAJYXRfZG1hX29mZihwbGF0Zm9ybV9nZXRfZHJ2ZGF0YShwZGV2KSk7CiAJY2xrX2Rpc2Fi
bGUoYXRkbWEtPmNsayk7CiAJcmV0dXJuIDA7CiB9CiAKLXN0YXRpYyBpbnQgYXRfZG1hX3Jlc3Vt
ZV9lYXJseShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQorc3RhdGljIGludCBhdF9kbWFf
cmVzdW1lX25vaXJxKHN0cnVjdCBkZXZpY2UgKmRldikKIHsKLQlzdHJ1Y3QgYXRfZG1hCSphdGRt
YSA9IHBsYXRmb3JtX2dldF9kcnZkYXRhKHBkZXYpOworCXN0cnVjdCBwbGF0Zm9ybV9kZXZpY2Ug
KnBkZXYgPSB0b19wbGF0Zm9ybV9kZXZpY2UoZGV2KTsKKwlzdHJ1Y3QgYXRfZG1hICphdGRtYSA9
IHBsYXRmb3JtX2dldF9kcnZkYXRhKHBkZXYpOwogCiAJY2xrX2VuYWJsZShhdGRtYS0+Y2xrKTsK
IAlkbWFfd3JpdGVsKGF0ZG1hLCBFTiwgQVRfRE1BX0VOQUJMRSk7CiAJcmV0dXJuIDA7Ci0KIH0K
IAorc3RhdGljIHN0cnVjdCBkZXZfcG1fb3BzIGF0X2RtYV9kZXZfcG1fb3BzID0geworCS5zdXNw
ZW5kX25vaXJxID0gYXRfZG1hX3N1c3BlbmRfbm9pcnEsCisJLnJlc3VtZV9ub2lycSA9IGF0X2Rt
YV9yZXN1bWVfbm9pcnEsCit9OworCiBzdGF0aWMgc3RydWN0IHBsYXRmb3JtX2RyaXZlciBhdF9k
bWFfZHJpdmVyID0gewogCS5yZW1vdmUJCT0gX19leGl0X3AoYXRfZG1hX3JlbW92ZSksCiAJLnNo
dXRkb3duCT0gYXRfZG1hX3NodXRkb3duLAotCS5zdXNwZW5kX2xhdGUJPSBhdF9kbWFfc3VzcGVu
ZF9sYXRlLAotCS5yZXN1bWVfZWFybHkJPSBhdF9kbWFfcmVzdW1lX2Vhcmx5LAogCS5kcml2ZXIg
PSB7CiAJCS5uYW1lCT0gImF0X2hkbWFjIiwKKwkJLnBtCT0gJmF0X2RtYV9kZXZfcG1fb3BzLAog
CX0sCiB9OwogCg==
--000e0cd32810ea5aad04731af68a--
