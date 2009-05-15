Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbZEONsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbZEONsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZEONsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:48:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:43347 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbZEONsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:48:46 -0400
Subject: Re: [PATCH 3/10 -tip] x86: Add cpufeatures for Advanced Power
 Management
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
In-Reply-To: <alpine.LFD.2.00.0905122219420.3561@localhost.localdomain>
References: <1242142530.2547.11.camel@ht.satnam>
	 <1242142623.2547.13.camel@ht.satnam>  <1242142692.2547.15.camel@ht.satnam>
	 <1242142753.2547.16.camel@ht.satnam> <1242155190.2492.73.camel@ht.satnam>
	 <alpine.LFD.2.00.0905122219420.3561@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 15 May 2009 19:17:57 +0530
Message-Id: <1242395277.3082.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On Tue, 2009-05-12 at 23:04 +0200, Thomas Gleixner wrote:
> Jaswinder,
> 
> On Wed, 13 May 2009, Jaswinder Singh Rajput wrote:
> > +	/* Advanced Power Management (Function 8000_0007h), edx */
> > +	if (c->extended_cpuid_level >= 0x80000007) {
> > +		c->x86_capability[9] = cpuid_edx(0x80000007);
> 
> In the reply to [Patch 5/10] Ingo wrote:
> >> Also, open-coding x86_capability[9] like that is quite unclean. Were 
> >> we ever to reorder those bits internally, this could would break.
> 
> Do you really believe that open-coding x86_capability[9] in .../common.c
> is better than the open-coding in ../powernow-k8.c ?
> 

BTW, then how you can set x86_capability[9] in one shot ? do you want me
to set each bit with set_cpu_cap() ?

> Again, open-coding is wrong and error prone. Ingo explicitely asked for a
> helper function. All you did is moving the open-coded hard wired array
> reference to a different place.

I am sorry I did not get you, if possible can you please explain your
comment.

I made x86_capability[9] as Advanced Power Management (Function
8000_0007h), edx.
And I moved to X86_FEATURE_CONSTANT_TSC to Advanced Power Management
group as it is the part of it.

I added helper cpufeature for Advanced Power Management availability
so I set in software cpufeature array in vacuum created by
X86_FEATURE_CONSTANT_TSC.

If you have some better suggestion, please let me know.

Thanks for your guidance,
--
JSR


