Return-Path: <linux-kernel-owner+w=401wt.eu-S1751893AbYJaLOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbYJaLOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbYJaLOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:14:31 -0400
Received: from ozlabs.org ([203.10.76.45]:36230 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbYJaLOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:14:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18698.59327.927555.732608@cargo.ozlabs.ibm.com>
Date: Fri, 31 Oct 2008 22:10:55 +1100
From: Paul Mackerras <paulus@samba.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, benh@kernel.crashing.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.28-rc1: NVRAM being corrupted on ppc64 preventing boot (bisected)
In-Reply-To: <20081031103646.GA24395@csn.ul.ie>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org>
	<20081030142632.GA15645@csn.ul.ie>
	<18698.7794.500191.189515@cargo.ozlabs.ibm.com>
	<20081031103646.GA24395@csn.ul.ie>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman writes:

> Yaboot in my case and I've heard it affected a DVD installation. I don't
> know for sure if it affects netboot but as I think it's something the
> kernel is doing, it probably doesn't matter how it gets loaded?

What changed in that commit was the contents of a couple of structures
that the firmware looks at to see what the kernel wants from
firmware.  Specifically the change was to say that the kernel (or
really the zImage wrapper) would like the firmware to be based at the
32MB point (which is what AIX uses) rather than 12MB (which was the
default on older machines).

So, as I understand it, it's not anything the kernel is actively
doing, it's how the firmware is reacting to what the kernel says it
wants.  And since we are requesting the same value as AIX (as far as I
know) I'm really surprised it caused problems.

We can revert that commit, but I still need to solve the problem that
the distros are facing, namely that their installer kernel + initramfs
images are now bigger than 12MB and can't be loaded if the firmware is
based at 12MB.  That's why I really want to understand the problem in
more detail.

> It's been pointed out that it can be "fixed" by upgrading the firmware but
> surely we can avoid breaking the machine in the first place?

Have you upgraded the firmware on the machine you saw this problem on?
If not, would you be willing to run some tests for me?

Paul.
