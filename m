Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbXB1OFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbXB1OFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932401AbXB1OFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:05:35 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:19374 "EHLO
	outbound4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932398AbXB1OFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:05:34 -0500
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 28 Feb 2007 15:05:01 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: discuss@x86-64.org
cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] improve alternative instruction code and optimize
 get_cycles_sync
Message-ID: <20070228140501.GA19452@amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 28 Feb 2007 14:05:14.0278 (UTC)
 FILETIME=[77B63460:01C75B41]
X-WSS-ID: 69FB53942KW9300658-01-01
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

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG


