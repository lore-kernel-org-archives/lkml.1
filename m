Return-Path: <linux-kernel-owner+w=401wt.eu-S1759372AbYGPOWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372AbYGPOWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbYGPOWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:22:39 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:31796 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170AbYGPOWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:22:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=fR2VeSr40U1mJXRRAWi8dADvdiWp/XYQBEwGrVyAUcB3NL6KxUFyJR8+XYepAXSx0J
         nQkZA/yGQIxhrXRzM8j6yFkMvADwvGPG+eal5eCH2GliAojNnrRsGQY9ZHoyD+SkebY/
         QjfhUxarEvr0w/Gr6h4dtwYiscpSEyRk63EZk=
Message-ID: <19f34abd0807160722y64f93b56v83faf12e23ae9013@mail.gmail.com>
Date: Wed, 16 Jul 2008 16:22:37 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: BUG: spinlock bad magic on CPU#1, modprobe/815 - led-triggers
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Richard Purdie" <rpurdie@rpsys.net>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
In-Reply-To: <c4e36d110807160524i51f12d8eof0b1d58219725c3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_13234_12751335.1216218157327"
References: <c4e36d110807160524i51f12d8eof0b1d58219725c3c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_13234_12751335.1216218157327
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Jul 16, 2008 at 2:24 PM, Zdenek Kabelac
<zdenek.kabelac@gmail.com> wrote:
> Hello
>
> I'm running 2.6.26 kernel - git commit: bce7f793daec3e65ec5c5705d2457b81fe7b5725
> I've T61, 2GB, C2D, x86_64
>
>  I'm getting this oops while using 64bit kernel and running mostly 32bit system.
>
> This one happens sometimes during boot - unpredictible - usually once
> in 15 boots.
>

Thanks for the report.

It looks like the error is in led_classdev_register(); the led_cdev is
added to the leds_list *before* the led_cdev->trigger_lock is
initialized.

(This might also explain why you don't always hit it.)

On the other hand, I might be completely wrong. The following NULL
pointer dereference bothers me somewhat as it isn't entirely clear why
it appears.

I've added a couple of Ccs.

Can you try the patch I've attached?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

------=_Part_13234_12751335.1216218157327
Content-Type: application/octet-stream; name=led-class.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fiq0uifg0
Content-Disposition: attachment; filename=led-class.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbGVkcy9sZWQtY2xhc3MuYyBiL2RyaXZlcnMvbGVkcy9sZWQt
Y2xhc3MuYwppbmRleCA1NTlhNDA4Li40NGQxM2FjIDEwMDY0NAotLS0gYS9kcml2ZXJzL2xlZHMv
bGVkLWNsYXNzLmMKKysrIGIvZHJpdmVycy9sZWRzL2xlZC1jbGFzcy5jCkBAIC0xMTMsMTMgKzEx
Myw2IEBAIGludCBsZWRfY2xhc3NkZXZfcmVnaXN0ZXIoc3RydWN0IGRldmljZSAqcGFyZW50LCBz
dHJ1Y3QgbGVkX2NsYXNzZGV2ICpsZWRfY2RldikKIAlpZiAocmMpCiAJCWdvdG8gZXJyX291dDsK
IAotCS8qIGFkZCB0byB0aGUgbGlzdCBvZiBsZWRzICovCi0JZG93bl93cml0ZSgmbGVkc19saXN0
X2xvY2spOwotCWxpc3RfYWRkX3RhaWwoJmxlZF9jZGV2LT5ub2RlLCAmbGVkc19saXN0KTsKLQl1
cF93cml0ZSgmbGVkc19saXN0X2xvY2spOwotCi0JbGVkX3VwZGF0ZV9icmlnaHRuZXNzKGxlZF9j
ZGV2KTsKLQogI2lmZGVmIENPTkZJR19MRURTX1RSSUdHRVJTCiAJaW5pdF9yd3NlbSgmbGVkX2Nk
ZXYtPnRyaWdnZXJfbG9jayk7CiAKQEAgLTEzMCw2ICsxMjMsMTMgQEAgaW50IGxlZF9jbGFzc2Rl
dl9yZWdpc3RlcihzdHJ1Y3QgZGV2aWNlICpwYXJlbnQsIHN0cnVjdCBsZWRfY2xhc3NkZXYgKmxl
ZF9jZGV2KQogCWxlZF90cmlnZ2VyX3NldF9kZWZhdWx0KGxlZF9jZGV2KTsKICNlbmRpZgogCisJ
bGVkX3VwZGF0ZV9icmlnaHRuZXNzKGxlZF9jZGV2KTsKKworCS8qIGFkZCB0byB0aGUgbGlzdCBv
ZiBsZWRzICovCisJZG93bl93cml0ZSgmbGVkc19saXN0X2xvY2spOworCWxpc3RfYWRkX3RhaWwo
JmxlZF9jZGV2LT5ub2RlLCAmbGVkc19saXN0KTsKKwl1cF93cml0ZSgmbGVkc19saXN0X2xvY2sp
OworCiAJcHJpbnRrKEtFUk5fSU5GTyAiUmVnaXN0ZXJlZCBsZWQgZGV2aWNlOiAlc1xuIiwKIAkJ
CWxlZF9jZGV2LT5uYW1lKTsKIApAQCAtMTM4LDcgKzEzOCw2IEBAIGludCBsZWRfY2xhc3NkZXZf
cmVnaXN0ZXIoc3RydWN0IGRldmljZSAqcGFyZW50LCBzdHJ1Y3QgbGVkX2NsYXNzZGV2ICpsZWRf
Y2RldikKICNpZmRlZiBDT05GSUdfTEVEU19UUklHR0VSUwogZXJyX291dF9sZWRfbGlzdDoKIAlk
ZXZpY2VfcmVtb3ZlX2ZpbGUobGVkX2NkZXYtPmRldiwgJmRldl9hdHRyX2JyaWdodG5lc3MpOwot
CWxpc3RfZGVsKCZsZWRfY2Rldi0+bm9kZSk7CiAjZW5kaWYKIGVycl9vdXQ6CiAJZGV2aWNlX3Vu
cmVnaXN0ZXIobGVkX2NkZXYtPmRldik7Cg==
------=_Part_13234_12751335.1216218157327--
