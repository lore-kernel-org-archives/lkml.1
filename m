Return-Path: <linux-kernel-owner+w=401wt.eu-S934002AbYAaWEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002AbYAaWEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757422AbYAaWE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:04:29 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:33448 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756176AbYAaWE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:04:28 -0500
Date: Thu, 31 Jan 2008 23:04:30 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg KH <gregkh@suse.de>, Adrian Bunk <bunk@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/11] fix 25 section mismatch warnings..
Message-ID: <20080131220430.GA4874@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following set of patches fixes 25 Section mismatch warnings
in following directories:

kernel/
mm/
drivers/pci
arch/x86/

When build individually they are now clean.

The shortlog:

Sam Ravnborg (11):
      pci: fix section mismatch warnings referring to pci_do_scan_bus
      pci: fix 4x section mismatch warnings
      cpu: fix section mismatch warnings for enable_nonboot_cpus
      cpu: fix section mismatch related to cpu_chain
      cpu: do not annotate exported register_cpu_notifier()
      cpu: silence section mismatch warnings for hotcpu notifies
      mm: fix section mismatch warning in sparse.c
      x86: fix section mismatch warning in acpi/boot.c
      x86: silence section mismatch warning in smpboot_64.c
      x86: fix section mismatch warning in kernel/pci-calgary
      x86: fix section mismatch warnings when referencing notifiers

With these patches applied I have a clean build of arch/x86/
with an allyesconfig.

I expect Greg to pick up the pci patches - but as they conflict with
patches recently posted by Adrian a qualified selection should be made.

The cpu patches are cc:ed to Gautham R Shenoy but I think they
need to go in via Andrew.
The mm patch are cc:ed the Mel, Christoph and Andy but I think this one
should also go in via Andrew.

The x86 patches are cc:ed to the x86 gang and should all go in via the x86 tree.

I would like some extra review of the following patches:
-> The pci patches
-> x86: silence section mismatch warning in smpboot_64.c

The others are more strightforward but please eye ball them too.

For my allyesconfig build I still has 116 warnings - but this is without
Adrian's patches applied.
Of these 8 happens only when running the final check on vmlinux.o which
is due to references between the sub directories (kernel/ <-> arch/x86/kernel/)

Patches follows unnumbered as they are independent of each other.

	Sam

