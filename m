Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbZEHEs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbZEHEs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 00:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZEHEst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 00:48:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:34368 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbZEHEss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 00:48:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,315,1239001200"; 
   d="scan'208";a="140548994"
Message-ID: <4A03B9AF.4020107@intel.com>
Date: Thu, 07 May 2009 21:48:47 -0700
From: Joseph Cihula <joseph.cihula@intel.com>
Reply-To: joseph.cihula@intel.com
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org
CC: chrisw@sous-sol.org, jmorris@namei.org, jbeulich@novell.com,
       peterm@redhat.com, joseph.cihula@intel.com, gang.wei@intel.com,
       shane.wang@intel.com
Subject: [RFC v3][PATCH 0a/2] intel_txt: Intel(R) Trusted Execution Technology
 support for Linux - Overview
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux community,

The following patches are to add support for Intel(R) Trusted Execution
Technology (Intel(R) TXT) and the Trusted Boot open source project (tboot).

We request your feedback and suggestions.



Intel(R) TXT Overview:
=====================

Intel's technology for safer computing, Intel(R) Trusted Execution
Technology (Intel(R) TXT), defines platform-level enhancements that
provide the building blocks for creating trusted platforms.

Intel TXT was formerly known by the code name LaGrande Technology (LT).

Intel TXT in Brief:
o  Provides dynamic root of trust for measurement (DRTM)
o  Data protection in case of improper shutdown
o  Measurement and verification of launched environment

Intel TXT is part of the vPro(TM) brand and is also available some
non-vPro systems.  It is currently available on desktop systems based on
the Q35, X38, Q45, and Q43 Express chipsets (e.g. Dell Optiplex 755, HP
dc7800, etc.) and mobile systems based on the GM45, PM45, and GS45
Express chipsets.

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
The mercurial source repo is available at
http://www.bughost.org/repos.hg/tboot.hg.

Tboot currently supports launching Xen (open source VMM/hypervisor w/
TXT support since v3.2), and now Linux kernels.


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

These patches were tested on the 2.6.30-rc4 and apply cleanly.

Patch 0a/2:  Overview and motivation (this email)
Patch 0b/2:  Details and how it works
Patch 1/2:   Fix for KVM shutdown (already sent to KVM maintainer)
Patch 2/2:   Intel TXT and tboot support


Joseph Cihula
Shane Wang
Intel Corp.

