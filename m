Return-Path: <linux-kernel-owner+w=401wt.eu-S1760960AbXEUVKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960AbXEUVKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 17:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbXEUVKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 17:10:25 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55992 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbXEUVKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 17:10:24 -0400
Date: Mon, 21 May 2007 17:03:58 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: UML doesn't compile in 2.6.21
Message-ID: <20070521210358.GB9929@c2.user-mode-linux.org>
References: <20070516224938.GN12319@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516224938.GN12319@pengutronix.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 12:49:38AM +0200, Robert Schwebel wrote:
> Jeff,
> 
> Any idea how this could happen? I'm trying to build 2.6.21 for
> ARCH=um, and the linker stage explodes here:
> 
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> lib/lib.a(bug.o): In function `find_bug':
> bug.c:(.text+0x171): undefined reference to `__start___bug_table'
> bug.c:(.text+0x177): undefined reference to `__stop___bug_table'
> bug.c:(.text+0x180): undefined reference to `__start___bug_table'
> bug.c:(.text+0x193): undefined reference to `__stop___bug_table'

No, I don't.  The bug_table symbols are rather unconditionally defined
in asm-generic/vmlinux.lds.h.  This can't be affected by any config
settings that I can see, let alone module support.  Further, the
config I always build has modules enabled, and I've never seen this.

Can you try starting over with an mrproper and see if you can
reproduce it?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
