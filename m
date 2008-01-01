Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbYAAN1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbYAAN1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 08:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYAAN1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 08:27:30 -0500
Received: from po-out-1718.google.com ([72.14.252.157]:50591 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbYAAN12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:27:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=R6XsnUwnZz8c9M0hG+EHyXRZGCzoVqvcs1/U6whI7VnIoLEXjUR3mXxW+/Ags7p+Ra0h8KZOCyooDMeXc6PBuFrBKsSrKcpgfzNY/tjYoZtm9fjgvRfA2hsxFn70Zyi8OqWIa4ZTThi3a7AIELtZOhxoQrmZV+hkZdYjkhuklME=
Date: Tue, 1 Jan 2008 21:27:39 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-s390@vger.kernel.org
Subject: (Try #2) [Patch 3/8] S390: Tiny fixes for Makefile
Message-ID: <20080101132739.GC2499@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080101071311.GA2496@hacking> <20080101072555.GD2496@hacking> <20080101101720.GC28913@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101101720.GC28913@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> -binfmt_elf32.o:	$(TOPDIR)/fs/binfmt_elf.c
>> +binfmt_elf32.o:	$(objtree)/fs/binfmt_elf.c
>
>This prerequisite listing looks just bogus and should be removed altogether.
>We only need to list prerequisites explicit for generated files.

Not so sure whether this is what s390 people do on purpose.
Thanks anyway!

The following one contains the new fix.

------------>

This patch removes TOPDIR and fixes a bogus prerequisite
in arch/s390/kernel/Makefile.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

----

diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 56cb710..4accf27 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_AUDIT)		+= audit.o
 compat-obj-$(CONFIG_AUDIT)	+= compat_audit.o
 obj-$(CONFIG_COMPAT)		+= compat_linux.o compat_signal.o \
 					compat_wrapper.o compat_exec_domain.o \
-					binfmt_elf32.o $(compat-obj-y)
+					binfmt_elf.o $(compat-obj-y)
 
 obj-$(CONFIG_VIRT_TIMER)	+= vtime.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
@@ -34,4 +34,4 @@ obj-$(CONFIG_KEXEC) += $(S390_KEXEC_OBJS)
 #
 # This is just to get the dependencies...
 #
-binfmt_elf32.o:	$(TOPDIR)/fs/binfmt_elf.c
+binfmt_elf.o:	$(objtree)/fs/binfmt_elf.c
