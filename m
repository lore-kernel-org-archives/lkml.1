Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbXKUGQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbXKUGQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 01:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXKUGQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 01:16:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39533 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbXKUGQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 01:16:25 -0500
Date: Tue, 20 Nov 2007 22:15:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc3-mm1
Message-Id: <20071120221552.1f42ebfa.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0711202203v6a2a9945pcfa5cfe67b83b504@mail.gmail.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<a8e1da0711202151t6c9d52acjf1f876085b95dfce@mail.gmail.com>
	<20071120220046.db5c8fde.akpm@linux-foundation.org>
	<a8e1da0711202203v6a2a9945pcfa5cfe67b83b504@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 14:03:34 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:

> On Nov 21, 2007 2:00 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Wed, 21 Nov 2007 13:51:47 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
> >
> > > Hi, andrew
> > >
> > > modpost failed for me:
> > >   MODPOST 360 modules
> > > ERROR: "empty_zero_page" [drivers/kvm/kvm.ko] undefined!
> > > make[1]: *** [__modpost] Error 1
> > > make: *** [modules] Error 2
> > >
> >
> > You're a victim of the hasty unexporting fad.  Which architecture?
> > x86_64 I guess?
> >
> Hi,
> ia32 instead.
> 

oic.  Like this, I guess.

--- a/arch/x86/kernel/i386_ksyms_32.c~git-x86-i386-export-empty_zero_page
+++ a/arch/x86/kernel/i386_ksyms_32.c
@@ -2,6 +2,7 @@
 #include <asm/semaphore.h>
 #include <asm/checksum.h>
 #include <asm/desc.h>
+#include <asm/pgtable.h>
 
 EXPORT_SYMBOL(__down_failed);
 EXPORT_SYMBOL(__down_failed_interruptible);
@@ -22,3 +23,4 @@ EXPORT_SYMBOL(__put_user_8);
 EXPORT_SYMBOL(strstr);
 
 EXPORT_SYMBOL(csum_partial);
+EXPORT_SYMBOL(empty_zero_page);
_

