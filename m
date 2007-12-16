Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbXLPSqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbXLPSqs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 13:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbXLPSqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 13:46:40 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4188 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbXLPSqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 13:46:39 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.24-rc5-mm1: problems with cat /proc/kpageflags
Date: Sun, 16 Dec 2007 19:48:41 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, davem@davemloft.net
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org> <200712161240.54594.m.kozlowski@tuxland.pl> <20071216182720.GZ19691@waste.org>
In-Reply-To: <20071216182720.GZ19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712161948.42656.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >         cat /proc/kpageflags on sparc64 causes the box to lock.
> > > I can not write on any terminal - but I can issue sysrqs and switch
> > > between consoles.
> > > 
> > > cat process hangs in read(3, ...
> > 
> > cat /proc/kpagecount produces similar symptoms. box is locked - sysrq-w sshd trace:
> > 
> > __down
> > __down_interruptible
> > kobject_get
> > lock_kernel
> > chrdev_open
> > __dentry_open
> > nameidata_to_filp
> > open_pathname
> > do_sys_open
> > sparc32_open
> > linux_sparc_syscall32
> 
> Perhaps this is related to sparsemem.
> 
> Can you change line 710 of fs/proc/proc_misc.c to:
> 
> 	ppage = NULL;

Sure.

> ..and see if it still breaks?

Yes it does - the same way as eariler. Box is locked, processes stuck in D state
and after a while "BUG: soft lockup - CPU#0 stuck for 11s!".


