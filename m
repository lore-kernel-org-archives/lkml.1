Return-Path: <linux-kernel-owner+w=401wt.eu-S934016AbYDYTMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934016AbYDYTMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933741AbYDYTKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 15:10:17 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:34420 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933688AbYDYTKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 15:10:13 -0400
Date: Fri, 25 Apr 2008 21:10:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Massimo Maiurana <maiurana@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: fix broken target update-po-config
Message-ID: <20080425191045.GA11263@uranus.ravnborg.org>
References: <480FAC63.6060109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480FAC63.6060109@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 11:38:43PM +0200, Massimo Maiurana wrote:
> In the latest kernel "make update-po-config" fails because it tries
> to open arch/Kconfig/Kconfig, since the ls command doesn't
> distinguish between files and directories.
> 
> trivial patch below.

Thanks.

Your patch was MIME damaged so when looking closer at it I
decided for a simpler approach:

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 32e8c5a..fa1a7d5 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -36,10 +36,10 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	    --output $(obj)/config.pot
 	$(Q)sed -i s/CHARSET/UTF-8/ $(obj)/config.pot
 	$(Q)ln -fs Kconfig.i386 arch/um/Kconfig.arch
-	$(Q)(for i in `ls arch/`;                        \
+	$(Q)(for i in `ls arch/*/Kconfig`;               \
 	    do                                           \
 		echo "  GEN $$i";                        \
-		$(obj)/kxgettext arch/$$i/Kconfig        \
+		$(obj)/kxgettext $$i                     \
 		     >> $(obj)/config.pot;               \
 	    done )
 	$(Q)msguniq --sort-by-file --to-code=UTF-8 $(obj)/config.pot \

	Sam
