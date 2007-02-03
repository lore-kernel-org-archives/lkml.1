Return-Path: <linux-kernel-owner+w=401wt.eu-S1946203AbXBCC2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946203AbXBCC2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946229AbXBCC2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:28:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55174 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946203AbXBCC23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:28:29 -0500
Date: Fri, 2 Feb 2007 18:15:52 -0800
From: Andrew Morton <akpm@osdl.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Adrian Bunk <bunk@stusta.de>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>, Stephen Hemminger <shemminger@osdl.org>,
       Frederic Riss <frederic.riss@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.20-rc7: known regressions
Message-Id: <20070202181552.ac588b27.akpm@linux-foundation.org>
In-Reply-To: <45C3ED84.6010506@garzik.org>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
	<20070202054916.GA3754@stusta.de>
	<20070202175504.a3bab5ac.akpm@linux-foundation.org>
	<45C3ED84.6010506@garzik.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Feb 2007 21:03:48 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Andrew Morton wrote:
> > On Fri, 2 Feb 2007 06:49:16 +0100
> > Adrian Bunk <bunk@stusta.de> wrote:
> > 
> >> This email lists some known regressions in 2.6.20-rc7 compared to 2.6.19
> >> that are not yet fixed in Linus' tree.
> > 
> > There are still a few things hanging around.
> > 
> > I have these queued:
> > 
> > aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch
> > kexec-avoid-migration-of-already-disabled-irqs-ia64.patch
> > net-smc911x-match-up-spin-lock-unlock.patch
> > rtc-pcf8563-detect-polarity-of-century-bit-automatically.patch
> > alpha-fix-epoll-syscall-enumerations.patch
> > revert-blockdev-direct-io-back-to-2619-version.patch
> > scsi-sd-udev-accessing-an-uninitialized-scsi_disk-results-in-a-crash.patch
> > altix-more-acpi-prt-support.patch
> 
> Would you forward the x86-64 dma_noncoherent API build fix I posted? 
> Anything that uses that API won't build on x86-64 without my [simple and 
> obvious] patch.

Yup.  That's this:

--- a/include/asm-x86_64/dma-mapping.h~x86-64-define-dma-noncoherent-api-functions
+++ a/include/asm-x86_64/dma-mapping.h
@@ -63,6 +63,9 @@ static inline int dma_mapping_error(dma_
 	return (dma_addr == bad_dma_address);
 }
 
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
 extern void *dma_alloc_coherent(struct device *dev, size_t size,
 				dma_addr_t *dma_handle, gfp_t gfp);
 extern void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
_

> 
> > - I have r8169-fix-a-race-between-pci-probe-and-dev_open.patch floating
> >   about, but I forget its status.  
> 
> I posted a preferred patch (which someone then noted need to use 
> setup_timer), and am waiting for an "it works" response of some sort

OK, thanks, I'll drop it.
