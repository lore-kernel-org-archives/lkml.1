Return-Path: <linux-kernel-owner+w=401wt.eu-S932488AbXBSTBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbXBSTBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 14:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932489AbXBSTBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 14:01:52 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:40237 "EHLO
	outbound1-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932488AbXBSTBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 14:01:51 -0500
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Mon, 19 Feb 2007 20:01:32 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: discuss@x86-64.org
cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>
Subject: [PATCH 0/3] extend alternative instruction framework to support
 more than one alternative
Message-ID: <20070219190132.GA6083@amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Feb 2007 19:01:34.0068 (UTC)
 FILETIME=[5F931B40:01C75458]
X-WSS-ID: 69C72B9B2MC8619437-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this small series of patches extend the alternative instructions
framework on i386 and x86_64 architectures to support more than one
alternative per instruction. The last patch in this series includes a
first use of this extension to optimize the get_cycles_sync() function.

The extension works as follows:

The alt_instr struct is extended with 2 more fields:

	u8  used;
	u8  instr_cpuid;

which are both set to 0 for all existing entries. If an existing entry
should have more than one alternative instruction the further
alternatives are encoded in a following alt_instr structure. In this
case the 'use' variable is either 1 oder 2 in that following structure.
This encodes the number of further alternative instructions in that
struct. The first following instruction is pointed to by the *instr
pointer in the struct. Its matching cpuid field is 'instr_cpuid'. The
third alternative is encoded like the first one in the original entry
using the *replacement pointer and the cpuid field.  These following
structs could be cascaded to support an arbitrary number of alternative
instructions.  When applying the alternative instructions the sequence
of alternatives is scanned and the first matching entry wins.  The
patches should apply cleanly to recent Linus git kernels.

Regards,
Joerg

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG


