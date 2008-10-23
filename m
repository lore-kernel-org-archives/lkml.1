Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYJWXsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYJWXsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYJWXsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:48:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57525 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbYJWXsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:48:09 -0400
Message-ID: <49010D1E.8070400@zytor.com>
Date: Thu, 23 Oct 2008 16:47:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is
 set.
References: <20081021181536.GI12825@one.firstfloor.org>	 <1224616236.6161.60.camel@alok-dev1>	 <20081021192746.GJ12825@one.firstfloor.org>	 <1224703427.13953.8.camel@alok-dev1>	 <20081022195845.GP12825@one.firstfloor.org>	 <1224712846.13953.37.camel@alok-dev1>	 <20081022221316.GW12825@one.firstfloor.org>	 <1224713518.13953.46.camel@alok-dev1>	 <20081022225409.GB27492@one.firstfloor.org>	 <1224728478.13953.79.camel@alok-dev1>	 <20081023081052.GI27492@one.firstfloor.org> <1224805162.21776.45.camel@alok-dev1>
In-Reply-To: <1224805162.21776.45.camel@alok-dev1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> 
> I am ok with the CONSTANT_TSC bit check, but if people think that its
> not important to skip this for native, i think adding a new flag to skip
> this should be safe enough.
> 
> Ingo, HPA your views on this whole detection and skipping thing ? 
> 

Okay, first of all, I'm somewhat leery (to put it mildly) of trusting a 
CPUID bit to tell me a *system* property, which is that all cores in the 
system are synchronized.  The CPU designer will know that all the cores 
in the *package* are synchronized, but if that extends system-wide is a 
property beyond the CPU.  Now, if I'm not completely mistaken, in the 
case of AMD this bit is actually set by the BIOS via a magic MSR, but 
that doesn't mean it can't be wrong.

As far as skipping the check, it makes sense for me in the case of known 
virtualization platforms; a CPU feature bit, real or synthetic, is a 
very clean way to do that.  In general we should centralize CPU 
knowledge to arch/x86/kernel/cpu and have the code outside look for 
specific feature flags, and that applies to virtualization platforms, too.

	-hpa
