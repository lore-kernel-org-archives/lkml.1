Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076Ab0AWIGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab0AWIGH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 03:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318Ab0AWIGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 03:06:05 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:62001 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab0AWIF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 03:05:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=eIl6E8kNGAY47BygwWvOWdw1P3zgM+Ls0RMVe56fTLcOSVLStwoK7YCLQUIKcsOHIe
         YJv4mDNCv07ya8fUawWv+Oub4A/0B9afWUS+N7mUYloJ0Sbrt/MZxRE2XqKZtw49ajad
         9fBM4y/RB+c1CoC1rViI8vaSqR7m8uk3wFj6E=
Date: Sat, 23 Jan 2010 08:58:51 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, tglx@linutronix.de,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-tip-commits@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Aristeu Rozanski <aris@redhat.com>, Doug Thompson <norsk5@yahoo.com>
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to
 mce_cpu_specific_poll
Message-ID: <20100123075851.GA7098@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
	linux-kernel@vger.kernel.org, andi@firstfloor.org,
	tglx@linutronix.de, Andreas Herrmann <andreas.herrmann3@amd.com>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	linux-tip-commits@vger.kernel.org,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Fr??d??ric Weisbecker <fweisbec@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Aristeu Rozanski <aris@redhat.com>,
	Doug Thompson <norsk5@yahoo.com>
References: <20100121221711.GA8242@basil.fritz.box>
 <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org>
 <20100123051717.GA26471@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100123051717.GA26471@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding some more interested parties to Cc:)

On Sat, Jan 23, 2010 at 06:17:17AM +0100, Ingo Molnar wrote:
> 
> * tip-bot for H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > Commit-ID:  f91c4d2649531cc36e10c6bc0f92d0f99116b209
> > Gitweb:     http://git.kernel.org/tip/f91c4d2649531cc36e10c6bc0f92d0f99116b209
> > Author:     H. Peter Anvin <hpa@zytor.com>
> > AuthorDate: Thu, 21 Jan 2010 18:31:54 -0800
> > Committer:  H. Peter Anvin <hpa@zytor.com>
> > CommitDate: Thu, 21 Jan 2010 18:31:54 -0800
> > 
> > x86, mce: Rename cpu_specific_poll to mce_cpu_specific_poll
> > 
> > cpu_specific_poll is a global variable, and it should have a global
> > namespace name.  Since it is MCE-specific (it takes a struct mce *),
> > rename it mce_cpu_specific_poll.
> > 
> > Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> > Cc: Andi Kleen <andi@firstfloor.org>
> > LKML-Reference: <20100121221711.GA8242@basil.fritz.box>
> 
> FYI, this commit triggered a -tip test failure:
> 
>  arch/x86/kernel/cpu/mcheck/mce-xeon75xx.c: In function 'xeon75xx_mce_init':
>  arch/x86/kernel/cpu/mcheck/mce-xeon75xx.c:340: error: implicit declaration of function 'pci_match_id'
> 
> I'm excluding it from tip:master.
> 
> But the bigger problem with this commit is structure of it - or the lack 
> thereof.
> 
> It just blindly goes into the direction the MCE code has been going for some 
> time, minimally enabling the hardware, ignoring both the new EDAC design and 
> the new performance monitoring related design i outlined some time ago.

I completely agree - from what I see this is adding vendor- or rather
vendor-and-machine-specific hooks to read out (1) the position of the
the memory translation table from PCI config space (0x8c), (2) then to
read out the offset from the first MCA status register in order to (3)
rdmsr the status information.

In AMD's case, we need similar hooks too, in order to evaluate
correctable MCEs for different RAS reasons like for example L3 cache or
data arrays errors for disabling L3 indices. I was looking into adding
hooks into machine_check_poll() and cpu_specific_poll() interface could
work.

Furthermore, lets leave mcheck be mcheck and do error decoding in EDAC
modules. For example, there was a core i7 EDAC module submission from
Mauro and the Xeon75xx-specific decoding bits could be added to it or
even as a new machine-specific module instead of mcelog.

With the evergrowing complexity of memory controller design I don't
think that the userspace mcelog approach will scale - you need the
whole decoding in the kernel where the module knows the exact memory
controllers setup and which DRAM addresses belong to which nodes and
whether you do memory hoisting and whether you interleave, if yes, how
and on what granilarity you interleave and on and on...

I believe Ingo also had some ideas about perf_event integration and this
is something we could add to the MCE polling routine too. Ingo?

-- 
Regards/Gruss,
    Boris.
