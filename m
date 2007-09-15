Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbXIOIgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbXIOIgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 04:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXIOIgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 04:36:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42933 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672AbXIOIgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 04:36:37 -0400
Date: Sat, 15 Sep 2007 01:36:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: rth@twiddle.net, ink@jurassic.park.msu.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: convert to generic sys_ptrace
Message-Id: <20070915013619.07722b24.akpm@linux-foundation.org>
In-Reply-To: <20070915081437.GA5251@lst.de>
References: <20070908191257.GA5075@lst.de>
	<20070915011150.0439a432.akpm@linux-foundation.org>
	<20070915081437.GA5251@lst.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Sep 2007 10:14:37 +0200 Christoph Hellwig <hch@lst.de> wrote:

> On Sat, Sep 15, 2007 at 01:11:50AM -0700, Andrew Morton wrote:
> > On Sat, 8 Sep 2007 21:12:57 +0200 Christoph Hellwig <hch@lst.de> wrote:
> > 
> > > This patch converts alpha to the generic sys_ptrace.  We use
> > > force_successful_syscall_return to avoid having to pass the pt_regs
> > > pointer down to the function.  I think the removal of the assemly
> > > stub is correct, but I could only compile-test this patch, so please
> > > give it a spin before commiting :)
> > 
> > Needed a bit of massaging due to consolidate-ptrace_detach.patch but
> > it still compiles:
> 
> Btw,does alpha actually build for you sucessfully?  While I could get
> the ptrace bits to compile 2.6.23-rc doesn't actually finish the build
> for me due to missing syscalls and the brainded -Werror flag making this
> fatal..

I just did a successful gcc-4.1.0 alpha allmodconfig build with 2.6.23-rc5
plus 44 patches which are in or are targetted for 2.6.23:

quote-fix-infinite-loop.patch
spi_mpc83xx-hang-fix.patch
drivers-edac-fix-printk-level-down-to-debug-from-emerg.patch
drivers-edac-fix-e752x-correct-return-code.patch
bcm1480-serial-build-fix.patch
pnp-remove-smcf010-quirk.patch
md-fix-some-bugs-with-growing-raid5-raid6-arrays.patch
mntput-called-before-dput-in-afs.patch
fix-dac960-driver-on-machines-which-dont-support-64-bit-dma.patch
fix-dac960-driver-on-machines-which-dont-support-64-bit-dma-fix.patch
documentation-00-index-notice-ecryptfstxt-moved.patch
h8-300-fix-misnamed-config_blkdev_reserve_address-kconfig-variable.patch
rtc-v3020-fixes.patch
ptr_align.patch
fix-typo-in-documentation-submittingpatches.patch
futex_compat-fix-list-traversal-bugs.patch
tty-termios-locking-functions-break-with-new-termios.patch
restore-call_usermodehelper_pipe-behaviour.patch
fix-select-on-proc-files-without-poll.patch
m68knommu-add-missing-syscalls.patch
intel_agp-fix-stolen-mem-range-on-g33.patch
intel_agp-fix-gtt-map-size-on-g33.patch
bug-in-at91-mci-suspend-routines.patch
leases-can-be-hidden-by-flocks.patch
fix-no_sync_cmos_clock-logic-inversion-in-kernel-time-ntpc.patch
revert-highmem-catch-illegal-nesting.patch
slub-accurately-compare-debug-flags-during-slab-cache-merge.patch
intel-fb-pixel-clock-calculation-fix.patch
fix-serial_core_console-driver-dependencies.patch
timekeeping-prevent-time-going-backwards-on-resume.patch
timekeeping-prevent-time-going-backwards-on-resume-v2.patch
uml-use-correct-type-in-blkgetsize-ioctl.patch
atyfb-force-29mhz-xtal-on-g3-powerbooks.patch
sparc64-and-others-fix-tty_ioctlc-build.patch
lguest-fix-guest-crash-when-config_x86_use_3dnow=y.patch
leds-add-include-linux-spinlock_typesh-to.patch
fix-failure-to-resume-from-initrds.patch
fix-uts-corruption-during-cloneclone_newuts.patch
fix-build-with-config_compat=y-and-config_block=n.patch
rtc-ds1742c-should-use-resource_size_t-for-base-address.patch
rtc-rtc-ds1553c-should-use-resource_size_t-for-base.patch
mspec-handle-shrinking-virtual-memory-areas.patch


