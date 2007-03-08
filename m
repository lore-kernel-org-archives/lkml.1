Return-Path: <linux-kernel-owner+w=401wt.eu-S1750755AbXCHK1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750755AbXCHK1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 05:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbXCHK1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 05:27:45 -0500
Received: from ozlabs.org ([203.10.76.45]:44044 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbXCHK1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 05:27:44 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, tglx@linutronix.de,
       Dan Hecht <dhecht@vmware.com>, Zachary Amsden <zach@vmware.com>,
       akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
       James Morris <jmorris@namei.org>
In-Reply-To: <20070308080131.GB9295@elte.hu>
References: <45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com>
	 <1173228544.24738.514.camel@localhost.localdomain>
	 <45EE0D10.7070807@vmware.com>
	 <1173230305.24738.529.camel@localhost.localdomain>
	 <45EE1EA3.90803@vmware.com>
	 <1173256666.24738.576.camel@localhost.localdomain>
	 <45EEF966.6060902@goop.org>
	 <1173300032.24738.750.camel@localhost.localdomain>
	 <45EF2991.1020204@goop.org>  <20070308080131.GB9295@elte.hu>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 21:26:54 +1100
Message-Id: <1173349614.32234.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 09:01 +0100, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > > Your implementation is almost the perfect prototype, if you move the 
> > > 128 bit hackery into the hypervisor and hide it away from the kernel 
> > > :)
> > 
> > The point is to use the tsc to avoid making any hypercalls, so dealing 
> > with the tsc->ns conversion has to happen on the guest side somehow.
> 
> you are obsessed with avoiding a hypercall, but why? Granted it's slow 
> especially on things like SVN/VMX, but it's not fundamentally slow. We 
> definitely do not want to design our whole APIs and abstractions around 
> the temporary notion that 'hypercalls are slow'. I'd expect hypercalls 
> to be put into silicon just as much as SYSENTER was put into silicon. 

Indeed, I expect them to fall somewhere between system calls and context
switches.  Perhaps not slow, but definitely worth minimising.

> Anyway, in terms of guest time code, a /big/ amount of design junk can 
> be avoided by not trying to do sillynesses like 'virtual time'. The TSC 
> is awfully unreliable.

You mean stolen time?

I find this whole discussion really irritating, to be honest.  I just
want Thomas to implement the timer code for lguest, because that code
scares me...

I look forward to your patch 8)
Rusty.


