Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYJGLik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYJGLik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbYJGLic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:38:32 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:56400 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbYJGLic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:38:32 -0400
Date: Tue, 7 Oct 2008 17:08:15 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, jason.wessel@windriver.com,
       avi@qumranet.com, richardj_moore@uk.ibm.com, prasad@linux.vnet.ibm.com
Subject: [RFC Patch 0/9] Hardware Breakpoint interfaces
Message-ID: <20081007113815.GA23523@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	In the ensuing mails, please find the patches that provide
interfaces to use Hardware Breakpoint (or Hardware watchpoint registers)
for addresses in kernel- and user-space.

This work is primarily based on the patches that were discussed earlier
on Linux Kernel Mailing List (http://lkml.org/lkml/2007/3/2/221) through
a discussion initiated by Alan Stern and carried forward with extensive
help from Roland McGrath (copied). They now ported to the most recent
kernel version (2.6.27-rc9) along with changes to the invocation of
'@triggered' function (presently split into pre_ and post_handler
routines).

These patches add a new feature to the kernel i.e. use HW breakpoint
registers to watch kernel-space data (for read/write operations) and
kernel instructions for execute operations. The interfaces introduced
through these patches for handling HW Breakpoint registers, namely
(un)register_<kernel/user>_hw_breakpoint() are intended to serve as
core-routines that will interact with the hardware registers directly,
while the users of breakpoint registers will do so through these
interfaces. Given the large number of such users in the kernel (such
as KGDB, KVM for kernel-space), not all of them have been modified
to use the proposed interfaces - atleast in this iteration of patches.

The patches are marked as [RFC], meaning that there is plenty of
'work-in-progress' and here is a near-exhaustive list of them:

- Enable KGDB and KVM to use the register_kernel_hw_breakpoint()
  interface for their HW Breakpoint usage, in the absence of which
  they will be broken during simultaneous use.
- Stress test the patches to study the behaviour during multiple
  requests from various sources/requests beyond available number of
  registers.
- Support multiple handlers for a given breakpoint in kernel- or
  user-space address.
- Provide complete breakpoint functionality in x86 i.e. include
  breakpoints on I/O operations.
- Addition of Documentation/hw_bkpt.txt and samples/hw_breakpoint/*.c
  files for better readability.
- Code re-arrangement to avoid the #include of kernel/hw_breakpoint.c in
  arch/x86/kernel/hw_breakpoint.c

Thanks,
K.Prasad

