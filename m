Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbXDJAI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbXDJAI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 20:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbXDJAI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 20:08:58 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53773 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753694AbXDJAIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 20:08:54 -0400
Date: Mon, 9 Apr 2007 17:05:43 -0700
Message-Id: <200704100005.l3A05hpp020590@zach-dev.vmware.com>
Subject: [PATCH 0/10] i386, VMI, BusLogic, Timer fixes for -mm
From: Zachary Amsden <zach@vmware.com>
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 10 Apr 2007 00:08:24.0926 (UTC) FILETIME=[5B8AD7E0:01C77B04]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Latest cleanups and junk from Zach's tree.  All for -mm tree.
Based off Jeremy's latest known applied patches.  If the
paravirt or VMI patches reject let me know; we are cleaning up
tree and will redo.

Otherwise, I have 4 fixes for i386; a warning fix in sysenter
which is quite serious; some less important warning removals,
and a bug with pgd locking during root creation.

Next, I tidy up the kmap_atomic_pte code, since it makes no
sense to leave it around under !HIGHMEM and being forced to
define it introduces conflicts with where things get defined
that just is ugly.

Some VMI fixes; we support COMPAT_VDSO now that the relocation
code is there, re-add the lazy MMU fix now that Jeremy's cleanups
have been applied to -mm, implement kmap_atomic_pte.

Next, re-implement the VMI timer, dropping all the NO_IDLE_HZ
code, making it dependent on NO_HZ and using the proper clockevents
infrastructure.  I am looking for feedback on this, but it works
and applies as is, and is certainly better and cleaner than the
existing code.  Hopefully I have taken as many fingers out of the
APIC pie as possible.

Finally, fix the BusLogic driver to use request_range properly.

Zach
