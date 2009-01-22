Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZAVSXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZAVSXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 13:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbZAVSXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 13:23:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:34975 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbZAVSXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 13:23:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=uWbsNIcfljeUHM1LWP8CT8gH8Gde61TZNvM8/VJUVrqBGkWCdxtDeRocqWNaq4rNBH
         M77qqZMrCwfDLd6ndsYO4hGlX8yQXsFoseYwm9CF2dt6869kpNzq29bBS7M7EbnBFWU7
         gfDicxEtTCtzJVvlOvcKbqvXKZA0DiT7Jns0w=
MIME-Version: 1.0
Date: Thu, 22 Jan 2009 20:23:05 +0200
Message-ID: <46e1c7760901221023r2766a57ey4564d05c05751b6e@mail.gmail.com>
Subject: [PATCH] vt - fb: hide cursor in graphics mode
From: Risto Suominen <risto.suominen@gmail.com>
To: adaplas@pol.net
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636c5b8b00d11840461165de9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636c5b8b00d11840461165de9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Xserver Xfbdev (kdrive) uses linux framebuffer in graphics mode. It doesn't
need the text mode cursor, it's a bit annoying to have it there sitting in a
corner. This patch disables the cursor when switching to graphics mode.

Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
---
The testing is done on kernel version 2.6.18.

--- a/drivers/char/vt_ioctl.c.org	2006-09-20 06:42:06.000000000 +0300
+++ b/drivers/char/vt_ioctl.c	2009-01-22 12:42:38.000000000 +0200
@@ -491,6 +491,10 @@ int vt_ioctl(struct tty_struct *tty, str
 			return -EPERM;
 		switch (arg) {
 		case KD_GRAPHICS:
+			/*
+			 * hide H/W (text) cursor in graphics mode
+			 */
+			vc->vc_sw->con_cursor(vc, CM_ERASE);
 			break;
 		case KD_TEXT0:
 		case KD_TEXT1:

--001636c5b8b00d11840461165de9
Content-Type: text/x-diff; charset=US-ASCII; name="vt_ioctl-graphics-nocursor.diff"
Content-Disposition: attachment; filename="vt_ioctl-graphics-nocursor.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fq9pj8z80

WHNlcnZlciBYZmJkZXYgKGtkcml2ZSkgdXNlcyBsaW51eCBmcmFtZWJ1ZmZlciBpbiBncmFwaGlj
cyBtb2RlLiBJdCBkb2Vzbid0Cm5lZWQgdGhlIHRleHQgbW9kZSBjdXJzb3IsIGl0J3MgYSBiaXQg
YW5ub3lpbmcgdG8gaGF2ZSBpdCB0aGVyZSBzaXR0aW5nIGluIGEKY29ybmVyLiBUaGlzIHBhdGNo
IGRpc2FibGVzIHRoZSBjdXJzb3Igd2hlbiBzd2l0Y2hpbmcgdG8gZ3JhcGhpY3MgbW9kZS4KClNp
Z25lZC1vZmYtYnk6IFJpc3RvIFN1b21pbmVuIDxSaXN0by5TdW9taW5lbkBnbWFpbC5jb20+Ci0t
LQpUaGUgdGVzdGluZyBpcyBkb25lIG9uIGtlcm5lbCB2ZXJzaW9uIDIuNi4xOC4KCi0tLSBhL2Ry
aXZlcnMvY2hhci92dF9pb2N0bC5jLm9yZwkyMDA2LTA5LTIwIDA2OjQyOjA2LjAwMDAwMDAwMCAr
MDMwMAorKysgYi9kcml2ZXJzL2NoYXIvdnRfaW9jdGwuYwkyMDA5LTAxLTIyIDEyOjQyOjM4LjAw
MDAwMDAwMCArMDIwMApAQCAtNDkxLDYgKzQ5MSwxMCBAQCBpbnQgdnRfaW9jdGwoc3RydWN0IHR0
eV9zdHJ1Y3QgKnR0eSwgc3RyCiAJCQlyZXR1cm4gLUVQRVJNOwogCQlzd2l0Y2ggKGFyZykgewog
CQljYXNlIEtEX0dSQVBISUNTOgorCQkJLyoKKwkJCSAqIGhpZGUgSC9XICh0ZXh0KSBjdXJzb3Ig
aW4gZ3JhcGhpY3MgbW9kZQorCQkJICovCisJCQl2Yy0+dmNfc3ctPmNvbl9jdXJzb3IodmMsIENN
X0VSQVNFKTsKIAkJCWJyZWFrOwogCQljYXNlIEtEX1RFWFQwOgogCQljYXNlIEtEX1RFWFQxOgo=
--001636c5b8b00d11840461165de9--
