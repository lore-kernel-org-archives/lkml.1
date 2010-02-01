Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab0BAWhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:37:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48107 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab0BAWhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:37:18 -0500
Message-ID: <4B6754DE.5070100@zytor.com>
Date: Mon, 01 Feb 2010 14:25:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, takata@linux-m32r.org, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, ralf@linux-mips.org,
       benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, lethal@linux-sh.org, davem@davemloft.net,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 3/6] generic sys_ipc wrapper
References: <20100201185544.GC11045@lst.de>
In-Reply-To: <20100201185544.GC11045@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2010 10:55 AM, Christoph Hellwig wrote:
> 
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

Looks good from an x86 perspective.

Reviewed-by: H. Peter Anvin <hpa@zytor.com>
