Return-Path: <linux-kernel-owner+w=401wt.eu-S933102AbXCHTwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102AbXCHTwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933230AbXCHTwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:52:44 -0500
Received: from gw.goop.org ([64.81.55.164]:50572 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933102AbXCHTwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:52:43 -0500
Message-ID: <45F06989.8030207@goop.org>
Date: Thu, 08 Mar 2007 11:52:41 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Daniel Arai <arai@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       akpm@linux-foundation.org, john stultz <johnstul@us.ibm.com>,
       tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <45EF0CF5.5090305@goop.org> <45EF175D.6030609@vmware.com> <1173302503.24738.795.camel@localhost.localdomain> <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com> <1173313373.24738.937.camel@localhost.localdomain> <45EF6077.9090302@vmware.com> <20070308182456.GH19575@sequoia.sous-sol.org> <45F06720.8080901@goop.org> <20070308194740.GJ10574@sequoia.sous-sol.org>
In-Reply-To: <20070308194740.GJ10574@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> I agree with that, but I think that's esp. for things like create and launch
> new vcpu.  The IPI bit I'm not as clear on, nor running this all on native
> as well.
>   

Well, native would fall back to using the existing arch/i386 versions of
those functions, so that's reasonably straightforward.  There'll need to
be a bit of internal rearrangement so that the Xen code can call in to
do things like set up the pda/gdt and other bits of CPU state.

I don't think IPI is especially interesting in itself, is it?   It's a
necessary mechanism to implement smp_call_function(), but Xen can do IPI
without having to invoke any of the existing apic-based IPI code.  The
other main user of IPI is cross-cpu tlb shootdown, but Xen has much more
efficient mechanisms than IPI for that (so we'll need to make the tlb
pv_ops interface a little wider to pass down a cpuset).

    J
