Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbZCEOLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbZCEOLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZCEOLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:11:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59658 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbZCEOLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:11:40 -0500
Date: Thu, 5 Mar 2009 15:11:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip V2] x86: msr architecture debug code
Message-ID: <20090305141129.GB27962@elte.hu>
References: <1236008575.3332.2.camel@localhost.localdomain> <20090302205437.GB14471@elte.hu> <1236194183.4994.9.camel@localhost.localdomain> <1236199796.3130.3.camel@localhost.localdomain> <20090305122157.GA7347@alberich.amd.com> <20090305133208.GC4322@elte.hu> <1236260891.4237.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236260891.4237.1.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Thu, 2009-03-05 at 14:32 +0100, Ingo Molnar wrote:
> > * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> >  
> > > - I've just one directory in debugfs
> > >   x86/cpu/msr/cpu0
> > >   The system has a quad-core CPU. So I guess there should be 4
> > >   directories -- one for each core.
> > 
> > Correct, most MSRs are per core - that needs to be fixed.
> 
> Ok I will support all cores in next Version.

the VFS structure should be something like:

 /debug/x86/cpu/cpu0/msr/...

I.e. first we have the CPU, then a specific CPU, and MSRs are 
attributes of that CPU (core).

Maybe the topical setup shouldnt even include 'msr' in its name 
- that way we'll be able to add non-MSR information too. I.e. 
we'd have:

 /debug/x86/cpu/cpu0/apic/...
 /debug/x86/cpu/cpu0/pmu/...
 /debug/x86/cpu/cpu0/cpu_features/...

Populated with symbolic MSR entries for the time being.

Another detail: there are MSRs that are shared between 
cores/CPUs/sockets on certain models - but that's not a big 
issue, the readouts will be mirrored.

	Ingo
