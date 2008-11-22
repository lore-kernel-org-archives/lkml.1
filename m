Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbYKWJd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbYKWJd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 04:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbYKWJdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 04:33:21 -0500
Received: from ozlabs.org ([203.10.76.45]:35794 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbYKWJdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 04:33:20 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH RFC] cpu alloc cleanups and implementation improvement
Date: Sat, 22 Nov 2008 15:11:38 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200811172353.18356.rusty@rustcorp.com.au> <20081121163111.7107315e.sfr@canb.auug.org.au> <Pine.LNX.4.64.0811210842580.24965@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0811210842580.24965@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811221511.39434.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 November 2008 01:19:29 Christoph Lameter wrote:
> On Fri, 21 Nov 2008, Stephen Rothwell wrote:
> > > I would not mind if you would take over from here.
> >
> > So, should I remove the cpu_alloc tree from linux-next?
>
> I think the cpu_alloc branch itself is fine because it only contains the
> allocator and a single use case.

I think the textual conflicts kill us, but yes, they're orthgonal.

> The more invasive stuff is stage2 and the following which is not in next
> yet. The way I envision to go forward is with a gradual transition to the
> new APIs converting dynamic percpu users to use the new percpu operations
> and functionality.

Yes, and this is the real payoff (though your slub tranformation is pretty 
sweet too..).

> The whole thing becomes riskier if we directly replace all allocpercpu
> users as proposed by Rusty.
>
> Rusty, are you going to take this on?

Yes, I think I have to.  It's always risky to replace an implementation, but 
IMHO the current one was always a stopgap.

Sure, the net ones are probably going to have to revert to a boutique old-
style percpu allocator until we have growing per-cpu regions.  But Dave's 
already suggested something similar.

Thanks,
Rusty.
