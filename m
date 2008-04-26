Return-Path: <linux-kernel-owner+w=401wt.eu-S1761913AbYDZXkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761913AbYDZXkm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 19:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761347AbYDZXkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 19:40:05 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:50665 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761317AbYDZXkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 19:40:03 -0400
Message-ID: <4813BD39.1080105@aknet.ru>
Date: Sun, 27 Apr 2008 03:39:37 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor-oss@comcast.net>
CC: Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: [patch] pcspkr: fix dependancies
References: <4813476A.7000705@aknet.ru> <200804261918.14711.dtor-oss@comcast.net>
In-Reply-To: <200804261918.14711.dtor-oss@comcast.net>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------030807020609040807040306"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030807020609040807040306
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello.

Dmitry Torokhov wrote:
> No, not another config option please. Either make pcspkr platform
> device be created unconditionally
I also think this would be the best
fix. But this will return us to the
state of 2.6.24. Presumably the dependancy
was added for the reason, even if I
fail to see one.
But in any case, the patch is attached.

> or if either pcspkr or snd-pcsp
> is selected.
I don't think it is correct, but if
people think it is, then this can be
done.


---
Compile pcspkr platform device unconditionally.
That allows snd-pcsp to work.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>

--------------030807020609040807040306
Content-Type: text/x-patch;
 name="pcsp_dep1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pcsp_dep1.diff"

--- a/arch/x86/kernel/Makefile	2008-04-26 13:40:06.000000000 +0400
+++ b/arch/x86/kernel/Makefile	2008-04-26 18:22:49.000000000 +0400
@@ -83,9 +83,7 @@
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
 
-ifdef CONFIG_INPUT_PCSPKR
 obj-y				+= pcspeaker.o
-endif
 
 obj-$(CONFIG_SCx200)		+= scx200.o
 scx200-y			+= scx200_32.o

--------------030807020609040807040306--
