Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbZCLVdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbZCLVdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 17:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755681AbZCLVdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 17:33:15 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:2414 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbZCLVdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 17:33:14 -0400
Date: Thu, 12 Mar 2009 15:33:11 -0600
From: Alex Chiang <achiang@hp.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <gregkh@suse.de>, Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] sysfs: only allow one scheduled removal callback
	per kobj
Message-ID: <20090312213311.GB31042@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <gregkh@suse.de>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
	jbarnes@virtuousgeek.org, tj@kernel.org,
	linux-kernel@vger.kernel.org
References: <20090310232027.GC25665@ldl.fc.hp.com> <20090311044151.GB25840@suse.de> <20090311070359.GF25665@ldl.fc.hp.com> <20090311153228.GA21217@suse.de> <20090311184729.110761e4@gondolin> <20090311181904.GA10309@suse.de> <20090311184225.GC23138@ldl.fc.hp.com> <20090312112536.734ca15b@gondolin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312112536.734ca15b@gondolin>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Cornelia Huck <cornelia.huck@de.ibm.com>:
> On Wed, 11 Mar 2009 Alex Chiang <achiang@hp.com> wrote:
> 
> > * Greg KH <gregkh@suse.de>:
> > > On Wed, Mar 11, 2009 Cornelia Huck wrote:
> > > > (For the original oops, I'd rather solve the problem by
> > > > making sure the caller doesn't trigger removal several
> > > > times - should probably be less code than the proposed
> > > > patch?)
> > > 
> > > Any ideas on how to do this?
> > 
> > I still think the original patch I proposed is the right
> > answer.
> 
> How about just putting a marker on your device that is going to
> be unregistered and refusing to schedule it again? (This marker
> could also be used to block other undesired actions; that's
> what ccwgroup does.)
 
I looked at what ccwgroup does, and you're right that it's a
smaller patch, and easy to implement.

But I still think that it makes more sense to fix the underlying
sysfs_schedule_callback() interface, rather than asking all the
callers to implement their own exclusion mechanisms.

Thanks.

/ac

