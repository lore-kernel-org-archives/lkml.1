Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbZKKCnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbZKKCnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 21:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758777AbZKKCnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 21:43:24 -0500
Received: from ozlabs.org ([203.10.76.45]:38136 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758785AbZKKCnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 21:43:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: virtio: Add memory statistics reporting to the balloon driver
Date: Wed, 11 Nov 2009 13:13:23 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: agl@linux.vnet.ibm.com, qemu-devel@nongnu.org, Avi Kivity <avi@redhat.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1257782838.2835.5.camel@aglitke> <200911111032.14956.rusty@rustcorp.com.au> <4AFA005C.7020607@us.ibm.com>
In-Reply-To: <4AFA005C.7020607@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911111313.24226.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 10:37:56 am Anthony Liguori wrote:
> Rusty Russell wrote:
> > You register an outbuf at initialization time.  The host hands it back when
> > it wants you to refill it with stats.
> 
> That's strangely backwards.  Guest send a stat buffer that's filled out, 
> host acks it when it wants another.  That doesn't seem bizarre to you?

Yep!  But that's a limitation of our brains, not the infrastructure ;)

Think of the stats as an infinite stream of data.  Read from it at your
leisure.  This is how, for example, console output works.

> > But the universe is remarkably indifferent to what we want.  Is it actually
> > sufficient or are we going to regret our laziness?
> 
> It's not laziness, it's consistency.  How is actual different than free 
> memory or any other stat?

Because it's a COLLECTION of stats.  For example, swap in should be < swap
out.  Now, the current Linux implementation of all_vm_events() is non-atomic
anyway, so maybe we can just document this as best-effort.  I'm saying that
if it *is* a problem, I think we need a vq.

But it raises the question: what stats are generally useful cross-OS?  Should
we be supplying numbers like "unused" (free) "instantly discardable" (ie.
clean), "discardable to disk" (ie. file-backed), "discardable to swap"
(ie. swap-backed) and "unswappable" instead?

(I just made those up, of course, but it seems like that would give a fair
indication of real memory pressure in any OS).

Thanks,
Rusty.
