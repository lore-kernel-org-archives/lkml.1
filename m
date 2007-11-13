Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbXKMSAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbXKMSAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759623AbXKMSAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:00:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59733 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759915AbXKMSAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:00:20 -0500
Message-ID: <4739E612.7030601@zytor.com>
Date: Tue, 13 Nov 2007 09:59:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge: Keep kernel/cpu for CPU specific code?
References: <20071113114443.GG18993@erda.amd.com> <20071113120208.GC4250@stusta.de> <20071113141434.GI18993@erda.amd.com>
In-Reply-To: <20071113141434.GI18993@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter wrote:
> On 13.11.07 13:02:08, Adrian Bunk wrote:
>> On Tue, Nov 13, 2007 at 12:44:43PM +0100, Robert Richter wrote:
>>> x86 CPU specific code is currently implemented in different ways for
>>> 64 and 32 bit. While there are almost no CPU specific files for 64
>>> bit, there is the arch/x86/kernel/cpu/ directory for 32 bit. Is there
>>> already an idea about whether to use kernel/cpu also for 64 bit?
>> It is also used for 64bit for years.
> 
> Yes, but almost all files in arch/x86/kernel/cpu/ depend on
> CONFIG_X86_32.
> 
> Here is an example for similiar implementations:
> 
> arch/x86/kernel/cpu/amd.c:static void __cpuinit init_amd(struct cpuinfo_x86 *c)
> arch/x86/kernel/setup_64.c:static void __cpuinit init_amd(struct cpuinfo_x86 *c)
> 
> The question is, will there be a CPU specific file such as amd.c?
> 

That's my current intent, as I consider the 32-bit code cleaner even 
though Andi disagrees.  That doesn't mean it's good enough as-is, of 
course, but I would like to maintain things reasonably well separated out.

	-hpa

