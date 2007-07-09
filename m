Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbXGIAzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbXGIAzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 20:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbXGIAzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 20:55:43 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35065 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbXGIAzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 20:55:42 -0400
Message-ID: <469185F9.4060604@zytor.com>
Date: Sun, 08 Jul 2007 17:48:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       zwane@infradead.org, Andi Kleen <ak@suse.de>,
       "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
References: <4678191D.76E4.0078.0@novell.com>	<4686D85B.6090803@gentoo.org> <20070630154230.4ad373fa.akpm@linux-foundation.org> <4690E65B.5050607@gentoo.org>
In-Reply-To: <4690E65B.5050607@gentoo.org>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------050004050603020905060700"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050004050603020905060700
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Daniel Drake wrote:
> 
> 2.6.22-rc6-mm1 has the same problem (it is not fixed there).
> 

I believe this patch should fix it for 2.6.22-rc6-mm1.  I will check
this into the newsetup tree.

	-hpa

--------------050004050603020905060700
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/i386/boot/video-vesa.c b/arch/i386/boot/video-vesa.c
index 3c21bd7..e6aa9eb 100644
--- a/arch/i386/boot/video-vesa.c
+++ b/arch/i386/boot/video-vesa.c
@@ -28,7 +28,7 @@ static void vesa_store_mode_params_graphics(void);
 
 static int vesa_probe(void)
 {
-#ifdef CONFIG_VIDEO_VESA
+#if defined(CONFIG_VIDEO_VESA) || defined(CONFIG_FIRMWARE_EDID)
 	u16 ax;
 	u16 mode;
 	addr_t mode_ptr;
@@ -47,7 +47,8 @@ static int vesa_probe(void)
 	    vginfo.signature != VESA_MAGIC ||
 	    vginfo.version < 0x0102)
 		return 0;	/* Not present */
-
+#endif /* CONFIG_VIDEO_VESA || CONFIG_FIRMWARE_EDID */
+#ifdef CONFIG_VIDEO_VESA
 	set_fs(vginfo.video_mode_ptr.seg);
 	mode_ptr = vginfo.video_mode_ptr.off;
 
@@ -96,7 +97,7 @@ static int vesa_probe(void)
 	return nmodes;
 #else
 	return 0;
-#endif
+#endif /* CONFIG_VIDEO_VESA */
 }
 
 static int vesa_set_mode(struct mode_info *mode)

--------------050004050603020905060700--
