Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYJQU4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYJQU4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYJQU4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:56:30 -0400
Received: from xenotime.net ([66.160.160.81]:57917 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751415AbYJQU43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:56:29 -0400
Date: Fri, 17 Oct 2008 13:56:25 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Trond.Myklebust@netapp.com, ericvh@gmail.com, jaharkes@cs.cmu.edu,
       airlied@linux.ie
Subject: Re: linux-next: Tree for October 17 (build errors/warnings)
In-Reply-To: <20081017194045.202e6271.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0810171346540.685@shark.he.net>
References: <20081017194045.202e6271.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008, Stephen Rothwell wrote:

> Today's tree will not build for powerpc allyesconfig (libc aborts the
> link due to a free() problem), sparc(32) defconfig and probably some
> other configurations.

Since I don't have time to fix all of these, I'll just list a summary of
today's randconfig build errors:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

build-r9562.out:ksysfs.c:(.text+0x21463): undefined reference to `create_proc_profile'
with CONFIG_PROC_FS=n, CONFIG_SYSFS=n

build-r9567.out:linux-next-20081017/fs/nfsctl.c:45: error: implicit declaration of function 'current_cred'

build-r9580.out:wm8400-core.c:(.text+0x5a6ab): undefined reference to `i2c_master_send'
build-r9580.out:wm8400-core.c:(.text+0x5a73e): undefined reference to `i2c_transfer'
build-r9580.out:wm8400-core.c:(.init.text+0x3443): undefined reference to `i2c_register_driver'
build-r9580.out:wm8400-core.c:(.exit.text+0x50c): undefined reference to `i2c_del_driver'
with CONFIG_I2C=m, CONFIG_MFD_WM8400=y

build-r9589.out:linux-next-20081017/net/9p/protocol.c:545: error: 'p9_debug_level' undeclared (first use in this function)
build-r9589.out:linux-next-20081017/net/9p/protocol.c:545: error: 'P9_DEBUG_PKT' undeclared (first use in this function)

build-r9599.out:linux-next-20081017/fs/coda/file.c:177: error: dereferencing pointer to incomplete type

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

and printk format warnings (omitting x86 io_apic*.c):

[on i386]
linux-next-20081017/drivers/pci/hotplug/acpiphp_ibm.c:207: warning: format '%08lx' expects type 'long unsigned int', but argument 3 has type 'long long unsigned int'

[on x86_64]
linux-next-20081017/kernel/softirq.c:218: warning: format '%d' expects type 'int', but argument 2 has type 'long int'

linux-next-20081017/drivers/gpu/drm/drm_proc.c:525: warning: format '%d' expects type 'int', but argument 3 has type 'size_t' 
linux-next-20081017/drivers/gpu/drm/drm_proc.c:533: warning: format '%9d' expects type 'int', but argument 4 has type 'size_t'

linux-next-20081017/drivers/usb/misc/vstusb.c:623: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'

linux-next-20081017/drivers/misc/intel_menlow.c:107: warning: format '%ld' expects type 'long int', but argument 3 has type 'long long unsigned int'

linux-next-20081017/drivers/pci/hotplug/acpiphp_ibm.c:207: warning: format '%08lx' expects type 'long unsigned int', but argument 3 has type 'long long unsigned int'


-- 
~Randy
