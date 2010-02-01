Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0BAXm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 18:42:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37068 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab0BAXm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 18:42:57 -0500
Date: Mon, 1 Feb 2010 23:42:19 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, takata@linux-m32r.org, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, ralf@linux-mips.org,
       benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, lethal@linux-sh.org, davem@davemloft.net,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 3/6] generic sys_ipc wrapper
Message-ID: <20100201234219.GG21693@flint.arm.linux.org.uk>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux@arm.linux.org.uk, starvik@axis.com, jesper.nilsson@axis.com,
	dhowells@redhat.com, ysato@users.sourceforge.jp,
	takata@linux-m32r.org, geert@linux-m68k.org, zippel@linux-m68k.org,
	gerg@uclinux.org, ralf@linux-mips.org, benh@kernel.crashing.org,
	schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
	lethal@linux-sh.org, davem@davemloft.net, jdike@addtoit.com,
	tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
	viro@zeniv.linux.org.uk
References: <20100201185544.GC11045@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201185544.GC11045@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 07:55:44PM +0100, Christoph Hellwig wrote:
> Add a generic implementation of the ipc demultiplexer syscall.  Except for
> s390 and sparc64 all implementations of the sys_ipc are nearly identical.
> 
> There are slight differences in the types of the parameters, where mips
> and powerpc as the only 64-bit architectures with sys_ipc use unsigned long
> for the "third" argument as it gets casted to a pointer later, while it
> traditionally is an "int" like most other paramters.  frv goes even further
> and uses unsigned long for all parameters execept for "ptr" which is a pointer
> type everywhere.  The change from int to unsigned long for "third" and back
> to "int" for the others on frv should be fine due to the in-register calling
> conventions for syscalls (we already had a similar issue with the generic
> sys_ptrace), but I'd prefer to have the arch maintainers looks over this
> in details.

>From an ARM perspective, it looks like nothing actually changes, so...

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
