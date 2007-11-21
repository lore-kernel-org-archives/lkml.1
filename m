Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbXKUQPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbXKUQPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 11:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbXKUQPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 11:15:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbXKUQPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 11:15:32 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071120125029.dfd58d83.akpm@linux-foundation.org>
References: <20071120125029.dfd58d83.akpm@linux-foundation.org> <200711200953.lAK9qxjO030444@imap1.linux-foundation.org> <4742FACF.7040906@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       balbir@linux.vnet.ibm.com
Subject: Re: mm snapshot broken-out-2007-11-20-01-45.tar.gz uploaded
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 21 Nov 2007 16:15:09 +0000
Message-ID: <1082.1195661709@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


What does broken-out-2007-11-20-01-45.tar.gz apply to?  I can't get it to
apply to either Linus's current GIT tree or the 2.6.24-rc3 tree.  Both result
in errors.

On the other hand, I have managed to adjust my patches to work with the
2.6.24-rc3-mm1 applied to 2.6.24-rc3.  It builds for:

	MN10300 defconfig
	MN10300 allnoconfig
	X86_64 defconfig CONFIG_IA32_AOUT=n
	X86_64 defconfig CONFIG_IA32_AOUT=m
	X86_64 defconfig CONFIG_IA32_AOUT=y
	i386 defconfig CONFIG_BINFMT_AOUT=n
	i386 defconfig CONFIG_BINFMT_AOUT=m
	i386 defconfig CONFIG_BINFMT_AOUT=y
	sparc defconfig
	sparc64 defconfig CONFIG_BINFMT_AOUT32=n
	sparc64 defconfig CONFIG_BINFMT_AOUT32=y

It almost completely builds for MN10300 allyesconfig and allmodconfig, but for
asm/kvm.h not existing (header checking bug?) and a sample program not
compiling (uses something not provided by most arches).

Most other arches just don't compile to some extent or other for reasons that
aren't to do with my patches, but mostly due to pgtable_t not being defined.

I can even use the MN10300 defconfig kernel:

	-bash-3.00# uname -a
	Linux asb2303-4 2.6.24-rc3-mm1-g026f9b13 #3 PREEMPT Wed Nov 21 15:02:37 GMT 2007 mn10300 mn10300 mn10300 GNU/Linux

Note, however, I don't expect these modified patches to necessarily work with
Linus's kernel.  There seem to be some general changes in -mm that I don't
know whether you'll be sending them upstream or not.

David
