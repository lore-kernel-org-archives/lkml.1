Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbYABGm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbYABGm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 01:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbYABGmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 01:42:18 -0500
Received: from po-out-1718.google.com ([72.14.252.155]:5564 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbYABGmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 01:42:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=a2zGaWCr9ngodi9rPRDeHe9Oew5EAWpmBLRcak7FfDKqGriEunw5jSymVQ1HFGqfTLdHwUWITQfiiDaY8EkkNvt/iEE3upEMdRhWHuaBHX7YH0lyN0+iTaPAsJgiQGiBbPdc6EclwlJQmfDJEkLFBW62nkOq3XRxiigA4IeUtN0=
Date: Wed, 2 Jan 2008 14:42:19 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-s390@vger.kernel.org
Subject: (Try #3) [Patch 3/8] S390: Remove 'TOPDIR' from Makefile
Message-ID: <20080102064219.GG2493@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080101071311.GA2496@hacking> <20080101072555.GD2496@hacking> <20080101101720.GC28913@uranus.ravnborg.org> <20080101132739.GC2499@hacking> <20080101174214.GB31575@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101174214.GB31575@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>If the output file does not exist then kbuild does not care about the
>dependencies and will just build the target.
>On the second invocation when the target exists then kbuild has
>created a file named .<target>.cmd that list the dependencies
>and this includes any included .c file.
>So there is just no pint in defining this dependency explicit
>in the MAkefile - kbuild will figure it out automatically.
>
>The right fix is just to kill the explicit listed dependency.

If I understand you correctly, then the fix should be
the below one.

-------->

This patch removes TOPDIR from arch/s390/kernel/Makefile.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 56cb710..b3b650a 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -31,7 +31,3 @@ S390_KEXEC_OBJS := machine_kexec.o crash.o
 S390_KEXEC_OBJS += $(if $(CONFIG_64BIT),relocate_kernel64.o,relocate_kernel.o)
 obj-$(CONFIG_KEXEC) += $(S390_KEXEC_OBJS)
 
-#
-# This is just to get the dependencies...
-#
-binfmt_elf32.o:	$(TOPDIR)/fs/binfmt_elf.c
