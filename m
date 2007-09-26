Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbXIZE63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbXIZE63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 00:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbXIZE6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 00:58:21 -0400
Received: from xenotime.net ([66.160.160.81]:46336 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752324AbXIZE6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 00:58:20 -0400
Date: Tue, 25 Sep 2007 21:58:19 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: AndrewL733 <AndrewL733@aol.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: NMI error and Intel S5000PSL Motherboards
Message-Id: <20070925215819.c993e2d8.rdunlap@xenotime.net>
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

Answer #2:  if a kernel change was responsible for this problem,
the direct way to find that change is to clone the kernel 'git' tree
and then use git bisect to find the culprit.  If you are certain
that 2.6.18 is good and 2.6.19 is bad, then use those git tree tags
instead of the ones that are used in the example at:
  http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html

git wiki is here:  http://git.or.cz/
and git docs are here:  http://www.kernel.org/pub/software/scm/git/docs/

If you want to use this tool, say so and I think that we (the royal
"we") will try to work you thru it.

---
~Randy
Phaedrus says that Quality is about caring.
