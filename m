Return-Path: <linux-kernel-owner+w=401wt.eu-S2992828AbXCIPJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992828AbXCIPJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 10:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992829AbXCIPJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 10:09:31 -0500
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:37574 "EHLO
	outbound4-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992828AbXCIPJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 10:09:30 -0500
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Fri, 9 Mar 2007 16:08:25 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: discuss@x86-64.org
cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4 TRY#3] improve alternative instruction code and
 optimize get_cycles_sync
Message-ID: <20070309150825.GA13481@amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 09 Mar 2007 15:09:15.0392 (UTC)
 FILETIME=[E6E97000:01C7625C]
X-WSS-ID: 69EFA7142EW577899-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches extend the alternative instructions framework on
i386 and x86_64 architectures to support two alternative instruction
replacements. This code is used together with the introduction of the
X86_FEATURE_SYNC_RDTSC flag on i386 to simplify and optimize the
get_cycles_sync() function. The optimization changes this function to
use RDTSCP instead of CPUID;RDTSC if this instruction is available.
Don't use CPUID there is really important if the kernel runs as a KVM
guest, because this instruction is intercepted and causes an expensive
VMEXIT.

Changes to the previous submit:
 * rebased to current linus git tree
 * replaced RDTSCP usage in get_cycles_sync with the opcode to
   make it compile with older binutils

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG


