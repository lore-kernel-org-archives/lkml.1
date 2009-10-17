Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbZJQXGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbZJQXGx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 19:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZJQXGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 19:06:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:36031 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbZJQXGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 19:06:52 -0400
Date: Sun, 18 Oct 2009 01:06:54 +0200
From: Nick Piggin <npiggin@suse.de>
To: john stultz <johnstul@us.ibm.com>
Cc: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>,
       Clark Williams <williams@redhat.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: -rt dbench scalabiltiy issue
Message-ID: <20091017230654.GC29439@wotan.suse.de>
References: <1255723519.5135.121.camel@localhost.localdomain> <20091017004505.GI6720@linux.vnet.ibm.com> <1255741421.5135.145.camel@localhost.localdomain> <1255743456.5135.162.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255743456.5135.162.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 06:37:36PM -0700, john stultz wrote:
> Additionally looking at the perf data, it does seem the dcache_lock is
> the contention point w/ ext2 on -rt13, but with Nick's patch, the
> contention still stays mostly in the dput/path_get functions. So it
> seems its just been moved rather then eased with _my port_ of Nick's
> patch (emphasis on "my port", since with nick's patch against mainline
> there is no regression at all.. I don't want to drag Nick's patches
> through the mud here :)

No there is nothing to suggest you've done the wrong thing. The dentry
refcounting issue was always a known one, and yes looking at the ext3
profiles, ext3/jbd is adding to the refcounting  load so it is not
surprising that it has slowed down. Also -rt probably has more trouble
than mainline when you start hitting spinlock contention.

But before turning it back into an atomic, we need to see how far
the lock free path walking stuff goes (and that is not finished
yet either).

