Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbYABGVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbYABGVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 01:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbYABGVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 01:21:31 -0500
Received: from po-out-1718.google.com ([72.14.252.153]:59923 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbYABGVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 01:21:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=oOvA2EbPmh9dBVKAYNfGjQHStAjzfgh0iCigR/Zr8Y649ogwnm8aBM2PukHITY3d/Gx7XwpDXfj0cxes5Vv3sHhXq46Tubc9FkIQVtJOzMd7Cn+2goIfI7jOWPwKhInlEnyTDx/F0TbdTitw0DtwCAgXWS7raAg1Dz731eXV2BY=
Date: Wed, 2 Jan 2008 14:21:36 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andreas Schwab <schwab@suse.de>, WANG Cong <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       linux-mips@linux-mips.org
Subject: (Try #3) [Patch 2/8] MIPS: Remove 'TOPDIR' from Makefiles
Message-ID: <20080102062135.GE2493@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080101071311.GA2496@hacking> <20080101072238.GC2496@hacking> <20080101101540.GB28913@uranus.ravnborg.org> <jefxxhlkxb.fsf@sykes.suse.de> <20080101175754.GC31575@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101175754.GC31575@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> 
>> Shouldn't that use $(LINUXINCLUDE), or $(KBUILD_CPPFLAGS)?
>It would be better to use $(LINUXINCLUDE) as we then pull in all config
>symbols too and do not have to hardcode kbuild internal names (include2).

OK. Refine this patch.

----------->

Since TOPDIR is obsolete, this patch removes TOPDIR
from the Mips Makefiles.

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/arch/mips/lasat/image/Makefile b/arch/mips/lasat/image/Makefile
index 5332449..17f5266 100644
--- a/arch/mips/lasat/image/Makefile
+++ b/arch/mips/lasat/image/Makefile
@@ -12,7 +12,7 @@ endif
 
 MKLASATIMG = mklasatimg
 MKLASATIMG_ARCH = mq2,mqpro,sp100,sp200
-KERNEL_IMAGE = $(TOPDIR)/vmlinux
+KERNEL_IMAGE = vmlinux
 KERNEL_START = $(shell $(NM) $(KERNEL_IMAGE) | grep " _text" | cut -f1 -d\ )
 KERNEL_ENTRY = $(shell $(NM) $(KERNEL_IMAGE) | grep kernel_entry | cut -f1 -d\ )
 
@@ -24,7 +24,7 @@ HEAD_DEFINES := -D_kernel_start=0x$(KERNEL_START) \
 		-D TIMESTAMP=$(shell date +%s)
 
 $(obj)/head.o: $(obj)/head.S $(KERNEL_IMAGE)
-	$(CC) -fno-pic $(HEAD_DEFINES) -I$(TOPDIR)/include -c -o $@ $<
+	$(CC) -fno-pic $(HEAD_DEFINES) $(LINUXINCLUDE) -c -o $@ $<
 
 OBJECTS = head.o kImage.o
 
