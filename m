Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbXJISbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbXJISbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbXJISbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:31:18 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:19448 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552AbXJISbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:31:17 -0400
X-BigFish: VP
X-FB-SS: 0,
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Date: Tue, 9 Oct 2007 20:30:11 +0200
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: olecom@flower.upol.cz
cc: "LKML (Cc removed)" <linux-kernel@vger.kernel.org>
Subject: Re: coding for optimizations (Re: [PATCH 1/2] i386: mce cleanup
 part1: functional change)
Message-ID: <20071009183011.GE13205@amd.com>
References: <11919341961890-git-send-email-joerg.roedel@amd.com>
 <11919341961530-git-send-email-joerg.roedel@amd.com>
 <E1IfHZg-0003dp-FA@flower> <20071009160605.GC13205@amd.com>
 <20071009173317.GD22435@flower.upol.cz>
MIME-Version: 1.0
In-Reply-To: <20071009173317.GD22435@flower.upol.cz>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 09 Oct 2007 18:30:11.0321 (UTC)
 FILETIME=[6D34B690:01C80AA2]
X-WSS-ID: 6B15176E0601331641-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 07:33:17PM +0200, olecom@flower.upol.cz wrote:
> 	if (!mce_disabled) {
> 	if (!(c->x86_capability & (X86_FEATURE_MCA | X86_FEATURE_MCE)) {
> 		printk(KERN_INFO "CPU%i: No machine check support available\n",
>  			smp_processor_id());
> 		return;
> 	}
> 	/* function code */
> 	}

I have 2 problems with this way:

1) It is totally broken because c->x86_capability is not an integer but
   an *array* of integers. This is also the reason why test_bit() is used
   in cpu_has() and not plain logical operators.

2) It is still hard to read and breaks the kernel coding style.

But you are right with the redundant mca and mce variables. They are not
needed and I will inline the cpu_has() checks into the condition check.
I'll resubmit tomorrow.

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


