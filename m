Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbXKMOPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbXKMOPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 09:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbXKMOOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 09:14:52 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:8079 "EHLO
	outbound3-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbXKMOOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 09:14:51 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Tue, 13 Nov 2007 15:14:34 +0100
From: "Robert Richter" <robert.richter@amd.com>
To: "Adrian Bunk" <bunk@kernel.org>
cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "Andi Kleen" <andi@firstfloor.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge: Keep kernel/cpu for CPU specific code?
Message-ID: <20071113141434.GI18993@erda.amd.com>
References: <20071113114443.GG18993@erda.amd.com>
 <20071113120208.GC4250@stusta.de>
MIME-Version: 1.0
In-Reply-To: <20071113120208.GC4250@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 13 Nov 2007 14:14:34.0259 (UTC)
 FILETIME=[84100630:01C825FF]
X-WSS-ID: 6B276EC724S2331188-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.11.07 13:02:08, Adrian Bunk wrote:
> On Tue, Nov 13, 2007 at 12:44:43PM +0100, Robert Richter wrote:
> > x86 CPU specific code is currently implemented in different ways for
> > 64 and 32 bit. While there are almost no CPU specific files for 64
> > bit, there is the arch/x86/kernel/cpu/ directory for 32 bit. Is there
> > already an idea about whether to use kernel/cpu also for 64 bit?
> 
> It is also used for 64bit for years.

Yes, but almost all files in arch/x86/kernel/cpu/ depend on
CONFIG_X86_32.

Here is an example for similiar implementations:

arch/x86/kernel/cpu/amd.c:static void __cpuinit init_amd(struct cpuinfo_x86 *c)
arch/x86/kernel/setup_64.c:static void __cpuinit init_amd(struct cpuinfo_x86 *c)

The question is, will there be a CPU specific file such as amd.c?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


