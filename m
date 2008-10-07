Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbYJGWrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbYJGWrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYJGWrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:47:36 -0400
Received: from mga10.intel.com ([192.55.52.92]:62325 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753932AbYJGWrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:47:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,375,1220252400"; 
   d="scan'208";a="388784746"
Message-ID: <48EBE6DE.4090509@linux.intel.com>
Date: Tue, 07 Oct 2008 15:46:54 -0700
From: Joseph Cihula <joseph.cihula@linux.intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: shane.wang@intel.com, gang.wei@intel.com, arjan@linux.intel.com,
       asit.k.mallick@intel.com, jun.nakajima@intel.com, chrisw@sous-sol.org,
       jbeulich@novell.com, mingo@elte.hu, tytso@mit.edu,
       linux-kernel@vger.kernel.org, joseph.cihula@intel.com
Subject: [RFC][PATCH 0a/3] TXT: Intel(R) Trusted Execution Technology support
 for Linux - Overview
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(re-posted with apologies for formatting and email addresses)

Linux community,

The following patches are to add support for Intel(R) Trusted Execution 
Technology (Intel(R) TXT) and the Trusted Boot open source project (tboot).

We request your feedback and suggestions.



Intel(R) TXT Overview:
=====================

Intel's technology for safer computing, Intel(R) Trusted Execution 
Technology
(Intel(R) TXT), defines platform-level enhancements that provide the 
building blocks for creating trusted platforms.

Intel TXT was formerly known by the code name LaGrande Technology (LT).

Intel TXT in Brief:
o  Provides dynamic root of trust for measurement (DRTM)
o  Data protection in case of improper shutdown o  Measurement and 
verification of launched environment

Intel TXT is part of the vPro(TM) brand and is also available some 
non-vPro systems.  It is available on systems based on the Q35 or X38 
Express chipsets (e.g. Dell Optiplex 755, HP dc7800, etc.).  However, 
TXT will be on all vPro(TM) client platforms starting this year 
(Montevina and McCreary -based), with plans for server support in the 
near future.

For more information, see http://www.intel.com/technology/security/.  
This site also has a link to the Intel TXT MLE Developers Manual, which 
has been updated for the new released platforms.

Intel TXT has been presented at various events over the past few years, 
some of which are:
      LinuxTAG 2008:  
http://www.linuxtag.org/2008/en/conf/events/vp-donnerstag/details.html?talkid=110
      TRUST2008:  
http://www.trust2008.eu/downloads/Keynote-Speakers/3_David-Grawrock_The-Front-Door-of-Trusted-Computing.pdf
      IDF 2008, Shanghai:  
http://inteldeveloperforum.com.edgesuite.net/shanghai_2008/aep/PROS003/index.html
      IDFs 2006, 2007 (I'm not sure if/where they are online)

Trusted Boot Project Overview:
=============================

Trusted Boot (tboot) is an open source, pre- kernel/VMM module that uses 
Intel TXT to perform a measured and verified launch of an OS kernel/VMM.

It is hosted on SourceForge at http://sourceforge.net/projects/tboot.

Tboot currently supports launching Xen (open source VMM/hypervisor w/ 
TXT support since v3.2), and now Linux kernels.  Linux support is 
provided in the latest (tboot-20081007) release.


Value Proposition for Linux or "Why should you care?"
=====================================================

While there are many products and technologies that attempt to measure 
or protect the integrity of a running kernel, they all assume the kernel 
is "good" to begin with.  The Integrity Measurement Architecture (IMA) 
and Linux Integrity Module interface are examples of such solutions.

To get trust in the initial kernel without using Intel TXT, a static 
root of trust must be used.  This bases trust in BIOS starting at system 
reset and requires measurement of all code executed between system reset 
through the completion of the kernel boot as well as data objects used 
by that code.  In the case of a Linux kernel, this means all of BIOS, 
any option ROMs, the bootloader and the boot config.  In practice, this 
is a lot of code/data, much of which is subject to change from boot to 
boot (e.g. changing NICs may change option ROMs).  Without reference 
hashes, these measurement changes are difficult to assess or confirm as 
benign.  This process also does not provide DMA protection, memory 
configuration/alias checks and locks, crash protection, or policy support.

By using the hardware-based root of trust that Intel TXT provides, many 
of these issues can be mitigated.  Specifically: many pre-launch 
components can be removed from the trust chain, DMA protection is 
provided to all launched components, a large number of platform 
configuration checks are performed and values locked, protection is 
provided for any data in the event of an improper shutdown, and there is 
support for policy-based execution/verification.  This provides a more 
stable measurement and a higher assurance of system configuration and 
initial state than would be otherwise possible.  Since the tboot project 
is open source, source code for almost all parts of the trust chain is 
available (excepting SMM and Intel-provided firmware).

Patchset:
========

These patches were tested on the 2.6.27-rc6 kernel and apply cleanly to 
2.6.27-rc9.

Patch 0a/3:  Overview and motivation (this email) Patch 0b/3:  Details 
and how it works
Patch 1/3:   Support for AddressRangeUnusuable ACPI memory type (already
             accepted but not in 2.6.27-rc9)
Patch 2/3:   Disable VT-d (Intel IOMMU) Protected Memory Regions (PMRs)
             (submitted to maintainer)
Patch 3/3:   Intel TXT and tboot support


Joseph Cihula
Shane Wang
Gang Wei
Intel Corp.

