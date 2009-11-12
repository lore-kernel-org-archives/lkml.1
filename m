Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbZKLM7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbZKLM7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 07:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZKLM7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 07:59:43 -0500
Received: from sorrow.cyrius.com ([65.19.161.204]:56888 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbZKLM7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 07:59:42 -0500
Date: Thu, 12 Nov 2009 12:59:38 +0000
From: Martin Michlmayr <tbm@cyrius.com>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: akpm@linux-foundation.org, hpa@zytor.com, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] Add support for LZO-compressed kernels for ARM
Message-ID: <20091112125938.GA19698@deprecation.cyrius.com>
References: <1257942478-18719-1-git-send-email-albin.tonnerre@free-electrons.com>
 <1257942478-18719-2-git-send-email-albin.tonnerre@free-electrons.com>
 <1257942478-18719-3-git-send-email-albin.tonnerre@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257942478-18719-3-git-send-email-albin.tonnerre@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Albin Tonnerre <albin.tonnerre@free-electrons.com> [2009-11-11 13:27]:
> This is the second part of patch. This part includes:
>  - changes to ach/arch/boot/Makefile to make it easier to add new
>    compression types
> +
> +# For __aeabi_uidivmod
> +lib1funcs = $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.o

I build my kernel in a different directory to where the sources are
stored and I get:

make[7]: *** No rule to make target `/home/tbm/kernel/linux-2.6-2.6.32~rc6/debian/build/source_armel_none/arch/arm/lib/lib1funcs.o', needed by `arch/arm/boot/compressed/vmlinux'.  Stop.

The following patch makes it compile for me:

--- a/arm/boot/compressed/Makefile	2009-11-12 12:26:47.000000000 +0000
+++ b/arm/boot/compressed/Makefile	2009-11-12 12:26:58.000000000 +0000
@@ -101,7 +101,7 @@
 LDFLAGS_vmlinux += -T
 
 # For __aeabi_uidivmod
-lib1funcs = $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.o
+lib1funcs = arch/$(SRCARCH)/lib/lib1funcs.o
 
 # Don't allow any static data in misc.o, which
 # would otherwise mess up our GOT table

-- 
Martin Michlmayr
http://www.cyrius.com/
