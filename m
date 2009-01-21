Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbZAUWZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbZAUWZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 17:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZAUWZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 17:25:35 -0500
Received: from colo.lackof.org ([198.49.126.79]:34794 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbZAUWZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 17:25:34 -0500
Date: Wed, 21 Jan 2009 15:25:22 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Miller <davem@davemloft.net>, jaswinder@kernel.org, mingo@elte.hu,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
Message-ID: <20090121222522.GB15211@colo.lackof.org>
References: <1232496257.3123.19.camel@localhost.localdomain> <20090120.161626.93641145.davem@davemloft.net> <200901210124.26118.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901210124.26118.arnd@arndb.de>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 01:24:25AM +0100, Arnd Bergmann wrote:
...
> > This file needs to test for 64-bit'ness using some non-CONFIG_*
> > test.  And the standard built-in CPP macros which can be used
> > to check for that are different on every platform.
> 
> I think we should simply define a macro for use in the kernel, e.g. in
> <asm/types.h>. There already is a BITS_PER_LONG macro in there, maybe
> we can add an exported __BITS_PER_LONG there that checks for the right
> macro on each architecture.

I'm pretty sure __LP64__ is the standard compiler defined macro
for 64-bit builds on most architectures.

> On parisc, there is a major confusion in this area, at some point, all
> checks for __LP64__ got replaced with CONFIG_64BIT there. While I have
> not understood what the problem with __LP64__ was,

IIRC, the problem with __LP64__ is it wasn't visible to the CONFIG
tool chains and dependencies. I believe that's fixed now and parisc
could deprecate use of CONFIG_64BIT if there is a strong preference
for __LP64__.

> the check for
> CONFIG_64BIT on parisc user space looks very wrong.

This shouldn't be exported to user space. Is that what you meant?
PA-RISC user space can currently only be 32-bit anyway.
So a 64-bit kernel will have to take that into consideration.

thanks,
grant
