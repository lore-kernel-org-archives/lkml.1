Return-Path: <linux-kernel-owner+w=401wt.eu-S932135AbZDCM34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbZDCM34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 08:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760796AbZDCM3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 08:29:45 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:42607 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbZDCM3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 08:29:44 -0400
Date: Fri, 3 Apr 2009 14:31:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Simmons <jsimmons@infradead.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbdev: move logo externs to header file
Message-ID: <20090403123143.GA15598@uranus.ravnborg.org>
References: <alpine.LRH.2.00.0904031157550.32353@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0904031157550.32353@vixen.sonytel.be>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 01:45:40PM +0200, Geert Uytterhoeven wrote:
> Now we have __initconst, we can finally move the external declarations for the
> various Linux logo structures to <linux/linux_logo.h>.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Acked-By: James Simmons <jsimmons@infradead.org>
> ---
> James' ack dates back to the previous submission (way to long ago), when the
> logos were still __initdata, which caused failures on some platforms with some
> toolchain versions.
> 
> Note: you have to remove the generated logos, as they're not automatically
> regenerated if scripts/pnmtologo.c changes.

Something like this to fix that bug?
Untested as I'm busy atm.

	Sam

diff --git a/drivers/video/logo/Makefile b/drivers/video/logo/Makefile
index b91251d..6a26982 100644
--- a/drivers/video/logo/Makefile
+++ b/drivers/video/logo/Makefile
@@ -37,22 +37,24 @@ extra-y += $(call logo-cfiles,_clut224,ppm)
 # Gray 256
 extra-y += $(call logo-cfiles,_gray256,pgm)
 
+pnmtlogo := scripts/pnmtologo
+
 # Create commands like "pnmtologo -t mono -n logo_mac_mono -o ..."
 quiet_cmd_logo = LOGO    $@
-	cmd_logo = scripts/pnmtologo \
+	cmd_logo = $(pnmtologo) \
 			-t $(patsubst $*_%,%,$(notdir $(basename $<))) \
 			-n $(notdir $(basename $<)) -o $@ $<
 
-$(obj)/%_mono.c: $(src)/%_mono.pbm FORCE
+$(obj)/%_mono.c: $(src)/%_mono.pbm $(pnmtlogo) FORCE
 	$(call if_changed,logo)
 
-$(obj)/%_vga16.c: $(src)/%_vga16.ppm FORCE
+$(obj)/%_vga16.c: $(src)/%_vga16.ppm $(pnmtlogo) FORCE
 	$(call if_changed,logo)
 
-$(obj)/%_clut224.c: $(src)/%_clut224.ppm FORCE
+$(obj)/%_clut224.c: $(src)/%_clut224.ppm $(pnmtlogo) FORCE
 	$(call if_changed,logo)
 
-$(obj)/%_gray256.c: $(src)/%_gray256.pgm FORCE
+$(obj)/%_gray256.c: $(src)/%_gray256.pgm $(pnmtlogo) FORCE
 	$(call if_changed,logo)
 
 # Files generated that shall be removed upon make clean
