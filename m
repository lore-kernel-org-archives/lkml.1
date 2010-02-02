Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0BBBFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 20:05:00 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:46530 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752777Ab0BBBE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 20:04:58 -0500
Message-ID: <4B677A26.7040508@snapgear.com>
Date: Tue, 02 Feb 2010 11:04:38 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, takata@linux-m32r.org, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, ralf@linux-mips.org,
       benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, lethal@linux-sh.org, davem@davemloft.net,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 3/6] generic sys_ipc wrapper
References: <20100201185544.GC11045@lst.de>
In-Reply-To: <20100201185544.GC11045@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
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
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

For the m68knommup parts

Acked-by: Greg Ungerer <gerg@uclinux.org>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
