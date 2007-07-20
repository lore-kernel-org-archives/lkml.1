Return-Path: <linux-kernel-owner+w=401wt.eu-S941013AbXGTQMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941013AbXGTQMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757189AbXGTQMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:12:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55374 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759904AbXGTQMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:12:03 -0400
Date: Fri, 20 Jul 2007 17:11:54 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Horst H. von Brand" <vonbrand@inf.utfsm.cl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sparclinux@vger.kernel.org
Subject: Re: sparc64: ERROR: "sys_ioctl" [arch/sparc64/solaris/solaris.ko] undefined!
Message-ID: <20070720161154.GA17382@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	sparclinux@vger.kernel.org
References: <7157.1184937882@laptop13.inf.utfsm.cl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7157.1184937882@laptop13.inf.utfsm.cl>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 09:24:42AM -0400, Horst H. von Brand wrote:
> When building v2.6.22-3478-g275afca on sparc64 (.config attached) I get:
> 
>   MODPOST vmlinux
>   Building modules, stage 2.
>   MODPOST 463 modules
> ERROR: "sys_ioctl" [arch/sparc64/solaris/solaris.ko] undefined!

Sorry, my fault.

It looked to me like sparc64 exports sys_ioctl on it's own, but it only
exports compat_sys_ioctl on it's own.

Here's the fix:

Index: linux-2.6/arch/sparc64/kernel/sparc64_ksyms.c
===================================================================
--- linux-2.6.orig/arch/sparc64/kernel/sparc64_ksyms.c	2007-07-20 17:09:25.000000000 +0200
+++ linux-2.6/arch/sparc64/kernel/sparc64_ksyms.c	2007-07-20 17:09:33.000000000 +0200
@@ -280,6 +280,7 @@ EXPORT_SYMBOL(sys_getgid);
 EXPORT_SYMBOL(svr4_getcontext);
 EXPORT_SYMBOL(svr4_setcontext);
 EXPORT_SYMBOL(compat_sys_ioctl);
+EXPORT_SYMBOL(sys_ioctl);
 EXPORT_SYMBOL(sparc32_open);
 #endif
 
