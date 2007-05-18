Return-Path: <linux-kernel-owner+w=401wt.eu-S1757794AbXERVfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbXERVfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbXERVfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:35:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:56671 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbXERVfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:references;
        b=FW5GlQEJVDaUMWAvFlIv7HonJcOnvbLz2vk2m4Lv3UXFYbHIpX8nKzsRjm3CWCpj2a0tmrNya02bM7fufADS29KypdiXsK94ta3FkbttVAFqrFG1l/jbUp5xr5s280uJQNet8vGr2kZFwvrWhV+ttti9Agq8Z6FZaHDEcB1sb/0=
Message-ID: <d9b9d95f0705181435h40377f9cl8a573f8743d35eaf@mail.gmail.com>
Date: Fri, 18 May 2007 22:35:06 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: joydev.c and saitek cyborg evo force
In-Reply-To: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_37236_4425778.1179524106054"
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_37236_4425778.1179524106054
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 18/05/07, Renato Golin <rengolin@gmail.com> wrote:
> Problem is, on joydev_connect, when defining the corrections for every
> axis, the joystick is reporting dev->absmax = 127 and dev->absmin =
> -127 for both axis 0 and 1, so the correction is based on a signed
> range when the joystick is actually sending an unsigned range.

Quick fix so I can play flightgear:

on joydev_connect, created absmin and absmax to avoid messing dev
variables (pointer)

if current position (dev->abs) is not in range:

if (dev->abs[j] > dev->absmax[j] || dev->abs[j] < dev->absmin[j]) {
     absmin = 0;
     absmax = dev->abs[j] * 2;
}

problems:
 - it only works when joy is centred at connection
 - it assumes the joy will report correct positions (instead of uncalibrated)

Now I'll figure out how to turn off button 12...

cheers,
--renato

Reclaim your digital rights, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm

------=_Part_37236_4425778.1179524106054
Content-Type: text/x-patch; name=joydev.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f1v63qx1
Content-Disposition: attachment; filename="joydev.patch"

LS0tIGpveWRldi5jCTIwMDctMDQtMTIgMTg6MTU6NTYuMDAwMDAwMDAwICswMTAwCisrKyAvdXNy
L3NyYy9saW51eC9kcml2ZXJzL2lucHV0L2pveWRldi5jCTIwMDctMDUtMTggMjI6MjE6MjYuMDAw
MDAwMDAwICswMTAwCkBAIC00NzEsNiArNDcxLDcgQEAKIAlzdHJ1Y3Qgam95ZGV2ICpqb3lkZXY7
CiAJc3RydWN0IGNsYXNzX2RldmljZSAqY2RldjsKIAlpbnQgaSwgaiwgdCwgbWlub3I7CisJaW50
IGFic21pbiwgYWJzbWF4OwogCiAJZm9yIChtaW5vciA9IDA7IG1pbm9yIDwgSk9ZREVWX01JTk9S
UyAmJiBqb3lkZXZfdGFibGVbbWlub3JdOyBtaW5vcisrKTsKIAlpZiAobWlub3IgPT0gSk9ZREVW
X01JTk9SUykgewpAQCAtNTIwLDExICs1MjEsMjAgQEAKIAkJCWpveWRldi0+YWJzW2ldID0gZGV2
LT5hYnNbal07CiAJCQljb250aW51ZTsKIAkJfQorCQkvKiBTb21lIGpveXN0aWNrcyBkb24ndCBy
ZXBvcnQgbWF4L21pbiBjb3JyZWN0bHkgKi8KKwkJaWYgKGRldi0+YWJzW2pdID4gZGV2LT5hYnNt
YXhbal0gfHwgZGV2LT5hYnNbal0gPCBkZXYtPmFic21pbltqXSkgeworCQkJLyogYXNzdW1lIGpv
eXN0aWNrIGlzIGNlbnRlcmVkICovCisJCQlhYnNtaW4gPSAwOworCQkJYWJzbWF4ID0gZGV2LT5h
YnNbal0gKiAyOworCQl9IGVsc2UgeworCQkJYWJzbWluID0gZGV2LT5hYnNtaW5bal07CisJCQlh
YnNtYXggPSBkZXYtPmFic21heFtqXTsKKwkJfQogCQlqb3lkZXYtPmNvcnJbaV0udHlwZSA9IEpT
X0NPUlJfQlJPS0VOOwogCQlqb3lkZXYtPmNvcnJbaV0ucHJlYyA9IGRldi0+YWJzZnV6eltqXTsK
LQkJam95ZGV2LT5jb3JyW2ldLmNvZWZbMF0gPSAoZGV2LT5hYnNtYXhbal0gKyBkZXYtPmFic21p
bltqXSkgLyAyIC0gZGV2LT5hYnNmbGF0W2pdOwotCQlqb3lkZXYtPmNvcnJbaV0uY29lZlsxXSA9
IChkZXYtPmFic21heFtqXSArIGRldi0+YWJzbWluW2pdKSAvIDIgKyBkZXYtPmFic2ZsYXRbal07
Ci0JCWlmICghKHQgPSAoKGRldi0+YWJzbWF4W2pdIC0gZGV2LT5hYnNtaW5bal0pIC8gMiAtIDIg
KiBkZXYtPmFic2ZsYXRbal0pKSkKKwkJam95ZGV2LT5jb3JyW2ldLmNvZWZbMF0gPSAoYWJzbWF4
ICsgYWJzbWluKSAvIDIgLSBkZXYtPmFic2ZsYXRbal07CisJCWpveWRldi0+Y29ycltpXS5jb2Vm
WzFdID0gKGFic21heCArIGFic21pbikgLyAyICsgZGV2LT5hYnNmbGF0W2pdOworCQlpZiAoISh0
ID0gKChhYnNtYXggLSBhYnNtaW4pIC8gMiAtIDIgKiBkZXYtPmFic2ZsYXRbal0pKSkKIAkJCWNv
bnRpbnVlOwogCQlqb3lkZXYtPmNvcnJbaV0uY29lZlsyXSA9ICgxIDw8IDI5KSAvIHQ7CiAJCWpv
eWRldi0+Y29ycltpXS5jb2VmWzNdID0gKDEgPDwgMjkpIC8gdDsK
------=_Part_37236_4425778.1179524106054--
