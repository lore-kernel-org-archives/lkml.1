Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbZKKPJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbZKKPJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbZKKPJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:09:05 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37987 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757285AbZKKPJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:09:04 -0500
Subject: Re: virtio: Add memory statistics reporting to the balloon driver
From: Adam Litke <agl@us.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anthony Liguori <aliguori@us.ibm.com>, agl@linux.vnet.ibm.com,
       qemu-devel@nongnu.org, Avi Kivity <avi@redhat.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200911111313.24226.rusty@rustcorp.com.au>
References: <1257782838.2835.5.camel@aglitke>
	 <200911111032.14956.rusty@rustcorp.com.au> <4AFA005C.7020607@us.ibm.com>
	 <200911111313.24226.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 11 Nov 2009 09:08:34 -0600
Message-ID: <1257952114.2876.29.camel@aglitke>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 13:13 +1030, Rusty Russell wrote:
> > It's not laziness, it's consistency.  How is actual different than free 
> > memory or any other stat?
> 
> Because it's a COLLECTION of stats.  For example, swap in should be < swap
> out.  Now, the current Linux implementation of all_vm_events() is non-atomic
> anyway, so maybe we can just document this as best-effort.  I'm saying that
> if it *is* a problem, I think we need a vq.

I can't see why we would care about the atomicity of the collection of
statistics.  Best-effort is good enough.  Any variance within the stats
will be overshadowed by the latency of the host-side management daemon.

> But it raises the question: what stats are generally useful cross-OS?  Should
> we be supplying numbers like "unused" (free) "instantly discardable" (ie.
> clean), "discardable to disk" (ie. file-backed), "discardable to swap"
> (ie. swap-backed) and "unswappable" instead?

While I see the virtue in presenting abstracted memory stats that seem
more digestible in a virtualization context, I think we should keep the
raw stats.  This concentrates the complexity in the host-side management
daemon, and allows the host daemon to make better decisions (ie. by
reacting to trends in individual statistics).  Different OSes (or
different versions of the same OS), may also have different sets of
statistics that will provide the answers that a management daemon needs.


-- 
Thanks,
Adam

