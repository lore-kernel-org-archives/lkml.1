Return-Path: <linux-kernel-owner+w=401wt.eu-S1030298AbXCHIlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030298AbXCHIlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030302AbXCHIln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:41:43 -0500
Received: from gw.goop.org ([64.81.55.164]:38168 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030298AbXCHIll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:41:41 -0500
Message-ID: <45EFCC3C.5090201@goop.org>
Date: Thu, 08 Mar 2007 00:41:32 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: tglx@linutronix.de, Dan Hecht <dhecht@vmware.com>,
       Zachary Amsden <zach@vmware.com>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com> <1173228544.24738.514.camel@localhost.localdomain> <45EE0D10.7070807@vmware.com> <1173230305.24738.529.camel@localhost.localdomain> <45EE1EA3.90803@vmware.com> <1173256666.24738.576.camel@localhost.localdomain> <45EEF966.6060902@goop.org> <1173300032.24738.750.camel@localhost.localdomain> <45EF2991.1020204@goop.org> <20070308080131.GB9295@elte.hu>
In-Reply-To: <20070308080131.GB9295@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> you are obsessed with avoiding a hypercall, but why? Granted it's slow 
> especially on things like SVN/VMX, but it's not fundamentally slow. We 
> definitely do not want to design our whole APIs and abstractions around 
> the temporary notion that 'hypercalls are slow'.

Sure.  But the specific case we're talking about here is a 300 line
clock driver.  Nothing about its implementation has any effect on the
kernel's APIs or abstractions.

>  I'd expect hypercalls 
> to be put into silicon just as much as SYSENTER was put into silicon. 
>   
Sysenter is marginally faster than int $80, but not massively so.  I
guess Xen could use sysenter now for hypercalls, since its only useful
for getting into ring 0.

> Anyway, in terms of guest time code, a /big/ amount of design junk can 
> be avoided by not trying to do sillynesses like 'virtual time'. 
Well, if you have a hypervisor scheduler multiplexing vcpus onto a real
cpu at 100hz and a kernel scheduler multiplexing processes onto a vcpu
at 100hz, then you're going to get a lot of disappointed processes who
nominally got their 10ms real-time slice, but it was all spent on some
other vcpu.   Its important that the kernel's scheduler know how much
vcpu time each process really got, rather than basing its scheduling on
the amount of real time that passed.

> The TSC 
> is awfully unreliable.
>   
Sure.

> /THIS/ is the kind of junk we are trying to protect Linux against. 
>   

What?  That Xen happens to use the tsc as part of its hypervisor
interface?  A fact that's completely isolated from the rest of the
kernel behind the clock subsystem?

    J
