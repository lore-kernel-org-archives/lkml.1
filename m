Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbXBVKdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbXBVKdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932991AbXBVKdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:33:33 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:58037 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950AbXBVKdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:33:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:reply-to:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type;
        b=rO8U00OUFB8ZBwaXoRE+WDEN+s6TM9h5crmWevY0SisBb/FKEyYD2EakXtG2/43YkHSYCr64yrKeg8uUMvmo/9sUwaloLFElbklCq37G3H2cuNCMhsxOWTPxkjU4H8/gUgkeC4PzaxTdXyTnuEMG71SE6XqQ/Fal7hWSKwydSJg=
Date: Thu, 22 Feb 2007 12:33:35 +0200
From: Paul Sokolovsky <pmiscml@gmail.com>
Reply-To: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <1868738509.20070222123335@gmail.com>
To: Rodolfo Giometti <giometti@enneenne.com>
CC: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       <linux-fbdev-devel@lists.sourceforge.net>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH 1/1] PXAFB: Support for backlight control
In-Reply-To: <20070222083204.GN4641@enneenne.com>
References: <20070221145353.GA23916@enneenne.com> <1056908425.20070221180037@gmail.com> <20070221161210.GL4641@enneenne.com> <1741775233.20070221182608@gmail.com> <20070222083204.GN4641@enneenne.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="----------26DC233E751B3E"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------------26DC233E751B3E
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello Rodolfo,

Thursday, February 22, 2007, 10:32:04 AM, you wrote:

> On Wed, Feb 21, 2007 at 06:26:08PM +0200, Paul Sokolovsky wrote:
k>>   Why? It's the same, except that it already exists, generic one (not
>> limited to pxafb), and requires 1 function (too bad that C doesn't
>> support lambda's):

> Ah, ok.

>>   I sent a bit of criticism for that too ;-). YMMV, but kernel
>> solutions are just bound to be pretty simple and generic and lack
>> any "niceties", which you'd likely want to do anyway eventually. For
>> example, what if you'll want to implement "fade out" effect for
>> keyboard backlight? Doing it in adhoc manner in kernel? Whereas with
>> the LCD classdev, you can write generic "fade out" trigger and
>> attach/detach it from userspace.

> I agree. I just wish to add a backlight support for my LCD and
> minikeypad.

> What do you suggest to me in order to accomplish such task?

  Well, I write exactly to share experience and work towards having
best practices for backlight, etc. control, reusable on wide range of
embedded/handheld devices.

  We in handhelds.org codebase have attached patch* to make corgi_bl
more suitable for general use. This patch was submitted to Richard
(so, more votes needed ;-) ). Otherwise, snippet I pasted is from real
machine implementation, HP iPaq h4000.

  As for keyboard backlight, another port we have, HTC Universal, has:
normal indicator LEDs, keyboard backlight, flashlight, ring vibra. All
of these are handled via Generic LED API:
http://handhelds.org/cgi-bin/cvsweb.cgi/linux/kernel26/arch/arm/mach-pxa/htcuniversal/htcuniversal_leds.c?rev=1.6&content-type=text/x-cvsweb-markup

  To show that it is not an anomaly, but hopefully, a trend, here's
vibra driver for the upcoming OpenMoko phone:
http://wiki.openmoko.org/wiki/Neo1973_Hardware#Vibrator

  So, if you have freedom to add keyboard backlight control to your
userspace, that would allow you to do many interesting things without
disturbing the kernel.

[*] Optimized for size, full one should patch <asm/arch/sharpsl.h> of
course.


> Thanks for your suggestions,

> Rodolfo




-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com
------------26DC233E751B3E
Content-Type: application/octet-stream; name="driver-corgi-bl-generalize.patch"
Content-transfer-encoding: base64
Content-Disposition: attachment; filename="driver-corgi-bl-generalize.patch"

