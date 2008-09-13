Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbYIMEuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbYIMEuT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 00:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYIMEuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 00:50:03 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:37252 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008AbYIMEuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 00:50:01 -0400
From: Jeffrey Brian Arnold <jbarnold@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [RFC PATCH 0/9] Ksplice: Rebootless kernel updates
Date: Sat, 13 Sep 2008 00:49:46 -0400
Message-Id: <1221281397-7045-1-git-send-email-jbarnold@mit.edu>
X-Mailer: git-send-email 1.6.0
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These RFC patches add support for Ksplice [1], a rebootless update system, 
to the kernel.  I previously mentioned Ksplice to the LKML a few months 
ago [2].  The basic idea is that Ksplice can apply an update to a running 
Linux kernel based only on a source code patch and the original kernel 
source.  The Ksplice technical overview document [3] describes the design 
of Ksplice and one of the ways that Ksplice has been evaluated.

[1] http://web.mit.edu/ksplice
[2] http://lkml.org/lkml/2008/4/23/330
[3] http://web.mit.edu/ksplice/doc/ksplice.pdf

The interface between the Ksplice kernel component and the userspace 
utilities is documented in patch 6/9 of this series.  The current 
implementation of the userspace utilities is available from the Ksplice 
website and the Ksplice git repository [4].  The Ksplice userspace 
utilities transparently support both "integrated" operation (updating a 
kernel patched with this patch series) and "standalone" operation 
(updating a completely unmodified kernel).

[4] http://web.mit.edu/ksplice/ksplice.git

This series of patches depends upon the -ffunction-sections and 
-fdata-sections patches proposed by Denys Vlasenko (for reasons unrelated 
to Ksplice) a few weeks ago [5].  Ksplice's 'run-pre matching' process is 
much simpler if the original kernel was compiled with -ffunction-sections 
and -fdata-sections, and so we require these compiler options for this 
patch series.  We think that requiring these options in order to build a 
kernel with integrated Ksplice support is reasonable, but we welcome 
feedback.

[5] http://lkml.org/lkml/2008/8/24/159

Denys Vlasenko has already submitted patches to the LKML for allowing all 
architectures to compile with -ffunction-sections and -fdata-sections [5]; 
he has said that he will later submit patches making it possible to run a 
kernel with these options [6].  In the meantime, we have a patch that 
creates a CONFIG_FUNCTION_DATA_SECTIONS option for x86 and ARM [7], but we 
have not polished this patch since Denys Vlasenko is already preparing a 
similar change.

[6] http://lkml.org/lkml/2008/8/26/288
[7] http://web.mit.edu/ksplice/tmp/function-data-sections.patch

We're open to suggestions and are available to make whatever changes 
people would like to see.  (Also, I'll be at the Plumbers Conference next 
week and would be happy to chat with anyone about Ksplice in person).

Jeff Arnold
jbarnold@mit.edu

--

Documentation/ksplice.txt      |  247 +++++
MAINTAINERS                    |   10 +
arch/Kconfig                   |   14 +
arch/arm/Kconfig               |    1 +
arch/arm/kernel/ksplice-arch.c |   79 ++
arch/x86/Kconfig               |    1 +
arch/x86/kernel/ksplice-arch.c |   91 ++
arch/x86/mm/init_32.c          |    7 +-
arch/x86/mm/init_64.c          |    5 +-
include/linux/kallsyms.h       |   13 +
include/linux/ksplice.h        |  202 ++++
include/linux/module.h         |   27 +
kernel/Makefile                |    2 +
kernel/kallsyms.c              |   19 +
kernel/ksplice.c               | 1997 ++++++++++++++++++++++++++++++++++++++++
kernel/module.c                |  144 ++-
kernel/sched.c                 |    1 +
17 files changed, 2810 insertions(+), 50 deletions(-)
