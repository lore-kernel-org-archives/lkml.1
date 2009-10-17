Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZJQVR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZJQVR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 17:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbZJQVR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 17:17:27 -0400
Received: from imp02.mtu.ru ([62.5.255.19]:37995 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbZJQVR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 17:17:26 -0400
Message-ID: <4ADA3593.4010607@aknet.ru>
Date: Sun, 18 Oct 2009 01:22:27 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>
CC: Dmitry Torokhov <dtor-oss@comcast.net>, Takashi Iwai <tiwai@suse.de>
Subject: [patch][rfc] depend pcspkr on CONFIG_EMBEDDED
Content-Type: multipart/mixed;
 boundary="------------060608070306030008020202"
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060608070306030008020202
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello.

As most of the problems with snd-pcsp
are now settled and the major distros
are starting to unblacklist it and use
instead of pcspkr:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=539767
I'd like to do that sneaky thing.
The major argument for keeping pcspkr
I've heard, was that it doesn't require
the entire ALSA stack, and in this
case I think it is usefull only with
CONFIG_EMBEDDED. Right now it is a common
situation when the both modules are
built, and whichever gets loaded first,
works.
So can something like the attached
patch be applied?

---
Depend pcspkr on CONFIG_EMBEDDED to reduce
the chances of both the pcspkr and snd-pcsp
being built together. pcspkr is good only
by not requiring ALSA; apart from that,
snd-pcsp does everything.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>

--------------060608070306030008020202
Content-Type: text/x-patch;
 name="pcspkr_dep.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pcspkr_dep.diff"

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 02f4f8f..3571569 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -14,10 +14,14 @@ if INPUT_MISC
 
 config INPUT_PCSPKR
 	tristate "PC Speaker support"
-	depends on PCSPKR_PLATFORM
+	depends on PCSPKR_PLATFORM && EMBEDDED
 	help
 	  Say Y here if you want the standard PC Speaker to be used for
-	  bells and whistles.
+	  bells and whistles. This driver is small and is good when you
+	  do not need any other sounds from your machine.
+	  There is another driver that does the same and also has the
+	  PCM capabilities, called snd-pcsp, but it requires the entire
+	  ALSA stack.
 
 	  If unsure, say Y.
 

--------------060608070306030008020202--
