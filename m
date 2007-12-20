Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbXLTLvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbXLTLvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 06:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbXLTLvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 06:51:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44743
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753545AbXLTLvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:51:06 -0500
Date: Thu, 20 Dec 2007 03:51:04 -0800 (PST)
Message-Id: <20071220.035104.240386115.davem@davemloft.net>
To: mtk.manpages@googlemail.com
Cc: akpm@linux-foundation.org, lkml@davidb.org, paulus@samba.org,
       drepper@redhat.com, cfriesen@nortel.com, schwab@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
From: David Miller <davem@davemloft.net>
In-Reply-To: <476A53D4.7040909@gmail.com>
References: <4733206C.8030903@nortel.com>
	<4734A4D9.3090907@redhat.com>
	<476A53D4.7040909@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Kerrisk <mtk.manpages@googlemail.com>
Date: Thu, 20 Dec 2007 12:36:52 +0100

> Some testing just now shows me that lseek() on /dev/mem suffers similar
> problems when seeking to bytes 0xfffff001 through to 0xffffffff.

Only on x86 platforms.  Sparc, IA64, MIPS, powerpc, etc. all get this
case right.

Yes it's another unfortunate side effect of how error status is
indicated for x86 system calls.

I would suggest, that we put something in place to fix this
in the long term:

1) Start setting the condition codes properly to indicate
   error in the system call return path on x86 like other
   platforms do now.  Make sure that it tips off on
   force_successful_syscall_return(), as needed.

2) Come up with a transition plan for glibc et al. to take
   advantage of this.

It actually sounds like the kind of problem that could be
solved well using the VDSO page. :-)

