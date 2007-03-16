Return-Path: <linux-kernel-owner+w=401wt.eu-S965970AbXCPV6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965970AbXCPV6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965976AbXCPV6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:58:17 -0400
Received: from relais.videotron.ca ([24.201.245.36]:13402 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965970AbXCPV6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:58:16 -0400
Date: Fri, 16 Mar 2007 17:58:17 -0400
From: Veronique & Vincent <vinctre@videotron.ca>
Subject: Fwd: Backport RSDL v0.31:  Updated RSDL 0.31 backport for 2.6.18.8 &
 Debian etch x86_64 RSDL 0.31 kernels availability
To: linux-kernel@vger.kernel.org
Message-id: <200703161758.17420.vinctre@videotron.ca>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-class: urn:content-classes:message
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is are the backported RSDL scheduler for a 2.6.18.8 kernel and now also for 2.6.19.7 kernel.

This release includes the original backported 2.6.20.x RSDL 0.31 patch and also has few cleanups to remove unecessary debian make-kpkg files.
This update also includes a small patch to both 2.6.18 and 2.6.19 kernels (http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.20.y.git;a=commit;h=d499ac7a3681e270074e880879d0e0a5ad0849fa).  Would a new stable release of 2.6.18 and .19 including that patch be worth it?

The provided kernels (only for Debian Etch x86_64) might be usefull to make load comparisons between Vanilla vs CK's RSDL scheduler.

Althoug I've been able to backport properly RSDL to a 2.6.18 kernel I'm currently having a bug in the 2.6.19 backported patch.  Help finding that bug would really be appreciated.  2.6.19 BUG in action picture available at http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.19/bug-2.6.19-rsdl-031.jpg

Official CK RSDL patches available at:
http://ck.kolivas.org/patches/staircase-deadline/
Latest CK RSDL 0.31 announcement:  http://lkml.org/lkml/2007/3/16/173

Again, nice work CK!

---------------------------------------------------------------------------------------------------------------------

2.6.18.8 backport RSDL 0.31 patch (contains already Ingo's SMT scheduler fix):
PATCH: http://linux-dev.qc.ec.gc.ca/kernel/rsdl/2.6.18.8-rsdl-0.31.patch
CONFIG: http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.18/CONFIG-2.6.18-003
Notes:  Didn't encountered any problems yet.

2.6.19.7 backport RSDL 0.31 patch (contains already Ingo's SMT scheduler fix):
PATCH: http://linux-dev.qc.ec.gc.ca/kernel/rsdl/2.6.19.7-rsdl-0.31.patch
CONFIG: http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.19/CONFIG-2.6.19-001
Notes:  There is currently a bug in the backported 2.6.19 RSDL 0.31 kernel.  I've attached a picture of the kernel BUG: call.  Help to trace this bug would really be appreciated since I'm not that much a kernel hacker yet!  Also note that libata PATA is not enabled and that GFS + DLM is enabled.

2.6.20.3 uses the official RSDL 0.31 from CK:
CONFIG: http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.20/CONFIG-2.6.20-001
Notes:  Uses the official RSDL 0.31 patch from CK.  Libata PATA not enabled, GFS + DLM enabled, KVM enabled.

Ingo's SMT scheduler fix (already included in stable 2.6.20.3):
http://linux-dev.qc.ec.gc.ca/kernel/rsdl/fix_SMT_scheduler_bug.patch


Pre-compiled Debian Etch 4.0 x86_64 kernels:
2.6.18.8 + SMT sched fix + RSDL 0.31:
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.18/linux-image-2.6.18.8-003-rsdl-0.31-amd64-envcan_2.6.18.8-003-rsdl-0.31_amd64.deb
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.18/linux-headers-2.6.18.8-003-rsdl-0.31-amd64-envcan_2.6.18.8-003-rsdl-0.31_amd64.deb

2.6.18.8 + SMT sched fix:
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.18/linux-image-2.6.18.8-003p1-amd64-envcan_2.6.18.8-003p1_amd64.deb
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.18/linux-headers-2.6.18.8-003p1-amd64-envcan_2.6.18.8-003p1_amd64.deb

2.6.18.8 (Vanilla):
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.18/linux-image-2.6.18.8-003-amd64-envcan_2.6.18.8-003_amd64.deb
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.18/linux-headers-2.6.18.8-003-amd64-envcan_2.6.18.8-003_amd64.deb

2.6.19.7 + SMT sched fix + RSDL 0.31:
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.19/linux-image-2.6.19.7-001-rsdl-0.31-amd64-envcan_2.6.19.7-001-rsdl-0.31_amd64.deb
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.19/linux-headers-2.6.19.7-001-rsdl-0.31-amd64-envcan_2.6.19.7-001-rsdl-0.31_amd64.deb

2.6.19.7 + SMT sched fix:
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.19/linux-image-2.6.19.7-001p1-amd64-envcan_2.6.19.7-001p1_amd64.deb
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.19/linux-headers-2.6.19.7-001p1-amd64-envcan_2.6.19.7-001p1_amd64.deb

2.6.20.3 + RSDL 0.31:
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.20/linux-image-2.6.20.3-001-rsdl-0.31-amd64-envcan_2.6.20.3-001-rsdl-0.31_amd64.deb
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.20/linux-headers-2.6.20.3-001-rsdl-0.31-amd64-envcan_2.6.20.3-001-rsdl-0.31_amd64.deb

2.6.20.3 (Vanilla)
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.20/linux-image-2.6.20.3-001-amd64-envcan_2.6.20.3-001_amd64.deb
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.20/linux-headers-2.6.20.3-001-amd64-envcan_2.6.20.3-001_amd64.deb

Comments are welcomed!

Vincent Fortier
Informatique
Environnement Canada


