Return-Path: <linux-kernel-owner+w=401wt.eu-S1423389AbXBPHEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423389AbXBPHEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 02:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423390AbXBPHEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 02:04:36 -0500
Received: from gw.goop.org ([64.81.55.164]:47326 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423389AbXBPHEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 02:04:36 -0500
Message-ID: <45D55784.1020000@goop.org>
Date: Thu, 15 Feb 2007 23:04:36 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Dan Hecht <dhecht@vmware.com>
CC: Andi Kleen <ak@muc.de>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Ian Pratt <ian.pratt@xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and disable
 unsupported config options.
References: <20070216022449.739760547@goop.org> <20070216022531.570154735@goop.org> <45D54BD5.8010707@vmware.com>
In-Reply-To: <45D54BD5.8010707@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Hecht wrote:
> 1) Complete the xen paravirt-ops backend so it can handle these
> "incompatible" options.  I realize this is just a matter of time (at
> least for most of them, what is your plan for PREEMPT?).

Hope it will go away?  There's some relatively deep reason to do with
migration which makes preempt very difficult to support, but I've
forgotten the details.  I've been wondering if there's some way to make
it runtime selectable without massive performance cost.

> 2) Disable the option at runtime only if the kernel is booted on Xen.
> When the kernel is booted on native, lhype, paravirt kvm, vmware, etc
> it should be not be inhibited.  This may not be feasible for all of
> these options, but as Zach pointed out, is easy enough for
> DOUBLEFAULT.  Maybe it can be done for KEXEC?  And HZ is easy to allow
> too, even though Xen will still give interrupts at 100hz -- we do this
> when you boot on VMI.  PREEMPT is probably the only real compile time
> incompatible options with Xen.  You just simply have to change the
> loop decrementors in your timer interrupt.
>
> You basically chose #2 for SMP: while your backend doesn't support it
> yet, it's not harmful to have the config option enabled; you just
> don't allow a second vcpu to startup when running on Xen.

Yes, this has been my preferred approach.  So for each of the restrictions:
PREEMPT - hard, will try to do something at runtime
HZ - I'm assuming dynticks will appear in the short term, and this will
become moot
KEXEC - there's been some work on making KEXEC and Xen play nicely
together; I was waiting to see if that matures, and/or make it runtime
switchable in the meantime
DOUBLEFAULT - not really an issue; guests won't get them under Xen (I
think) and we can ignore setting the gate pretty easily

    J
