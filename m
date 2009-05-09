Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbZEIJit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbZEIJit (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 05:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZEIJih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 05:38:37 -0400
Received: from smtp2b.orange.fr ([80.12.242.146]:35730 "EHLO smtp2b.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbZEIJig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 05:38:36 -0400
X-ME-UUID: 20090509093832852.D023680000AD@mwinf2b27.orange.fr
Message-ID: <4A054F18.7020501@free.fr>
Date: Sat, 09 May 2009 11:38:32 +0200
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
Organization: HOME
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Greg KH <greg@kroah.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFT] rtl8187: use DMA-aware buffers with usb_control_msg
References: <20090506064513.GA7460@kroah.com>	 <1241632963-25601-1-git-send-email-linville@tuxdriver.com> <3ace41890905081620h10d0250eq1ede9cd73021dc5b@mail.gmail.com>
In-Reply-To: <3ace41890905081620h10d0250eq1ede9cd73021dc5b@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------080308060506020708080203"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080308060506020708080203
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hin-Tak Leung wrote:
> On Wed, May 6, 2009 at 7:02 PM, John W. Linville <linville@tuxdriver.com> wrote:
>> This definitely needs to fail more gracefully in the event of a
>> kmalloc failure...
>>
>> Signed-off-by: John W. Linville <linville@tuxdriver.com>

OK guys. Thanks for your support and sorry for the delay: I add to
struggle with drm git to compile with 2.6.30-rc4-git3 (due to various
non yet integraed things my automated rebuild procedure does git fetch
for drm, xf86-video-nouveau, ...) , leading to no X server which for me
is more annoying than a trace in a USB wireless driver that I seldom use
only to test some new wireless feature (two GE port onboard).

The patch fix the DMA warning and the driver seems to work (just
associated it) but I must say that the allocation failure handling path
and the fact that we use now kmalloc for allocating a few bytes in such
a routine makes me worry about possible negative performance impact
unless theses routines are used only in a slow configuration path (did
no took time to red the code due to many other problems).

BTW if someone know who I should send this attached patch for DRM git, I
would gladly forward it.

-- eric



--------------080308060506020708080203
Content-Type: text/plain;
 name="patch-drm"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="patch-drm"

ZGlmZiAtLWdpdCBhL2xpbnV4LWNvcmUvZHJtX29zX2xpbnV4LmggYi9saW51eC1jb3JlL2Ry
bV9vc19saW51eC5oCmluZGV4IGY1ODI5NmIuLmI0NzQyMGUgMTAwNjQ0Ci0tLSBhL2xpbnV4
LWNvcmUvZHJtX29zX2xpbnV4LmgKKysrIGIvbGludXgtY29yZS9kcm1fb3NfbGludXguaApA
QCAtMzIsMTEgKzMyLDYgQEAKIC8qKiBJUlEgaGFuZGxlciBhcmd1bWVudHMgYW5kIHJldHVy
biB0eXBlIGFuZCB2YWx1ZXMgKi8KICNkZWZpbmUgRFJNX0lSUV9BUkdTCQlpbnQgaXJxLCB2
b2lkICphcmcKIC8qKiBiYWNrd2FyZHMgY29tcGF0aWJpbGl0eSB3aXRoIG9sZCBpcnEgcmV0
dXJuIHZhbHVlcyAqLwotI2lmbmRlZiBJUlFfSEFORExFRAotdHlwZWRlZiB2b2lkIGlycXJl
dHVybl90OwotI2RlZmluZSBJUlFfSEFORExFRAkJLyogbm90aGluZyAqLwotI2RlZmluZSBJ
UlFfTk9ORQkJLyogbm90aGluZyAqLwotI2VuZGlmCiAKIC8qKiBBR1AgdHlwZXMgKi8KICNp
ZiBfX09TX0hBU19BR1AKZGlmZiAtLWdpdCBhL2xpbnV4LWNvcmUvZHJtX3N5c2ZzLmMgYi9s
aW51eC1jb3JlL2RybV9zeXNmcy5jCmluZGV4IDZkZTkzNjcuLjYzN2Y1YzIgMTAwNjQ0Ci0t
LSBhL2xpbnV4LWNvcmUvZHJtX3N5c2ZzLmMKKysrIGIvbGludXgtY29yZS9kcm1fc3lzZnMu
YwpAQCAtMTYyLDE0ICsxNjIsMTQgQEAgaW50IGRybV9zeXNmc19kZXZpY2VfYWRkKHN0cnVj
dCBkcm1fbWlub3IgKm1pbm9yKQogCWludCBlcnI7CiAJaW50IGksIGo7CiAJY2hhciAqbWlu
b3Jfc3RyOwotCisJCiAJbWlub3ItPmtkZXYucGFyZW50ID0gJm1pbm9yLT5kZXYtPnBkZXYt
PmRldjsKIAltaW5vci0+a2Rldi5jbGFzcyA9IGRybV9jbGFzczsKIAltaW5vci0+a2Rldi5y
ZWxlYXNlID0gZHJtX3N5c2ZzX2RldmljZV9yZWxlYXNlOwogCW1pbm9yLT5rZGV2LmRldnQg
PSBtaW5vci0+ZGV2aWNlOwotCW1pbm9yX3N0ciA9ICJjYXJkJWQiOwotCQotCXNucHJpbnRm
KG1pbm9yLT5rZGV2LmJ1c19pZCwgQlVTX0lEX1NJWkUsIG1pbm9yX3N0ciwgbWlub3ItPmlu
ZGV4KTsKKyAgICAgICAgbWlub3Jfc3RyID0gImNhcmQlZCI7CisKKwlkZXZfc2V0X25hbWUo
Jm1pbm9yLT5rZGV2LCBtaW5vcl9zdHIsIG1pbm9yLT5pbmRleCk7CiAKIAllcnIgPSBkZXZp
Y2VfcmVnaXN0ZXIoJm1pbm9yLT5rZGV2KTsKIAlpZiAoZXJyKSB7Cg==
--------------080308060506020708080203--

