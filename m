Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbXIYSXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbXIYSXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 14:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbXIYSXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 14:23:06 -0400
Received: from mail.suse.de ([195.135.220.2]:43121 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbXIYSXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 14:23:00 -0400
Message-Id: <20070925182257.900701776@strauss.suse.de>
User-Agent: quilt/0.46-58
Date: Tue, 25 Sep 2007 20:22:57 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [patch 0/7] Add extended crashkernel command line syntax
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a extended crashkernel syntax that makes the value of reserved
system RAM dependent on the system RAM itself:

    crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
    range=start-[end]

For example:

    crashkernel=512M-2G:64M,2G-:128M

The motivation comes from distributors that configure their crashkernel command
line automatically with some configuration tool (YaST, you know ;)). Of course
that tool knows the value of System RAM, but if the user removes RAM, then
the system becomes unbootable or at least unusable and error handling
is very difficult.

This series implements this change for i386, x86_64, ia64, ppc64 and sh. That
should be all platforms that support kdump in current mainline. I tested all
platforms except sh due to the lack of a sh processor.

The patch series is against 2.6.23-rc8-mm1 and replaces following patches:

  - extended-crashkernel-command-line.patch
  - use-extended-crashkernel-command-line-on-i386.patch
  - use-extended-crashkernel-command-line-on-i386-fix-config_nohighmem-for-extended-crashkernel-command-line.patch
  - use-extended-crashkernel-command-line-on-i386-fix-config_nohighmem-for-extended-crashkernel-command-line-fix.patch
  - use-extended-crashkernel-command-line-on-x86_64.patch
  - use-extended-crashkernel-command-line-on-ia64.patch
  - use-extended-crashkernel-command-line-on-ia64-fix.patch
  - use-extended-crashkernel-command-line-on-ppc64.patch
  - use-extended-crashkernel-command-line-on-sh.patch
  - add-documentation-for-extended-crashkernel-syntax.patch
  - add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch


Modifications compared to last submit:

  - typecast to (unsigned long long) before shifting
  - small coding style adjustments
  - BUG_ON() in parse_crashkernel()
  - merge patch that adds documentation do Documentation/kernel-parameters.txt
    in documentation patch (this has been an extra patch previously)
  - fix build on IA64
  - fix build on i386 with CONFIG_NOHIGHMEM


Signed-off-by: Bernhard Walle <bwalle@suse.de>

-- 
