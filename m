Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbZAWMeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbZAWMeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 07:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbZAWMdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 07:33:55 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:39150 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbZAWMdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 07:33:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ej2BOTW7WvehYDzXIjnrnUL7MugRUFfNUkhGmEH6x6J2j1/0/UJkZd+xsD9ksefMSD
         NM25mZAjSyUx81YO3DKiAksb7lqDH4eKFkNsWw63SmSBM4fNFMINcEXQ7PG0aHzkDVIq
         KkVWvVufjIhQwz+ZB/WGPDioR0iI88iG8Y8jI=
MIME-Version: 1.0
Date: Fri, 23 Jan 2009 14:33:53 +0200
Message-ID: <46e1c7760901230433i3045f273oa109ce97e790bca3@mail.gmail.com>
Subject: [PATCH] fb: hide cursor in graphics mode
From: Risto Suominen <risto.suominen@gmail.com>
To: adaplas@pol.net
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net
Content-Type: multipart/mixed; boundary=001636c595490dcbc00461259a81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636c595490dcbc00461259a81
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Xserver Xfbdev (kdrive) uses linux framebuffer in graphics mode. It doesn't
need the text mode cursor, it's a bit annoying to have it there sitting in a
corner. This patch disables the cursor even when in graphics mode.

Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
---
The testing is done on kernel version 2.6.18.

--- a/drivers/video/console/fbcon.c.org	2007-03-03 07:14:54.000000000 +0200
+++ b/drivers/video/console/fbcon.c	2009-01-23 12:42:14.000000000 +0200
@@ -1363,6 +1363,12 @@ static void fbcon_cursor(struct vc_data
 	int y;
  	int c = scr_readw((u16 *) vc->vc_pos);

+	if (mode == CM_ERASE && info->fbops->fb_cursor) {
+		/* Hide H/W-cursor unconditionally */
+		ops->cursor(vc, info, mode, 0, 0, 0);
+		return;
+	}
+
 	if (fbcon_is_inactive(vc, info))
 		return;

--001636c595490dcbc00461259a81
Content-Type: text/x-diff; charset=US-ASCII; name="fbcon-graphics-nocursor.diff"
Content-Disposition: attachment; filename="fbcon-graphics-nocursor.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fqau2uvc1

WHNlcnZlciBYZmJkZXYgKGtkcml2ZSkgdXNlcyBsaW51eCBmcmFtZWJ1ZmZlciBpbiBncmFwaGlj
cyBtb2RlLiBJdCBkb2Vzbid0Cm5lZWQgdGhlIHRleHQgbW9kZSBjdXJzb3IsIGl0J3MgYSBiaXQg
YW5ub3lpbmcgdG8gaGF2ZSBpdCB0aGVyZSBzaXR0aW5nIGluIGEKY29ybmVyLiBUaGlzIHBhdGNo
IGRpc2FibGVzIHRoZSBjdXJzb3IgZXZlbiB3aGVuIGluIGdyYXBoaWNzIG1vZGUuCgpTaWduZWQt
b2ZmLWJ5OiBSaXN0byBTdW9taW5lbiA8UmlzdG8uU3VvbWluZW5AZ21haWwuY29tPgotLS0KVGhl
IHRlc3RpbmcgaXMgZG9uZSBvbiBrZXJuZWwgdmVyc2lvbiAyLjYuMTguCgotLS0gYS9kcml2ZXJz
L3ZpZGVvL2NvbnNvbGUvZmJjb24uYy5vcmcJMjAwNy0wMy0wMyAwNzoxNDo1NC4wMDAwMDAwMDAg
KzAyMDAKKysrIGIvZHJpdmVycy92aWRlby9jb25zb2xlL2ZiY29uLmMJMjAwOS0wMS0yMyAxMjo0
MjoxNC4wMDAwMDAwMDAgKzAyMDAKQEAgLTEzNjMsNiArMTM2MywxMiBAQCBzdGF0aWMgdm9pZCBm
YmNvbl9jdXJzb3Ioc3RydWN0IHZjX2RhdGEgCiAJaW50IHk7CiAgCWludCBjID0gc2NyX3JlYWR3
KCh1MTYgKikgdmMtPnZjX3Bvcyk7CiAKKwlpZiAobW9kZSA9PSBDTV9FUkFTRSAmJiBpbmZvLT5m
Ym9wcy0+ZmJfY3Vyc29yKSB7CisJCS8qIEhpZGUgSC9XLWN1cnNvciB1bmNvbmRpdGlvbmFsbHkg
Ki8KKwkJb3BzLT5jdXJzb3IodmMsIGluZm8sIG1vZGUsIDAsIDAsIDApOworCQlyZXR1cm47CisJ
fQorCiAJaWYgKGZiY29uX2lzX2luYWN0aXZlKHZjLCBpbmZvKSkKIAkJcmV0dXJuOwogCg==
--001636c595490dcbc00461259a81--
