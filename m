Return-Path: <linux-kernel-owner+w=401wt.eu-S1764665AbXJOLuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764665AbXJOLuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759672AbXJOLup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:50:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758768AbXJOLuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:50:44 -0400
Message-Id: <20071015115042.391348549@strauss.suse.de>
User-Agent: quilt/0.46-60
Date: Mon, 15 Oct 2007 13:50:42 +0200
From: Bernhard Walle <bwalle@suse.de>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, ak@suse.de
Subject: [patch 0/2] Protect crashkernel against BSS overlap
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I observed the problem that even when you choose the default 16M as
crashkernel base address and the kernel is very big, the reserved area may
overlap with the kernel BSS. Currently, this is not checked at runtime, so the
kernel just crashes when you load the panic kernel in the sys_kexec call.

This two patches check this at runtime. The patches are against current git,
but with the patches

    extended-crashkernel-command-line.patch
    extended-crashkernel-command-line-update.patch
    extended-crashkernel-command-line-comment-fix.patch
    extended-crashkernel-command-line-improve-error-handling-in-parse_crashkernel_mem.patch
    use-extended-crashkernel-command-line-on-i386.patch
    use-extended-crashkernel-command-line-on-i386-update.patch
    use-extended-crashkernel-command-line-on-x86_64.patch
    use-extended-crashkernel-command-line-on-x86_64-update.patch
    use-extended-crashkernel-command-line-on-ia64.patch
    use-extended-crashkernel-command-line-on-ia64-fix.patch
    use-extended-crashkernel-command-line-on-ia64-update.patch
    use-extended-crashkernel-command-line-on-ppc64.patch
    use-extended-crashkernel-command-line-on-ppc64-update.patch
    use-extended-crashkernel-command-line-on-sh.patch
    use-extended-crashkernel-command-line-on-sh-update.patch

from -mm tree applied since they are marked to be merged in 2.6.24.

I know that the implementation of both patches is only x86 (i386 and x86-64),
but if you agree that it's the way to go, I can add the BSS resource
and the check for all other architectures that apply.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

-- 
