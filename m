Return-Path: <linux-kernel-owner+w=401wt.eu-S936394AbXGSBTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936394AbXGSBTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 21:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761878AbXGSBTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 21:19:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:39391 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761953AbXGSBTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 21:19:23 -0400
Subject: Re: [git patches] two warning fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <469EAABD.4010504@garzik.org>
References: <20070718235504.GA9601@havoc.gtf.org>
	 <200707190159.22654.ak@suse.de>  <469EAABD.4010504@garzik.org>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 11:19:05 +1000
Message-Id: <1184807945.25235.289.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 20:05 -0400, Jeff Garzik wrote:
> Andi Kleen wrote:
> > On Thursday 19 July 2007 01:55:04 Jeff Garzik wrote:
> >> Please pull from 'warnings' branch of
> >> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git warnings
> >>
> >> to receive the following updates:
> >>
> >>  drivers/video/aty/radeon_base.c |   23 ++++++++++++++++++-----
> >>  include/asm-x86_64/tlbflush.h   |    6 +++++-
> >>  2 files changed, 23 insertions(+), 6 deletions(-)
> >>
> >> Jeff Garzik (2):
> >>       drivers/video/aty/radeon_base: fix radeonfb_pci_register() err handling
> >>       [X86-64] make flush_tlb_kernel_range() a static inline function
> > 
> > I already got that patch queued. Why don't you send them through the maintainers?
> 
> Because in both cases the maintainers never responded to me, indicating 
> they were queued?

I suppose I should have acked the radeonfb one... I'm a bit of a slacker
with radeonfb maintainership lately.

However, in this case, I think I'll NACK it. I don't think it's fair to
fail the fb initialization because it couldn't create the EDID files. A
warning in dmesg is enough. For lots of machines, failing the fb init
means no console at all...

In general, I share paulus point of view here that forcing us to test
all those result code from sysfs file creation functions is just a major
PITA and adds bloat all over the kernel. There are many many cases where
the "obvious" thing of erroring out is actually not good policy. In many
cases, the failure to create some random sysfs file shouldn't prevent
the driver from operating, because the consequences of doing the later
are worse than the consequences of not having that sysfs file in the
first place. Thus, warnings are a better thing to do. But multiply the
number of sysfs_* calls by the code size of adding a test & printk and
you'll get the direct non-configurable-out bloat to the kernel.

Ben.


