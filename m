Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbYEaAPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbYEaAPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbYEaAOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:14:43 -0400
Received: from gw.goop.org ([64.81.55.164]:41358 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757071AbYEaAOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:14:42 -0400
Message-ID: <48409847.4000902@goop.org>
Date: Sat, 31 May 2008 01:13:59 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0 of 4] mm+paravirt+xen: add pte	read-modify-write	abstraction
References: <patchbomb.1211552448@localhost>	 <1211567273.7465.36.camel@bodhitayantram.eng.vmware.com>	 <483729E7.9010002@goop.org> <1211585122.7465.70.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1211585122.7465.70.camel@bodhitayantram.eng.vmware.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> We don't fault.  We write directly to the primary page tables, and clear
> the pte just like native.  We just issue all mprotect updates in the
> queue, and flush the queue when leaving lazy mmu mode.  You can't wait
> for the TLB flush, you must flush the updates before releasing the
> pagetable lock, or you could get misordered updates in an SMP system.
>   

How do you track which ptes need shadow updates?  Do you walk the entire 
pagetable on tlb flush?  Or just rebuild the shadow from scratch on demand?

    J
