Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbXFXTK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbXFXTK1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 15:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXFXTKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 15:10:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33651 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbXFXTKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 15:10:09 -0400
Date: Sun, 24 Jun 2007 20:10:07 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070624191007.GC21478@ftp.linux.org.uk>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk> <200706242007.10585.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706242007.10585.arnd@arndb.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 08:07:10PM +0200, Arnd Bergmann wrote:
> One minor issue though:
> While BUILD_BUG_ON and a few other macros in linux/kernel.h are currently
> exported to user space, I would think that they should really be hidden
> in #ifdef __KERNEL__, which means that we also need something like
> 
> #ifdef __KERNEL__
> #define _IOC_TYPECHECK(t) \
>         (sizeof(t) + BUILD_BUG_ON_ZERO(sizeof(t) == sizeof(t[1]) && \
>           sizeof(t) < (1 << _IOC_SIZEBITS)))
> #else
> #define _IOC_TYPECHECK(t) sizeof(t)
> #endif

Point, but then we might want to export the damn thing in properly
named version (i.e. put it into __.... reserved namespace).  It
doesn't depend on anything kernel-specific...

FWIW, the current version suffers from similar problem - it's outside
of __KERNEL__ in userland-exported header and it can lead to breakage
when included in build by something other than gcc...
