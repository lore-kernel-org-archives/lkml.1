Return-Path: <linux-kernel-owner+w=401wt.eu-S1761641AbXIZUwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641AbXIZUwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757840AbXIZUwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:52:35 -0400
Received: from xenotime.net ([66.160.160.81]:52107 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757639AbXIZUwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:52:35 -0400
Date: Wed, 26 Sep 2007 13:52:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "samson yeung" <fragmede@onepatchdown.net>
Cc: linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       alan@lxorguk.ukuu.org.uk, AndrewL733@aol.com, bbermack@alum.mit.edu,
       "Justin Mazzola Paluska" <jmp@mit.edu>
Subject: Re: [Re: NMI error and Intel S5000PSL Motherboards]
Message-Id: <20070926135229.67edd4eb.rdunlap@xenotime.net>
In-Reply-To: <c038f5910709261207k740ad130k151a9b0c8d8e48e0@mail.gmail.com>
References: <c038f5910709261207k740ad130k151a9b0c8d8e48e0@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 15:07:14 -0400 samson yeung wrote:

> Hello,
> 
> I'm working with AndrewL733 on this issue. I'm doing the git bisect right now.
> 
> scanpci -f -1 causes the problem, scanpci -f -2 and scanpci -O do not.

Does the problem always happen when scanpci is making an ioperm
syscall (as in the strace output below)?


> The driver does not even need to be loaded to have the problem
> (e1000). I have not tried the 2.6.18 driver with 2.6.20, but I have
> tried both the in-kernel driver as well as the newer driver from Intel
> with the same result.
> 
> The drive is a Seagate Barracuda 7200.9 80 Gbytes with fimware 3.AAE
> I can include hdparm -i output if it will help.
> 
> The problem is only happening on 64-bit. As noted above, I'm running
> git-bisect to test a stock kernel.org kernel. 32-bit Ubuntu does not
> exhibit the problem, I have not tested a kernel.org 32-bit kernel.
> 
-----------------------------------------------------------------------------------------
> strace: I don't know what syscall_273 does. I trimmed the output to
> include syscall 273 and the lines surrounding it. I can include the
> entirety of the strace if it will help.

Does this include trace info all the way to the end of the trace
output file?  If not, please send that part also.


> arch_prctl(ARCH_SET_FS, 0x2aca24060f50) = 0
> mprotect(0x2aca23e3b000, 12288, PROT_READ) = 0
> munmap(0x2aca238e2000, 36649)           = 0
> set_tid_address(0x2aca24060fe0)         = 10319
> syscall_273(0x2aca24060ff0, 0x18, 0x7fff87790188, 0x2aca233193c0,
> 0x2aca24060f50, 0x2aca233352b8, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1,
> 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1,
> 0x1, 0x1, 0x1, 0x1, 0x1) = 0
> rt_sigaction(SIGRTMIN, {0x2aca23e4a3a0, [], SA_RESTORER|SA_SIGINFO,
> 0x2aca23e53200}, NULL, 8) = 0
> rt_sigaction(SIGRT_1, {0x2aca23e4a2f0, [],
> SA_RESTORER|SA_RESTART|SA_SIGINFO, 0x2aca23e53200}, NULL, 8) = 0
> rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
> ioperm(0, 0x400, 0x1)                   = 0


---
~Randy
Phaedrus says that Quality is about caring.
