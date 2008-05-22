Return-Path: <linux-kernel-owner+w=401wt.eu-S1762034AbYEVWRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762034AbYEVWRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758859AbYEVWRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:17:22 -0400
Received: from aun.it.uu.se ([130.238.12.36]:48348 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479AbYEVWRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:17:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18485.61551.199984.949174@harpo.it.uu.se>
Date: Fri, 23 May 2008 00:15:11 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Chris Wright <chrisw@sous-sol.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
In-Reply-To: <20080522213201.GF4018@sequoia.sous-sol.org>
References: <20080520015723.GD30034@linux-os.sc.intel.com>
	<4832A173.6020203@firstfloor.org>
	<18482.53246.642835.894623@harpo.it.uu.se>
	<4832E705.2010900@zytor.com>
	<18482.60491.764019.292031@harpo.it.uu.se>
	<20080520175325.GE30034@linux-os.sc.intel.com>
	<4834BE39.2000904@zytor.com>
	<18485.13663.51624.694435@harpo.it.uu.se>
	<20080522205619.GB7998@linux-os.sc.intel.com>
	<4835DF64.6080104@zytor.com>
	<20080522213201.GF4018@sequoia.sous-sol.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright writes:
 > * H. Peter Anvin (hpa@zytor.com) wrote:
 > > Suresh Siddha wrote:
 > >>
 > >> hpa, What is the virtualization problem? Are you referring to perf problem?
 > >> As you noted, regular non-rt signal handlers won't need this cpuid check. It's
 > >> needed only for those who manually look at non-rt signal frames and interpret it.
 > >> And also, they can do this check only once and not everytime.
 > >>
 > >
 > > No, relying on CPUID and vdso both have implications for virtualization.
 > 
 > hmm, what implications?  cpuid is dealt with already.

By whom?

Case in point: only a few weeks ago, we (as in LKML hackers) tried
to debug a user's bug report. Something very strange seemed to be
going on. It turned out the user was actually using a virtualisation
engine (qemu, not the latest) which presented highly inconsistent
cpuid data to the kernel, causing major confusion.

So I agree with hpa. The kernel has decided to use a particular
sigframe layout. It should communicate this to user-space in a robust
manner that is independent of how the kernel arrived at this decision.
