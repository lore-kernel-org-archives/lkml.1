Return-Path: <linux-kernel-owner+w=401wt.eu-S965035AbXHYL6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965035AbXHYL6O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 07:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbXHYL56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 07:57:58 -0400
Received: from ozlabs.org ([203.10.76.45]:47279 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbXHYL55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 07:57:57 -0400
Subject: Re: [PATCH] Fix preemptible lazy mode bug
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       stable@kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andi Kleen <ak@suse.de>
In-Reply-To: <46CE81DC.90103@vmware.com>
References: <46CE70C8.2030005@vmware.com> <46CE8069.9070404@goop.org>
	 <46CE81DC.90103@vmware.com>
Content-Type: text/plain
Date: Sat, 25 Aug 2007 21:57:10 +1000
Message-Id: <1188043030.20041.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-23 at 23:59 -0700, Zachary Amsden wrote:
> Jeremy Fitzhardinge wrote:
> > Hm.  Doing any kind of lazy-state operation with preemption enabled is
> > fundamentally meaningless.  How does it get into a preemptable state
> >   
> 
> Agree 100%.  It is the lazy mode flush that might happen when preempt is 
> enabled, but lazy mode is disabled.  In that case, the code relies on 
> per-cpu variables, which is a bad thing to do in preemtible code.  This 
> can happen in the current code path.

Frankly, we should hoist the per-cpu state into generic paravirt code,
get rid of the FLUSH "state" and only call the lazy_mode hooks when
actually entering or exiting a lazy mode.

The only reason lguest doesn't use a per-cpu var is that guests are
currently UP only.  If that were fixed, we'd have identical VMI, Xen and
lguest lazy state handing.

Cheers,
Rusty.