ZGlmZiAtTiAtVTMgLXIgLXggQ1ZTIC4uL2xpbnV4LTIuNi4yMC9kcml2ZXJzL3ZpZGVvL2Jh
Y2tsaWdodC9LY29uZmlnIC4uL2xpbnV4LTIuNi4yMC1oaC9kcml2ZXJzL3ZpZGVvL2JhY2ts
aWdodC9LY29uZmlnCi0tLSAuLi9saW51eC0yLjYuMjAvZHJpdmVycy92aWRlby9iYWNrbGln
aHQvS2NvbmZpZwkyMDA3LTAyLTA0IDE4OjQ0OjU0LjAwMDAwMDAwMCArMDAwMAorKysgLi4v
bGludXgtMi42LjIwLWhoL2RyaXZlcnMvdmlkZW8vYmFja2xpZ2h0L0tjb25maWcJMjAwNi0x
Mi0xOCAxMjo0MToyNC4wMDAwMDAwMDAgKzAwMDAKQEAgLTQ0LDcgKzQ0LDcgQEAKIAogY29u
ZmlnIEJBQ0tMSUdIVF9DT1JHSQogCXRyaXN0YXRlICJTaGFycCBDb3JnaSBCYWNrbGlnaHQg
RHJpdmVyIChTTCBTZXJpZXMpIgotCWRlcGVuZHMgb24gQkFDS0xJR0hUX0RFVklDRSAmJiBQ
WEFfU0hBUlBTTAorCWRlcGVuZHMgb24gQkFDS0xJR0hUX0RFVklDRQogCWRlZmF1bHQgeQog
CWhlbHAKIAkgIElmIHlvdSBoYXZlIGEgU2hhcnAgWmF1cnVzIFNMLUM3eHgsIFNMLUN4eDAw
IG9yIFNMLTYwMDB4IHNheSB5IHRvIGVuYWJsZSB0aGUKZGlmZiAtTiAtVTMgLXIgLXggQ1ZT
IC4uL2xpbnV4LTIuNi4yMC9kcml2ZXJzL3ZpZGVvL2JhY2tsaWdodC9jb3JnaV9ibC5jIC4u
L2xpbnV4LTIuNi4yMC1oaC9kcml2ZXJzL3ZpZGVvL2JhY2tsaWdodC9jb3JnaV9ibC5jCi0t
LSAuLi9saW51eC0yLjYuMjAvZHJpdmVycy92aWRlby9iYWNrbGlnaHQvY29yZ2lfYmwuYwky
MDA3LTAyLTA0IDE4OjQ0OjU0LjAwMDAwMDAwMCArMDAwMAorKysgLi4vbGludXgtMi42LjIw
LWhoL2RyaXZlcnMvdmlkZW8vYmFja2xpZ2h0L2NvcmdpX2JsLmMJMjAwNy0wMi0xMyAyMDox
MjoxNC4wMDAwMDAwMDAgKzAwMDAKQEAgLTE4LDcgKzE4LDcgQEAKICNpbmNsdWRlIDxsaW51
eC9tdXRleC5oPgogI2luY2x1ZGUgPGxpbnV4L2ZiLmg+CiAjaW5jbHVkZSA8bGludXgvYmFj
a2xpZ2h0Lmg+Ci0jaW5jbHVkZSA8YXNtL2FyY2gvc2hhcnBzbC5oPgorI2luY2x1ZGUgPGxp
bnV4L2NvcmdpX2JsLmg+CiAjaW5jbHVkZSA8YXNtL2hhcmR3YXJlL3NoYXJwc2xfcG0uaD4K
IAogc3RhdGljIGludCBjb3JnaWJsX2ludGVuc2l0eTsKZGlmZiAtTiAtVTMgLXIgLXggQ1ZT
IC4uL2xpbnV4LTIuNi4yMC9pbmNsdWRlL2xpbnV4L2NvcmdpX2JsLmggLi4vbGludXgtMi42
LjIwLWhoL2luY2x1ZGUvbGludXgvY29yZ2lfYmwuaAotLS0gLi4vbGludXgtMi42LjIwL2lu
Y2x1ZGUvbGludXgvY29yZ2lfYmwuaAkxOTcwLTAxLTAxIDAwOjAwOjAwLjAwMDAwMDAwMCAr
MDAwMAorKysgLi4vbGludXgtMi42LjIwLWhoL2luY2x1ZGUvbGludXgvY29yZ2lfYmwuaAky
MDA2LTExLTA0IDE3OjM2OjQ4LjAwMDAwMDAwMCArMDAwMApAQCAtMCwwICsxLDEwIEBACisv
KgorICogR2VuZXJpYyBCYWNrbGlnaHQsIGZyb20gc2hhcnBzbC5oCisgKi8KK3N0cnVjdCBj
b3JnaWJsX21hY2hpbmZvIHsKKwlpbnQgbWF4X2ludGVuc2l0eTsKKwlpbnQgZGVmYXVsdF9p
bnRlbnNpdHk7CisJaW50IGxpbWl0X21hc2s7CisJdm9pZCAoKnNldF9ibF9pbnRlbnNpdHkp
KGludCBpbnRlbnNpdHkpOworfTsKK2V4dGVybiB2b2lkIGNvcmdpYmxfbGltaXRfaW50ZW5z
aXR5KGludCBsaW1pdCk7Cg==
------------26DC233E751B3E--

