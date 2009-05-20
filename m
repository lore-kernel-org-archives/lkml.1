Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbZETHQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbZETHQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbZETHQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:16:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:52280 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbZETHQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:16:17 -0400
Subject: Re: [PATCH 3/10 -tip] x86: Add cpufeatures for Advanced Power
 Management
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
In-Reply-To: <4A12E122.1020009@kernel.org>
References: <1242142530.2547.11.camel@ht.satnam>
	 <1242142623.2547.13.camel@ht.satnam>  <1242142692.2547.15.camel@ht.satnam>
	 <1242142753.2547.16.camel@ht.satnam> <1242155190.2492.73.camel@ht.satnam>
	 <alpine.LFD.2.00.0905122219420.3561@localhost.localdomain>
	 <1242395277.3082.24.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0905171415150.3516@localhost.localdomain>
	 <1242745272.3169.13.camel@localhost.localdomain>
	 <4A12E122.1020009@kernel.org>
Content-Type: text/plain
Date: Wed, 20 May 2009 12:45:35 +0530
Message-Id: <1242803735.3260.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-19 at 09:41 -0700, H. Peter Anvin wrote:
> Jaswinder Singh Rajput wrote:
> > 
> > Peter, Ingo:
> > Do you think we need to arrange x86_capability in some order, currently
> > we are using x86_capability numbering in random order.
> > 
> 
> No.
> 

I think better I will show with the coding to get the clear picture.

Currently we are using hardcoded x86_capability as [0], [2], [4], [5].

Thomas prefer to use constant so may be we can define current system as:

enum {
	CPUID_0000_0001_EDX = 0,	/* 0x00000001 edx */
	CPUID_8000_0001_EDX,		/* 0x80000001 edx */
	CPUID_8086_0001_EDX,		/* 0x80860001 edx */
	CPUID_SOFT_MISC1,		/* Software Misc1 */
	CPUID_0000_0001_ECX,		/* 0x00000001 ecx */
	CPUID_C000_0001_EDX,		/* 0xC0000001 edx */
	CPUID_8000_0001_ECX,		/* 0x80000001 ecx */
	CPUID_SOFT_MISC2,		/* Software Misc2 */
	CPUID_SOFT_VIRTUAL,		/* Software Virtualization */
};

I was suggesting to also sort it out based on address and register like this:

enum {
	/* Hardware CPUIDs */
	CPUID_0000_0001_ECX = 0,	/* 0x00000001 ecx */
	CPUID_0000_0001_EDX,		/* 0x00000001 edx */
	CPUID_8000_0001_ECX,		/* 0x80000001 ecx */
	CPUID_8000_0001_EDX,		/* 0x80000001 edx */
	CPUID_8086_0001_EDX,		/* 0x80860001 edx */
	CPUID_C000_0001_EDX,		/* 0xC0000001 edx */

	/* Software/Miscellaneous CPUIDs */
	CPUID_SOFT_MISC1,		/* Software Misc1 */
	CPUID_SOFT_MISC2,		/* Software Misc2 */
	CPUID_SOFT_VIRTUAL,		/* Software Virtualization */
};

Do you have some better suggestion.

Thanks,

--
JSR

