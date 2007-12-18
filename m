Return-Path: <linux-kernel-owner+w=401wt.eu-S1759086AbXLRPX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbXLRPX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbXLRPXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:23:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:25789 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514AbXLRPXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:23:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:references:x-google-sender-auth;
        b=h5FF/y1YEZkrrl/7cH2cfG2y08j8KZnlxUf0dbmZNtFsBI5KaKeXYWAv89xCnZNlOkLsXnk/MMti3SGqaaTveRKgboopoiaReNw5+TwdEVRtwm9Q/+oZXjrl7DByzxbdMjU+cFa4chYgmnwnoF6n8TzjemFVwMj606CwnGATLbs=
Message-ID: <3efb10970712180723x2cd22c5ei6b342f0ab7cc39c2@mail.gmail.com>
Date: Tue, 18 Dec 2007 16:23:11 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH] atmel_serial: Split the interrupt handler
Cc: "Andrew Victor" <linux@maxim.org.za>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1197987255-23045-1-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_15057_2830897.1197991391929"
References: <1197987255-23045-1-git-send-email-hskinnemoen@atmel.com>
X-Google-Sender-Auth: c4e67eba7dad68b5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_15057_2830897.1197991391929
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Haavard,

A few remarks:

> From: Remy Bohmer <hskinnemoen@atmel.com>

My name, at your address ;-)))

> This patch splits up the interrupt handler of the serial port
> into a interrupt top-half and a tasklet.

I see you moved the handling of the sysrq-key to the tasklet. This was
actually a very nice feature in the IRQ-top half on preempt-RT. This
helps debugging running away RT-processes.

> In this version of the patch, we try to only do things that are
> absolutely necessary in the interrupt handler, storing away the
> status register along with the received character and letting the
> tasklet handle break, sysrq, error flags, etc.

Preempt-RT now absolutely requires my (4th) IRQ_NODELAY patch, because
the spinlock now is always inside the code, and not only in
theexception path, and thus without my NO_DELAY patch we have a panic
during boot.
On preempt-RT this spinlock must be a raw-spinlock. (If this type is
known in the mainline kernel, you can apply that patch it anyway)

BTW: Attached I have added a 2nd patch that I use for Preempt-RT. (For
cleaner startup, and to get rid of useless IRQ-threads.

> This patch should apply on top of the cleanup patch I sent earlier

For the cleanup patch:
Acked-by: Remy Bohmer <linux@bohmer.net>

> today. Or at least I think so...I'll send the full series once
> everyone are happy.

So, for this patch: I am almost happy ;-)


Kind Regards,

Remy

------=_Part_15057_2830897.1197991391929
Content-Type: text/x-patch;
 name=prevent_startup_interrupt_thread_dbgu.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_facl2kom
Content-Disposition: attachment;
 filename=prevent_startup_interrupt_thread_dbgu.patch

VGhpcyBwYXRjaCBwcmV2ZW50cyBzdGFydGluZyB1cCBhIHVzZWxlc3MgSVJRLXRocmVhZCBmb3Ig
SVJRLTEsCmJlY2F1c2UgdGhpcyBJUlEgaXMgcnVubmluZyBpbiBJUlFGX05PREVMQVkgY29udGV4
dCBkdWUgdG8gdGhlIAp0aW1lciBpbnRlcnJ1cHQuCgpTaWduZWQtb2ZmLWJ5OiBSZW15IEJvaG1l
ciA8bGludXhAYm9obWVyLm5ldD4KLS0tCiBkcml2ZXJzL3NlcmlhbC9hdG1lbF9zZXJpYWwuYyB8
ICAgMTAgKysrKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQoKSW5kZXg6IGxpbnV4LTIuNi4yMy9kcml2ZXJzL3NlcmlhbC9hdG1lbF9zZXJpYWwu
Ywo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYuMjMub3JpZy9kcml2ZXJzL3NlcmlhbC9hdG1lbF9z
ZXJpYWwuYwkyMDA3LTEyLTE4IDE1OjQ5OjAyLjAwMDAwMDAwMCArMDEwMAorKysgbGludXgtMi42
LjIzL2RyaXZlcnMvc2VyaWFsL2F0bWVsX3NlcmlhbC5jCTIwMDctMTItMTggMTU6NTY6MzcuMDAw
MDAwMDAwICswMTAwCkBAIC01NDksNiArNTQ5LDcgQEAgc3RhdGljIGludCBhdG1lbF9zdGFydHVw
KHN0cnVjdCB1YXJ0X3BvcgogewogCXN0cnVjdCBhdG1lbF91YXJ0X3BvcnQgKmF0bWVsX3BvcnQg
PSAoc3RydWN0IGF0bWVsX3VhcnRfcG9ydCAqKSBwb3J0OwogCWludCByZXR2YWw7CisJdW5zaWdu
ZWQgbG9uZyBpcnFmbGFncyA9IElSUUZfU0hBUkVEOwogCiAJLyoKIAkgKiBFbnN1cmUgdGhhdCBu
byBpbnRlcnJ1cHRzIGFyZSBlbmFibGVkIG90aGVyd2lzZSB3aGVuCkBAIC01NTcsMTAgKzU1OCwx
NyBAQCBzdGF0aWMgaW50IGF0bWVsX3N0YXJ0dXAoc3RydWN0IHVhcnRfcG9yCiAJICovCiAJVUFS
VF9QVVRfSURSKHBvcnQsIC0xKTsKIAorI2lmZGVmIENPTkZJR19QUkVFTVBUX1JUCisJLyogSVJR
MSBpcyB0aGUgU3lzdGVtIElSUSwgd2hpY2ggaXMgc2hhcmVkIHdpdGggdGhlIFRpbWVyLUlSUSwg
YW5kCisJICAgdGh1cyBpdCBpcyBydW5uaW5nIGluIElSUUZfTk9ERUxBWSBjb250ZXh0LiBCeSBz
ZXR0aW5nIHRoaXMgZmxhZworCSAgIGhlcmUgYWxzbywgd2UgcHJldmVudCBzdGFydGluZyB1cCBh
IHVzZWxlc3MgSVJRLXRocmVhZC4qLworCWlmIChwb3J0LT5pcnEgPT0gMSkKKwkJaXJxZmxhZ3Mg
fD0gSVJRRl9OT0RFTEFZOworI2VuZGlmCiAJLyoKIAkgKiBBbGxvY2F0ZSB0aGUgSVJRCiAJICov
Ci0JcmV0dmFsID0gcmVxdWVzdF9pcnEocG9ydC0+aXJxLCBhdG1lbF9pbnRlcnJ1cHQsIElSUUZf
U0hBUkVELAorCXJldHZhbCA9IHJlcXVlc3RfaXJxKHBvcnQtPmlycSwgYXRtZWxfaW50ZXJydXB0
LCBpcnFmbGFncywKIAkJCSJhdG1lbF9zZXJpYWwiLCBwb3J0KTsKIAlpZiAocmV0dmFsKSB7CiAJ
CXByaW50aygiYXRtZWxfc2VyaWFsOiBhdG1lbF9zdGFydHVwIC0gQ2FuJ3QgZ2V0IGlycVxuIik7
Cg==
------=_Part_15057_2830897.1197991391929--
