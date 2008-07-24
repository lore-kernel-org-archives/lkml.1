Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbYGXDZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbYGXDZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 23:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYGXDZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 23:25:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39814
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751212AbYGXDZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 23:25:33 -0400
Date: Wed, 23 Jul 2008 20:25:33 -0700 (PDT)
Message-Id: <20080723.202533.114601491.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: sparclinux@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       lomp0101@gmx.net, linux-kernel@vger.kernel.org
Subject: Re: [Bug 11046] New: Kernel bug in mm/bootmem.c on Sparc machines
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080706132049.4019e09f.akpm@linux-foundation.org>
References: <bug-11046-27@http.bugzilla.kernel.org/>
	<20080706132049.4019e09f.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 6 Jul 2008 13:20:49 -0700

> On Sun,  6 Jul 2008 13:02:28 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=11046
 ...
> > Here is the BUG:
> > 
> > [    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.11.5 2003/11/12 10:40'
> > [    0.000000] PROMLIB: Root node compatible: 
> > [    0.000000] Linux version 2.6.25.10 (root@sparc1) (gcc version 4.1.2
> > 20061115 (prerelease) (Debian 4.1.1-21)) #5 SMP Sun Jul 6 21:05:42 CEST 2008
> > [    0.000000] console [earlyprom0] enabled
> > [    0.000000] ARCH: SUN4U
> > [    0.000000] Ethernet address: 00:03:ba:7a:f3:d6
> > [    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
> > [    0.000000] Remapping the kernel... done.
> > [    0.000000] kernel BUG at mm/bootmem.c:125!

This can only happen if you attach a zero-sized initrd to the kernel.

I see platforms like x86 sometimes have explicit checks for a zero
size to guard reserve_bootmem() and similar calls, but if that's what
callers are all going to do doesn't it make better sense for
reserve_bootmem_core() to just return instead of BUG on a zero size
argument?
