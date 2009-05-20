Return-Path: <linux-kernel-owner+w=401wt.eu-S1759125AbZETSeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125AbZETSeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758640AbZETScE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:32:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36182 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758664AbZETScC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:32:02 -0400
Message-ID: <4A144C4D.7070205@kernel.org>
Date: Wed, 20 May 2009 11:30:37 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 3/10 -tip] x86: Add cpufeatures for Advanced Power Management
References: <1242142530.2547.11.camel@ht.satnam>	 <1242142623.2547.13.camel@ht.satnam>  <1242142692.2547.15.camel@ht.satnam>	 <1242142753.2547.16.camel@ht.satnam> <1242155190.2492.73.camel@ht.satnam>	 <alpine.LFD.2.00.0905122219420.3561@localhost.localdomain>	 <1242395277.3082.24.camel@localhost.localdomain>	 <alpine.LFD.2.00.0905171415150.3516@localhost.localdomain>	 <1242745272.3169.13.camel@localhost.localdomain>	 <4A12E122.1020009@kernel.org> <1242803735.3260.44.camel@localhost.localdomain>
In-Reply-To: <1242803735.3260.44.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> 
> I think better I will show with the coding to get the clear picture.
> 
> Currently we are using hardcoded x86_capability as [0], [2], [4], [5].
> 
> Thomas prefer to use constant so may be we can define current system as:
> 
> enum {
> 	CPUID_0000_0001_EDX = 0,	/* 0x00000001 edx */
> 	CPUID_8000_0001_EDX,		/* 0x80000001 edx */
> 	CPUID_8086_0001_EDX,		/* 0x80860001 edx */
> 	CPUID_SOFT_MISC1,		/* Software Misc1 */
> 	CPUID_0000_0001_ECX,		/* 0x00000001 ecx */
> 	CPUID_C000_0001_EDX,		/* 0xC0000001 edx */
> 	CPUID_8000_0001_ECX,		/* 0x80000001 ecx */
> 	CPUID_SOFT_MISC2,		/* Software Misc2 */
> 	CPUID_SOFT_VIRTUAL,		/* Software Virtualization */
> };
> 

This really seems clumsy to me.  We don't refer to the individual words
all that often; and more importantly, I think it'd be hard to get rid of
all the places where the words are referenced.

I do NOT want to renumber them; therein lie madness.

	-hpa
