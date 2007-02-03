Return-Path: <linux-kernel-owner+w=401wt.eu-S1946207AbXBCB6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946207AbXBCB6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 20:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946211AbXBCB6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 20:58:49 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50798 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946207AbXBCB6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 20:58:48 -0500
Date: Fri, 2 Feb 2007 17:55:04 -0800
From: Andrew Morton <akpm@osdl.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>, Stephen Hemminger <shemminger@osdl.org>,
       Frederic Riss <frederic.riss@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.20-rc7: known regressions
Message-Id: <20070202175504.a3bab5ac.akpm@linux-foundation.org>
In-Reply-To: <20070202054916.GA3754@stusta.de>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
	<20070202054916.GA3754@stusta.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007 06:49:16 +0100
Adrian Bunk <bunk@stusta.de> wrote:

> This email lists some known regressions in 2.6.20-rc7 compared to 2.6.19
> that are not yet fixed in Linus' tree.

There are still a few things hanging around.

I have these queued:

aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch
kexec-avoid-migration-of-already-disabled-irqs-ia64.patch
net-smc911x-match-up-spin-lock-unlock.patch
rtc-pcf8563-detect-polarity-of-century-bit-automatically.patch
alpha-fix-epoll-syscall-enumerations.patch
revert-blockdev-direct-io-back-to-2619-version.patch
scsi-sd-udev-accessing-an-uninitialized-scsi_disk-results-in-a-crash.patch
altix-more-acpi-prt-support.patch

which I'll get through to Linus later today.  Plus:


- x86_64-irq-simplfy-__assign_irq_vector.patch and
  x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch which
  are big and scary.  Am awaiting feedback from Andi and Eric on what to do
  with these.

- A fix from Trond for http://bugzilla.kernel.org/show_bug.cgi?id=7923. 
  Am awaiting acks to merge that.

- sky2-flow-control-off.patch from shemminger which I assume Linus will
  be merging anyway.

- v9fs_vfs_mkdir-fix-a-double-free.patch which I guess I'll merge unless
  Eric suddenly nacks it.

- I have r8169-fix-a-race-between-pci-probe-and-dev_open.patch floating
  about, but I forget its status.  

- I have efi-x86-pass-firmware-call-parameters-on-the-stack.patch, but
  I'm not sure it's right and unless something really rapid happens, we'll
  ship with that bug unfixed.

- enable-mouse-button-23-emulation-for-x86-macs.patch looks simple
  enough, but I'm waiting for Ben to wake up.

- x86-fix-vdso-mapping-for-aout-executables.patch probably works OK, but
  Andi points out that it'd be better to implement this with
  attribute-weak.  So I guess 2.6.20 will ship with non-functional a.out on
  i386, like 2.6.29.

