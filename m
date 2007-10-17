Return-Path: <linux-kernel-owner+w=401wt.eu-S936304AbXJQCvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936304AbXJQCvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760820AbXJQCuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:50:55 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:43872 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbXJQCuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:50:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=B9a4ifZjfR3kUAG020RmsTmAN/9sLf4k5mlTmXjGmN85qtS8cr0NT8Wp+VLVb+gomPdvEq8TyOaRcrviW+CsOQQWswsW+yWy2NApXXpxcTbXirqTalRSC83/i/56ZFnpS7xAY2K/+IDXkTIAinfIgZ4yz8i3Ki8WIutFL7LFBpo=
Message-ID: <3877989d0710161950n3d255330lf55e190dde628277@mail.gmail.com>
Date: Wed, 17 Oct 2007 10:50:53 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: linux-ia64@vger.kernel.org
Subject: [RFC patch] fallback to "no irq" hack for case of no pnp_irq allocated for 8250_pnp
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_47747_19994121.1192589453364"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_47747_19994121.1192589453364
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello list,

There is a "ttyS1 irq is -1" problem observed on tiger4 which cause
the serial port broken.
It is because that there is __no__ ACPI IRQ resource assigned for the
serial port. So the value of the IRQ for the port is never changed
since it got initialized to -1. The attached patch falls back to the
"no irq" hack for this case. It works for me. Please review and test.

Thanks,
Luming

Signed-off-by: Yu Luming <luming.yu@intel.com>

 8250_pnp.c |    3 +++
 1 files changed, 3 insertions(+)

------=_Part_47747_19994121.1192589453364
Content-Type: application/octet-stream; name="8250_pnp.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="8250_pnp.patch"; filename="8250_pnp.patch"; filename="8250_pnp.patch"; filename="8250_pnp.patch"; filename="8250_pnp.patch"; filename="8250_pnp.patch"; filename="8250_pnp.patch";
 filename="8250_pnp.patch"
X-Attachment-Id: f_f7v8nd1c

LS0tIDIuNi9kcml2ZXJzL3NlcmlhbC84MjUwX3BucC5jLm9yaWcJMjAwNy0xMC0xNiAxNDoxODox
OS4wMDAwMDAwMDAgKzA4MDAKKysrIDIuNi9kcml2ZXJzL3NlcmlhbC84MjUwX3BucC5jCTIwMDct
MTAtMTYgMTQ6MTg6MzAuMDAwMDAwMDAwICswODAwCkBAIC00MzEsNiArNDMxLDkgQEAKIAogCW1l
bXNldCgmcG9ydCwgMCwgc2l6ZW9mKHN0cnVjdCB1YXJ0X3BvcnQpKTsKIAlwb3J0LmlycSA9IHBu
cF9pcnEoZGV2LCAwKTsKKwkvKiBObyBpcnEgaXMgYXNzaWduZWQgZm9yIHRoZSBwb3J0LCBmYWxs
YmFjayB0byAibm8gaXJxIiBoYWNrICovCisJaWYgKHBvcnQuaXJxID09IC0xKQorCQlwb3J0Lmly
cSA9IDA7IAogCWlmIChwbnBfcG9ydF92YWxpZChkZXYsIDApKSB7CiAJCXBvcnQuaW9iYXNlID0g
cG5wX3BvcnRfc3RhcnQoZGV2LCAwKTsKIAkJcG9ydC5pb3R5cGUgPSBVUElPX1BPUlQ7Cg==
------=_Part_47747_19994121.1192589453364--
