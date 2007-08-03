Return-Path: <linux-kernel-owner+w=401wt.eu-S1762300AbXHCTXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762300AbXHCTXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 15:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbXHCTWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 15:22:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52480 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755008AbXHCTWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 15:22:55 -0400
Date: Fri, 3 Aug 2007 12:22:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Timo Jantunen <jeti@welho.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ayaz Abdulla <aabdulla@nvidia.com>
Subject: Re: 2.6.22.1: hang with forcedeth driver?
Message-Id: <20070803122241.4d242978.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708021044260.6069@limbo>
References: <Pine.LNX.4.64.0708021044260.6069@limbo>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007 11:57:21 +0300 (EEST)
Timo Jantunen <jeti@welho.com> wrote:

> Heip!
> 
> I have had few total hangs with 2.6.22.1 kernel. Everything suddenly 
> freezes and nothing works (SysRq keys, pinging the machine from the 
> network.) Neither syslog nor netconsole have any relevant messages. I'm 99% 
> sure this didn't happen in 2.6.21.x kernels.

Try enabling the NMI watchdog?  (boot with nmi_watchdog=1 on the kernel
command line) (or maybe nmi_watchdog=2).

otoh, I think NMI watchdog is always enabled on x86_64.  But the counts
aren't going up.  I forget what the story is there, apart from
lets-be-as-different-from-i386-as-we-can :(

> All hangs happened with relatively high network traffic (twice with mplayer 
> using remote display, once with high network fs activity). I copied 
> gigabytes of files over nfs but couldn't dupicatate the problem that way, 
> but OTOH I have also watched hours of video without problems so the problem 
> doesn't occur often. (In the mplayer case, the file I play is usually on 
> remote nfs disk, too.)
> 
> I started using mplayer from a text console and today I finally managed to 
> catch first bit of information. The machine hanged like before (even SysRq 
> keys don't print anything) but there was one console message:
> 
> eth0: too many iterations (6) in nv_nic_irq.
> 
> Looking at the sources, it seems when too much works happens in a single 
> interrupt, the driver tries to disable device interrupts (and prints above 
> message). It doesn't seem to be expecting the machine to hang afterwards.
> 
> I guess the quick fix for me is to increase max_interrupt_work value so it 
> doesn't get hit as easily.
> 

Well.  A Key piece of information would be: did that help?

> 
> I have nForce3 board and Athlon 64 X2 CPU (but using 32-bit kernel). I'm 
> using the built in ethernet with forcedeth driver. I also have ATI/AMD 
> binary drivers loaded, and at least in some of the cases, VMware host 
> drivers, too.
> 

