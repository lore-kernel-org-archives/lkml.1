Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbYDVSbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbYDVSbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbYDVSbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:31:12 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:51592 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347AbYDVSbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:31:11 -0400
Message-ID: <480E2EE5.5040208@aknet.ru>
Date: Tue, 22 Apr 2008 22:31:01 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1 (snd-pcsp doesn't like DEBUG_PAGEALLOC)
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<20080419021343.GA3503@nineveh.local>	<20080418200237.b5a9e805.akpm@linux-foundation.org>	<20080419041429.GA8508@anvil.corenet.prv>	<20080418212934.bbe84ee2.akpm@linux-foundation.org>	<s5h8wz7cng7.wl%tiwai@suse.de>	<480CD50F.20706@aknet.ru> <s5hbq42b3j7.wl%tiwai@suse.de>
In-Reply-To: <s5hbq42b3j7.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------020000010802080808080906"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020000010802080808080906
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello.

Takashi Iwai wrote:
> It's no big problem but I just find the phrase "you have to
> disable..." too strict.  It's just a sound-quality problem as you
> mentioned in the above.
> BTW, I noticed that the message includes a few line breaks.  You need
> a proper KERN_ prefix for each line in such a case.  A fix patch would
> be appreciated.
Like the attached one?

--------------020000010802080808080906
Content-Type: text/x-patch;
 name="pcsp_wrn.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pcsp_wrn.diff"

# HG changeset patch
# User Stas Sergeev <stsp@users.sourceforge.net>
# Date 1208888978 -14400
# Node ID 00c36aa3903d861198e8f57c46e75194f3e172d6
# Parent  f8fbce7ba45922a73a9679d68c4a4b07ebef42de
pcsp: fix wording in DEBUG_PAGEALLOC warning.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>

diff -r f8fbce7ba459 -r 00c36aa3903d drivers/pcsp/pcsp.c
--- a/drivers/pcsp/pcsp.c	Tue Apr 22 18:39:49 2008 +0200
+++ b/drivers/pcsp/pcsp.c	Tue Apr 22 22:29:38 2008 +0400
@@ -147,12 +147,8 @@ static int __devinit alsa_card_pcsp_init
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	/* Well, CONFIG_DEBUG_PAGEALLOC makes the sound horrible. Lets alert */
-	printk(KERN_WARNING
-	       "PCSP: Warning, CONFIG_DEBUG_PAGEALLOC is enabled!\n"
-	       "You have to disable it if you want to use the PC-Speaker "
-	       "driver.\n"
-	       "Unless it is disabled, enjoy the horrible, distorted "
-	       "and crackling noise.\n");
+	printk(KERN_WARNING "PCSP: CONFIG_DEBUG_PAGEALLOC is enabled, "
+		KERN_WARNING "which may make the sound noisy.\n");
 #endif
 
 	return 0;

--------------020000010802080808080906--
