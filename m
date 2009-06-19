Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbZFSJbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbZFSJbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 05:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZFSJbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 05:31:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44461 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbZFSJbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 05:31:42 -0400
Date: Fri, 19 Jun 2009 10:31:14 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/17] arm: asm/syscall.h (unfinished)
Message-ID: <20090619093114.GB18246@flint.arm.linux.org.uk>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com> <20090425001503.85473FC3C8@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090425001503.85473FC3C8@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 05:15:03PM -0700, Roland McGrath wrote:
> The syscall_get_nr() function here is not really right.  I don't
> know enough about ARM to finish it correctly.  It needs to figure
> out if the blocked user task is really in the kernel for a system
> call and return -1 if not.

That bit is rather hard - we maintain no global state as to whether a
task is in a syscall or not.  We also do not maintain a global view
of which syscall number is being executed.  The kernel just hasn't
required either of these things before.

> I also did not try to handle all the different ABI variants, which I
> don't really understand.

There are two places that the syscall number comes from: EABI and thumb
both use R7.  OABI puts the value in the instruction itself.

In short, I don't know what to do about this either.  I don't think
there's a quick and simple answer.

Your implementation of syscall_get_arguments() looks wrong - for OABI
it makes sense because there is no padding in the allocation of registers.
However, for EABI, there is padding, so 64-bit values always come in
using an even+odd register number.  Short of maintaining some sort of
table describing the argument placements for every kernel syscall (eww)
I'm not sure how this could be fixed.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
