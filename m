Return-Path: <linux-kernel-owner+w=401wt.eu-S1763803AbYEWCMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763803AbYEWCMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 22:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760412AbYEWCMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 22:12:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760368AbYEWCM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 22:12:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Mikael Pettersson <mikpe@it.uu.se>,
       Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       drepper@redhat.com, Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
In-Reply-To: Suresh Siddha's message of  Thursday, 22 May 2008 18:48:55 -0700 <20080523014855.GA18385@linux-os.sc.intel.com>
References: <18482.53246.642835.894623@harpo.it.uu.se>
	<4832E705.2010900@zytor.com>
	<18482.60491.764019.292031@harpo.it.uu.se>
	<20080520175325.GE30034@linux-os.sc.intel.com>
	<4834BE39.2000904@zytor.com>
	<18485.13663.51624.694435@harpo.it.uu.se>
	<20080522205619.GB7998@linux-os.sc.intel.com>
	<4835DF64.6080104@zytor.com>
	<20080522212920.GC7998@linux-os.sc.intel.com>
	<4835E6F5.5010801@zytor.com>
	<20080523014855.GA18385@linux-os.sc.intel.com>
Emacs: where editing text is like playing Paganini on a glass harmonica.
Message-Id: <20080523021222.8E1A626FA24@magilla.localdomain>
Date: Thu, 22 May 2008 19:12:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hmm.. so the kernel needs to export all the cpuid info (that the kernel
> enables and supports) to the user through some mechanism then?

For a cheap interface, we use AT_HWCAP for this.  Unfortunately that only
covers the first 32 bits of CPUID info.  (For another cheap interface,
giving all the CPUID bits in the vDSO would be easy.)

For a clunky interface that already exists and is "simple" to use,
there is /dev/cpu/0/cpuid now.  I wonder if having a device node and
opening it too much for applications that consider the vDSO too complex.


Thanks,
Roland
