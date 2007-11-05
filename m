Return-Path: <linux-kernel-owner+w=401wt.eu-S1761425AbXKERXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761425AbXKERXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758044AbXKERQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:16:06 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:57451 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759854AbXKERQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:16:04 -0500
Date: Mon, 5 Nov 2007 18:17:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] replace "make ARCH=i386/x86_64 with make ARCH=x86"
Message-ID: <20071105171740.GA29481@uranus.ravnborg.org>
References: <20071103234826.GA26654@uranus.ravnborg.org> <20071105104129.GB3662@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105104129.GB3662@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > For now it just error out like this:
> > $ make ARCH=i386
> > Makefile:503: /home/sam/kernel/x86.git/arch/i386/Makefile: No such file or directory
> > make: *** No rule to make target `/home/sam/kernel/x86.git/arch/i386/Makefile'.  Stop.
> 
> Sounds fine, other architectures had that exactly same issue before.  Maybe
> we can add a more useful message thouigh like
> 
> $ARCH does not exist for any non-existant arch.

Like this:
$ make ARCH=foo
Makefile:201: *** "ERROR: ARCH (foo) does not exist".  Stop.

Implemented by following patch.

	Sam

diff --git a/Makefile b/Makefile
index cd8701e..9c46a70 100644
--- a/Makefile
+++ b/Makefile
@@ -196,6 +196,11 @@ CROSS_COMPILE	?=
 UTS_MACHINE 	:= $(ARCH)
 SRCARCH 	:= $(ARCH)
 
+# Sanity check the specified ARCH
+ifeq ($(wildcard $(srctree)/arch/$(SRCARCH)),)
+        $(error "ERROR: ARCH ($(SRCARCH)) does not exist")
+endif
+
 KCONFIG_CONFIG	?= .config
 
 # SHELL used by kbuild
