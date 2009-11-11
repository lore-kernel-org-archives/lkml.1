Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbZKKACN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbZKKACN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 19:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbZKKACM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 19:02:12 -0500
Received: from ozlabs.org ([203.10.76.45]:37183 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758702AbZKKACM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 19:02:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: virtio: Add memory statistics reporting to the balloon driver
Date: Wed, 11 Nov 2009 10:32:14 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: agl@linux.vnet.ibm.com, qemu-devel@nongnu.org, Avi Kivity <avi@redhat.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1257782838.2835.5.camel@aglitke> <200911101312.02650.rusty@rustcorp.com.au> <4AF9E0AA.8040100@us.ibm.com>
In-Reply-To: <4AF9E0AA.8040100@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911111032.14956.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 08:22:42 am Anthony Liguori wrote:
> Rusty Russell wrote:
> > On Tue, 10 Nov 2009 03:02:06 am Adam Litke wrote:
> >   
> >> A simpler approach is to collect memory statistics in the virtio
> >> balloon driver and communicate them to the host via the device config space.
> >>     
> >
> > There are two issues I see with this.  First, there's an atomicity problem
> > since you can't tell when the stats are consistent.  Second, polling is
> > ugly.
> >
> > A stats vq might solve this more cleanly?
> >   
> 
> This turns out to not work so nicely.  You really need bidirectional 
> communication.  You need to request that stats be collected and then you 
> need to tell the hypervisor about the stats that were collected.  You 
> don't need any real correlation between requests and stat reports either.

You register an outbuf at initialization time.  The host hands it back when
it wants you to refill it with stats.

> This really models how target/actual work and I think it suggests that 
> we want to reuse that mechanism for the stats too.

Sure, I want to.  You want to.  It's simple.

But the universe is remarkably indifferent to what we want.  Is it actually
sufficient or are we going to regret our laziness?

Cheers,
Rusty.
