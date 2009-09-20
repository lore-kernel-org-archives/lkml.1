Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbZITD4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbZITD4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 23:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZITD4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 23:56:31 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:46349 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944AbZITD4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 23:56:31 -0400
Subject: Re: Paravirtualization on VMware's Platform [VMI].
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
In-Reply-To: <20090919224430.GB9567@kroah.com>
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>
	 <20090919224430.GB9567@kroah.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Sat, 19 Sep 2009 20:56:34 -0700
Message-Id: <1253418994.3253.18.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2009-09-19 at 15:44 -0700, Greg KH wrote:
> On Thu, Sep 17, 2009 at 05:17:08PM -0700, Alok Kataria wrote:
> > Given this new development, I wanted to discuss how should we go about
> > retiring the VMI code from mainline Linux, i.e. the vmi_32.c and
> > vmiclock_32.c bits.
> > 
> > One of the options that I am contemplating is to drop the code from the
> > tip tree in this release cycle, and given that this should be a low risk
> > change we can remove it from Linus's tree later in the merge cycle.
> 
> That sounds good to me, how intrusive are the patches to do this? 

It's a single patch, and the changes are pretty much self contained,
meat of the patch comprises of removing the vmi_32.c and vmiclock_32.c
file. I don't think we may want to break the changes down. 

Below are the diffstats, let me post the patch in a separate mail.

====
 Documentation/kernel-parameters.txt |    2 
 arch/x86/Kconfig                    |   10 
 arch/x86/include/asm/vmi.h          |  269 ----------
 arch/x86/include/asm/vmi_time.h     |   98 ----
 arch/x86/kernel/Makefile            |    1 
 arch/x86/kernel/setup.c             |    7 
 arch/x86/kernel/smpboot.c           |    9 
 arch/x86/kernel/vmi_32.c            |  913 -----------------------------------
 arch/x86/kernel/vmiclock_32.c       |  321 ------------
 9 files changed, 1 insertions(+), 1629 deletions(-)
 delete mode 100644 arch/x86/include/asm/vmi.h
 delete mode 100644 arch/x86/include/asm/vmi_time.h
 delete mode 100644 arch/x86/kernel/vmi_32.c
 delete mode 100644 arch/x86/kernel/vmiclock_32.c
====

>  Is it going to be tricky to get everything merged properly in -tip
> for it?

IMO, shouldn't be a problem.

Thanks,
Alok

