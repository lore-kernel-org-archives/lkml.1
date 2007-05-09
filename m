Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbXEIIoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbXEIIoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbXEIIng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:43:36 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4260 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbXEIInf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:43:35 -0400
Date: Wed, 9 May 2007 09:43:24 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Chris Wedgwood <cw@f00f.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86-64] Add getcpu and epoll_pwait system calls.
Message-ID: <20070509084324.GB15315@flint.arm.linux.org.uk>
Mail-Followup-To: Chris Wedgwood <cw@f00f.org>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
References: <20070508185145.B9A8E1827261@tuatara.stupidest.org> <20070508221348.GC17482@one.firstfloor.org> <20070508221656.GA6850@tuatara.stupidest.org> <20070508222432.GA15029@one.firstfloor.org> <20070508224322.GA8272@tuatara.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508224322.GA8272@tuatara.stupidest.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 03:43:22PM -0700, Chris Wedgwood wrote:
> On Wed, May 09, 2007 at 12:24:32AM +0200, Andi Kleen wrote:
> 
> > Somehow yes.  But i'm not going to add a useless syscall just to
> > shut it up.
> 
> It turns out this has come up in other places.  Sam has a suggestion
> on how to silence this per-arch so I'll post a patch once that change
> is in.

We knew about this when David and myself designed the detection
method, and a method of ignoring those calls which were never going
to be implemented on a particular architecture.

Just add:

#define __IGNORE_getcpu

to asm/unistd.h, preferably in a __KERNEL__ protected area.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
