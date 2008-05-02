Return-Path: <linux-kernel-owner+w=401wt.eu-S1761840AbYEBHpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761840AbYEBHpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 03:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbYEBHp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 03:45:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60170 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016AbYEBHp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 03:45:27 -0400
Date: Fri, 2 May 2008 09:44:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: akpm@linux-foundation.org, jgarzik@pobox.com, muli@il.ibm.com,
       davej@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       bunk@kernel.org, linux-bugs@dell.com, linux-kernel@vger.kernel.org,
       greg@kroah.com, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] fix x86 DMI checks for PCI quirks
Message-ID: <20080502074432.GA1372@elte.hu>
References: <20080502025427.GA23757@auslistsprd01.us.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502025427.GA23757@auslistsprd01.us.dell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Domsch <Matt_Domsch@dell.com> wrote:

> fix x86 DMI checks for PCI quirks
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=10583
> https://bugzilla.redhat.com/show_bug.cgi?id=444791
> 
> Since git commit 08f1c192c3c32797068bfe97738babb3295bbf42 (between 
> kernels 2.6.22 and 2.6.23), arch/x86/pci/acpi.c has not called 
> pcibios_scan_root(), which would have called 
> arch/x86/pci/common.c:dmi_check_system().  This has prevented the 
> quirks listed in pciprobe_dmi_table[] from being checked and 
> appropriate action taken.

ugh ...

> This manifests itself in several Dell and HP servers not automatically 
> having the pci=bfsort option be applied, as well as Samsung X20 and 
> Compaq EVO N800c systems needing pci=assign-all-busses was no longer 
> automatically applied.
> 
> This patch moves the DMI tests into its own file, arch/x86/pci/dmi.c, 
> and invokes them via subsys_initcall() before pci_acpi_init(), 
> pci_legacy_init(), and pcibios_init() are called, which may rely upon 
> these tests having been executed.

Jesse Barnes (new PCI maintainer) Cc:-ed.

i'm wondering how we could avoid such mishaps in the future. This was 
broken from 2.6.23 through 2.6.25 - way too long. Perhaps we should 
create a known signature of the device tree in user-space, and somehow 
warn if the kernel changes it? Could this somehow be put into the 
kernel?

	Ingo
