Return-Path: <linux-kernel-owner+w=401wt.eu-S1752196AbYKPHig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbYKPHig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 02:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYKPHi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 02:38:28 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:23864 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYKPHi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 02:38:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CJ99A/lRQ4MZF/ATkDXzGlAsaCpSNSUPZCH58bvPPverf51i9OR29GEwxJiHcKVu0J
         wCxNGFJEZ7lnyPOBTfwZoOWSkpeZdybCx0/VlpeT2J2U7kqLIQ5Vt7NbCmeB841zlwlL
         CmhiJcTcS5EXjkddIAdKiZBHMJPmXNGddDTMU=
Date: Sun, 16 Nov 2008 10:42:01 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: viro@ZenIV.linux.org.uk, sam@ravnborg.org, zippel@linux-m68k.org
Cc: linux-kernel@vger.kernel.org
Subject: Immortal CONFIG_DEBUG_INFO=y
Message-ID: <20081116074201.GA27921@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As known to everybody doing fat builds, banning DEBUG_INFO=y is mandatory,
otherwise build is slower and takes much more disk space. And to not
accidently enable it, banning it in kconfig:

	@@ -475,7 +475,7 @@ config DEBUG_BUGVERBOSE
	 
	 config DEBUG_INFO
	 	bool "Compile the kernel with debug info"
	-	depends on DEBUG_KERNEL
	+	depends on DEBUG_KERNEL && DISABLED
	 	help
	           If you say Y here the resulting kernel image will include
	 	  debugging info resulting in a larger kernel image.

This works pretty well -- allmodconfig generates config without DEBUG_INFO and
so on, defconfigs also regenerated without it, even if original one in arch/
has DEBUG_INFO enabled and so on. Trick also works for other options, like,
KALLSYMS_EXTRA_PASS.

Except one case:

	make ARCH=sh magicpanelr2_defconfig

DEBUG_INFO survives to .config and resulting build runs with -g.

Now, DEBUG_INFO correctly dissapeares for all other defconfig.
And it dissapeares in se7721_defconfig case (which has CONFIG_DEBUG_KERNEL=y
_and_ CONFIG_DEBUG_INFO=y)

All other options I ban and enable (LOCALVERSION_AUTO, KALLSYMS_EXTRA_PASS,
MODVERSIONS, MODULE_SRCVERSION_ALL, STANDALONE, STAGING) correctly on and off
themselves in all cases.
