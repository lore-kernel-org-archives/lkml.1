Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031Ab0ACDj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab0ACDj7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 22:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492Ab0ACDj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 22:39:58 -0500
Received: from snt0-omc3-s1.snt0.hotmail.com ([65.55.90.140]:47057 "EHLO
	snt0-omc3-s1.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751466Ab0ACDj6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 22:39:58 -0500
Message-ID: <SNT125-W37E6746BFCB2970518F659C3750@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
       <kees.cook@canonical.com>
Subject: RE: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
Date: Sat, 2 Jan 2010 19:39:57 -0800
Importance: Normal
In-Reply-To: <alpine.LFD.2.00.0912311019580.11961@localhost.localdomain>
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>,<alpine.LFD.2.00.0912311019580.11961@localhost.localdomain>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 03 Jan 2010 03:39:57.0647 (UTC) FILETIME=[6BAA9DF0:01CA8C26]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


BTW, what do you think about the recent movement by distros toward installing PAE enabled kernels by default so that the NX bit can be enabled?

When MS enabled the NX bit in XP SP2, they had the advantage of being able to select the kernel in the bootloader (which was NTLDR) that was already being used for the /PAE switch in boot.ini. So when they added support for the NX bit, they were able to detect NX capablities in the bootloader and automatically select the PAE kernel. They still limited the physical address space to 4 GB in the non-enterprise/datacenter versions of Windows which before did not support more than 4 GB of RAM due to driver issues with things like DMA. Coincidentally around this time (which was around mid to late 2004), Linux 32-bit did it too with patches released to LKML around June 2004, and 2.6.8 incorporating the patch in August 2004, around the time XP SP2 was being released. But since Linux did not have that advantage, even after the distros moved to kernel 2.6.8, they still installed and used a non-PAE kernel by default, resulting in the NX bit not being used. Now, after 5 (!) years of this situation, last year Fedora and Ubuntu added that logic to their installer. Now they detect NX and automatically install a PAE kernel.

And yes there are CPUs with PAE and NX that has no 64-bit support. Intel was mostly to blame, with the most recent being the Atom N200 series that was very commonly used in netbooks (they only recently was succeeded with the Pine Trail Atoms being all 64-bit capable). Also was very common was the original Core Duo/Solo, as well as the late 533 MHz FSB Pentium Ms (the original one did not even support PAE at all!).  Also, there was the 5x0J Prescott Pentium 4 CPUs, which was common for a period too. But it wasn't only Intel, the first AMD Semprons from 2004 to late 2005 was another CPU that lacked the 64-bit but had the NX bit. And there was the Transmeta (which Linus used to work at, but left by the time it was released) Efficeon, which was the last CPUs released by Transmeta and lasted only a short time, and the VIA C7 CPUs (VIA eventually released a Nano which was 64-bit capable).

Yuhong Bao
 		 	   		  
_________________________________________________________________
Your E-mail and More On-the-Go. Get Windows Live Hotmail Free.
http://clk.atdmt.com/GBL/go/171222985/direct/01/