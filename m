Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbXKZSsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbXKZSsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 13:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbXKZSsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 13:48:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbXKZSsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 13:48:39 -0500
Date: Mon, 26 Nov 2007 13:48:34 -0500
From: Rik van Riel <riel@redhat.com>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1
Message-ID: <20071126134834.132c3081@cuia.boston.redhat.com>
In-Reply-To: <a8e1da0711202203v6a2a9945pcfa5cfe67b83b504@mail.gmail.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<a8e1da0711202151t6c9d52acjf1f876085b95dfce@mail.gmail.com>
	<20071120220046.db5c8fde.akpm@linux-foundation.org>
	<a8e1da0711202203v6a2a9945pcfa5cfe67b83b504@mail.gmail.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 14:03:34 +0800
"Dave Young" <hidave.darkstar@gmail.com> wrote:
> On Nov 21, 2007 2:00 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
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

> ia32 instead.

FYI, x86_64 has the exact same issue.

----
KVM needs the empty_zero_page export reinstated.

Signed-off-by: Rik van Riel <riel@redhat.com>

diff -up linux-2.6.24-rc3-mm1/arch/x86/kernel/x8664_ksyms_64.c.export-empty-zero-page linux-2.6.24-rc3-mm1/arch/x86/kernel/x8664_ksyms_64.c
--- linux-2.6.24-rc3-mm1/arch/x86/kernel/x8664_ksyms_64.c.export-empty-zero-page	2007-11-26 13:47:53.000000000 -0500
+++ linux-2.6.24-rc3-mm1/arch/x86/kernel/x8664_ksyms_64.c	2007-11-26 13:41:32.000000000 -0500
@@ -33,6 +33,7 @@ EXPORT_SYMBOL(__copy_from_user_inatomic)
 
 EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(clear_page);
+EXPORT_SYMBOL(empty_zero_page);
 
 /* Export string functions. We normally rely on gcc builtin for most of these,
    but gcc sometimes decides not to inline them. */    
