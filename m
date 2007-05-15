Return-Path: <linux-kernel-owner+w=401wt.eu-S1758965AbXEOUrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965AbXEOUrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 16:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbXEOUq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 16:46:59 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46016 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673AbXEOUq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 16:46:58 -0400
Date: Tue, 15 May 2007 22:47:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org
Subject: Re: [PATCH] kbuild: make better section mismatch reports on i386 and mips
Message-ID: <20070515204754.GD22966@uranus.ravnborg.org>
References: <20070515.004035.21363504.anemo@mba.ocn.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515.004035.21363504.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 12:40:35AM +0900, Atsushi Nemoto wrote:
> On i386 and MIPS, warn_sec_mismatch() sometimes fails to show usefull
> symbol name.  This is because empty 'refsym' due to 0 r_addend value.
> This patch is to adjust r_addend value, consulting with
> apply_relocate() routine in kernel code.
> 
> Without this patch:
>   MODPOST vmlinux
> WARNING: init/built-in.o - Section mismatch: reference to .init.text: from .text between 'rest_init' (at offset 0xf4) and 'try_name'
> WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text between 'kmem_cache_create' (at offset 0x18a39) and 'cache_reap'
> WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text between 'kmem_cache_create' (at offset 0x18a6b) and 'cache_reap'
> 
> With this patch:
>   MODPOST vmlinux
> WARNING: mm/built-in.o - Section mismatch: reference to .init.text:set_up_list3s from .text between 'kmem_cache_create' (at offset 0x18a39) and 'cache_reap'
> WARNING: mm/built-in.o - Section mismatch: reference to .init.text:set_up_list3s from .text between 'kmem_cache_create' (at offset 0x18a6b) and 'cache_reap'
> 
> Now modpost can detect "kernel_init" name (and whitelist it) and show
> "set_up_list3s" name.

Applied.
It seems arm is impacted by the same.
Can you add arm support for the same?

	Sam

