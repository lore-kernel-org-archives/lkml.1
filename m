Return-Path: <linux-kernel-owner+w=401wt.eu-S1422844AbXBUTpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422844AbXBUTpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422846AbXBUTpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:45:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40126 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422844AbXBUTpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:45:53 -0500
Date: Wed, 21 Feb 2007 11:45:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Linux 2.6.21-rc1
Message-Id: <20070221114542.60d94016.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702211123020.4043@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	<1172064762.25076.56.camel@localhost.localdomain>
	<45DC6C2C.7040509@intel.com>
	<Pine.LNX.4.64.0702211123020.4043@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007 11:24:33 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 21 Feb 2007, Kok, Auke wrote:
> > 
> > I think we need to drop this now. The report that says that this *fixes*
> > something might have been on regular interrupts only. I currently suspect that
> > it breaks all MSI interrupts, which would make sense if I look a the code.
> > Very bad indeed.
> > 
> > I'll try to come up with something else or send a patch that reverts it.
> 
> I'm going to be off-line for a couple of days,

And I'll be offline for five or six days.

> so I just reverted it.

OK, but this change was needed because the new IRQ-debugging code reliably
causes e1000 to explode.

So perhaps until e1000 gets sorted out we should disable the debug code:

--- a/lib/Kconfig.debug~a
+++ a/lib/Kconfig.debug
@@ -79,7 +79,7 @@ config DEBUG_KERNEL
 
 config DEBUG_SHIRQ
 	bool "Debug shared IRQ handlers"
-	depends on DEBUG_KERNEL && GENERIC_HARDIRQS
+	depends on DEBUG_KERNEL && GENERIC_HARDIRQS && BROKEN
 	help
 	  Enable this to generate a spurious interrupt as soon as a shared
 	  interrupt handler is registered, and just before one is deregistered.
_

