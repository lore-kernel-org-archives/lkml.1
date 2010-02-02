Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab0BBBgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 20:36:13 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:52146 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab0BBBgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 20:36:11 -0500
Date: Tue, 2 Feb 2010 10:36:03 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, takata@linux-m32r.org, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, ralf@linux-mips.org,
       benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, davem@davemloft.net, jdike@addtoit.com,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 3/6] generic sys_ipc wrapper
Message-ID: <20100202013603.GD13428@linux-sh.org>
References: <20100201185544.GC11045@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201185544.GC11045@lst.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
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
> 
> Except for that h8300, m68k and m68knommu lack an impplementation of the
> semtimedop sub call which this patch adds, and various architectures have
> different strategies for the SHMAT version 1 case which apparently never
> gets used - at least on i386 it seems superflous as the compat code on
> x86-64 and ia64 doesn't even bother to implement it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
sh bits look fine, too.

Acked-by: Paul Mundt <lethal@linux-sh.org>
