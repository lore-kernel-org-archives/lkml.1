Return-Path: <linux-kernel-owner+w=401wt.eu-S1764674AbYFFIom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764674AbYFFIom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbYFFIob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:44:31 -0400
Received: from brick.kernel.dk ([87.55.233.238]:4738 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbYFFIoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:44:30 -0400
Date: Fri, 6 Jun 2008 10:44:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
Message-ID: <20080606084426.GJ5757@kernel.dk>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com> <1212051504-12561-2-git-send-email-jens.axboe@oracle.com> <20080530112440.GN4943@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080530112440.GN4943@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30 2008, Paul E. McKenney wrote:
> On Thu, May 29, 2008 at 10:58:15AM +0200, Jens Axboe wrote:
> > This adds kernel/smp.c which contains helpers for IPI function calls. In
> > addition to supporting the existing smp_call_function() in a more efficient
> > manner, it also adds a more scalable variant called smp_call_function_single()
> > for calling a given function on a single CPU only.
> > 
> > The core of this is based on the x86-64 patch from Nick Piggin, lots of
> > changes since then. "Alan D. Brunelle" <Alan.Brunelle@hp.com> has
> > contributed lots of fixes and suggestions as well. Also thanks to
> > Paul E. McKenney <paulmck@linux.vnet.ibm.com> for reviewing RCU usage
> > and getting rid of the data allocation fallback deadlock.
> 
> Looks much improved!!!  A few suggestions for header comments, and
> there appears to be a leftover memory barrier that should now be
> removed.  With these changes:

Thanks Paul, I added the three extra comments to the kerneldoc for those
functions. And you are right about write ordering memory barrier, we
don't need that anymore.

-- 
Jens Axboe

