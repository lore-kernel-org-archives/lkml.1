Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbXIZC77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbXIZC77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 22:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbXIZC7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 22:59:52 -0400
Received: from xenotime.net ([66.160.160.81]:60497 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754882AbXIZC7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 22:59:51 -0400
Date: Tue, 25 Sep 2007 19:59:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: AndrewL733 <AndrewL733@aol.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: NMI error and Intel S5000PSL Motherboards
Message-Id: <20070925195946.cef5ae9d.rdunlap@xenotime.net>
In-Reply-To: <46FA3092.70108@aol.com>
References: <46FA3092.70108@aol.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 02:12:34 -0800 AndrewL733 wrote:

> We have about 100 servers based on Intel S5000PSL-SATA motherboards. 

product info (for others):
http://support.intel.com/support/motherboards/server/s5000psl/index.htm

> They have been running for anywhere between 1 and 10 months. For the 
> past few months, after updating them all to the 2.6.20.15 kernel 
> (because of a bug in the 2.6.18 kernel), we are seeing some strange NMI 
> errors. For example:
> 
> Aug 29 09:02:10 master kernel: Uhhuh. NMI received for unknown reason 30.
> Aug 29 09:02:10 master kernel: Do you have a strange power saving mode 
> enabled?
> Aug 29 09:02:10 master kernel: Dazed and confused, but trying to continue
> 
> Sometimes these errors cause a total system freeze. Most of the time the 
> systems keep running.
> 
> We have determined these errors come most frequently on machines that 
> have an Intel PCI-e Quad Port Gigabit Adapter. On machines that HAVE 
> these cards (it doesn't matter what slot they are in), the NMI errors 
> can occur as frequently as every 3-5 minutes. On machines that do NOT 
> have these Quad Port Adapters, the NMI errors occur about once per month 
> on average. (we have tried the "in-kernel" e1000 drivers, as well as 
> Intel's latest - 7.6.5).
> 
> We have also determined (through a chance discovery) that running 
> “scanpci” can 100 percent reliably reproduce the NMI error on any 
> machine that has the Quad Port NICS. Our various motherboards have 
> different Intel BIOS versions – some have Rev 70, others 74, 79 or 81. 
> They all exhibit the same behavior regardless of BIOS version.
> 
> We have reproduced this problem with:
> 
> Mandriva 2008 RC2 (2.6.22 kernel)
> Mandriva 2007 with custom 2.6.20.15 kernel
> Mandriva 2007 with custom 2.6.19.8 kernel
> Ubuntu “Feisty” with 2.6.20 kernel
> Fedora Core 7 with 2.6.22 kernel
> 
> The problem does NOT occur with any distribution running a 2.6.18 kernel 
> or lower. I.E., CentOS or SUSE 10 and also Mandriva 2007 with included 
> 2.6.17 kernel or custom-compiled 2.6.18 kernel.
> 
> We have been in contact with Intel. Their high level tech support people 
> have basically said,
> 
>     “the errors we have logged so far are pointing to a kernel issue and
>     not a hardware problem. If we [Intel] can confirm this, it will be
>     up to the kernel developer or OS system manufacturer to debug those
>     ones, as we do not perform Operating system support.”
> 
> In other words, Intel seems to be blaming the problem we are seeing on 
> something introduced starting with the 2.6.19 kernel. We are not looking 
> to blame anybody. We are only looking for a solution.
> 
> Does anybody have an idea what could be going on here, as well as what 
> the solution may be? Going back to 2.6.18 or lower is not an option.


Please provide some basic info, like:

- how much RAM
- what CPUs (be precise: use 'cat /proc/cpuinfo')
- output of 'lspci -v'
- what kind(s) of SATA drives
- are you using 32-bit or 64-bit kernel(s)

Can you test kernels from kernel.org (i.e., not vendor kernels,
  no other [unkwown] patches applied to them)?

Does tracing 'scanpci' produce any helpful information?
# strace -o scanpci.trace scanpci


---
~Randy
Phaedrus says that Quality is about caring.
