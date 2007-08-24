Return-Path: <linux-kernel-owner+w=401wt.eu-S933311AbXHXGxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311AbXHXGxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 02:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757671AbXHXGx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 02:53:26 -0400
Received: from gw.goop.org ([64.81.55.164]:42063 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbXHXGx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 02:53:26 -0400
Message-ID: <46CE8069.9070404@goop.org>
Date: Thu, 23 Aug 2007 23:53:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       stable@kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Fix preemptible lazy mode bug
References: <46CE70C8.2030005@vmware.com>
In-Reply-To: <46CE70C8.2030005@vmware.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> I recently sent off a fix for lazy vmalloc faults which can happen
> under paravirt when lazy mode is enabled.  Unfortunately, I jumped the
> gun a bit on fixing this.  I neglected to notice that since the new
> call to flush the MMU update queue is called from the page fault
> handler, it can be pre-empted.  Both VMI and Xen use per-cpu variables
> to track lazy mode state, as all previous calls to set, disable, or
> flush lazy mode happened from a non-preemptable state.

Hm.  Doing any kind of lazy-state operation with preemption enabled is
fundamentally meaningless.  How does it get into a preemptable state
with a lazy mode enabled now?  If a sequence of code with preempt
disabled touches a missing vmalloc mapping, it gets a fault to fix up
the mapping, and the fault handler can end up preempting the thread? 
That sounds like a larger bug than just paravirt lazy mode problems.

    J
