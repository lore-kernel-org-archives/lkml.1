Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbZKHW5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbZKHW5L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 17:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbZKHW5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 17:57:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44533 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbZKHW5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 17:57:10 -0500
Date: Sun, 8 Nov 2009 22:56:52 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Leo Chen <leochen@broadcom.com>
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
Message-ID: <20091108225652.GB31433@flint.arm.linux.org.uk>
References: <m14op5jjo4.fsf@fess.ebiederm.org> <1257682930-31401-22-git-send-email-ebiederm@xmission.com> <20091108123422.GA9145@flint.arm.linux.org.uk> <m1pr7siqjz.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1pr7siqjz.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 02:45:36PM -0800, Eric W. Biederman wrote:
> Russell King <rmk+lkml@arm.linux.org.uk> writes:
> 
> >
> > NAK.  Glibc uses these numeric sysctls to support ioperm emulation on ARM.
> > Therefore, removal of these numeric sysctls breaks that user interface:
> >
> >   static int iobase_name[] = { CTL_BUS, BUS_ISA, BUS_ISA_PORT_BASE };
> >   static int ioshift_name[] = { CTL_BUS, BUS_ISA, BUS_ISA_PORT_SHIFT };
> >   if (! sysctl (iobase_name, 3, &io.io_base, &len, NULL, 0)
> >       && ! sysctl (ioshift_name, 3, &io.shift, &len, NULL, 0))
> >     {
> >       io.initdone = 1;
> >       return 0;
> >     }
> 
> Those still exist in sysctl_binary.c are provided by reading
> /proc/sys/bus/isa/membase, /proc/sys/bus/isa/portbase, and
> /proc/sys/bus/isa/portshift.
> 
> The practical difference is that /proc support now must be compiled
> in to support sys_sysctl.

Have you checked whether glibc supports reading these from procfs rather
than sysfs using the code as it stands above?

If not, continued NAK due to user visible ABI change which will cause
breakage.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
