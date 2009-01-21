Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZAUUNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZAUUNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 15:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbZAUUN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 15:13:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:23429 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZAUUN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 15:13:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,302,1231142400"; 
   d="scan'208";a="380403053"
Subject: Re: kernel BUG at fs/ext/super.c:428
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <20090114212038.GJ6222@mit.edu>
References: <20090110003645.GA16107@linux-os.sc.intel.com>
	 <20090113164842.c6aa7095.akpm@linux-foundation.org>
	 <20090114014434.GE14730@mit.edu> <496D526D.1010402@linux.intel.com>
	 <20090114044059.GA6222@mit.edu>
	 <20090114191632.GA13114@linux-os.sc.intel.com>
	 <1231961377.14825.51.camel@laptop>  <20090114212038.GJ6222@mit.edu>
Content-Type: text/plain; charset=utf-8
Date: Wed, 21 Jan 2009 12:10:18 -0800
Message-Id: <1232568618.16682.20.camel@jamoon.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 13:20 -0800, Theodore Tso wrote:
> On Wed, Jan 14, 2009 at 08:29:37PM +0100, Peter Zijlstra wrote:
> > > 38d47c1b7075bd7ec3881141bb3629da58f88dab is first bad commit
> > > commit 38d47c1b7075bd7ec3881141bb3629da58f88dab
> > > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Date:   Fri Sep 26 19:32:20 2008 +0200
> > >
> > >     futex: rely on get_user_pages() for shared futexes
> > >
> > >     On the way of getting rid of the mmap_sem requirement for shared futexes,
> > >     start by relying on get_user_pages().
> > >
> > >     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > >     Acked-by: Nick Piggin <nickpiggin@yahoo.com.au>
> > >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > >
> > However does a futex change make ext3 crap its pants?
> 
> I agree, this doesn't make much sense.  I've looked at the patch, and
> I don't see how this would cause an ext3 orphaned-inode list handling
> problem
> 
> Are you sure the bisect was done correctly?  Have you tried reverting
> that one commit, or otherwise conclusively shown that a kernel with
> this commit fails, and one without this commit works just fine?
> 

Unfortunately, I cannot revert this patch alone from upstream git.
But I consistently see
upstream git: Always produces this oops on reboot
checkout of ﻿38d47c1b: Always produces this oops on reboot
checkout of ﻿﻿94aca1da (one patch before the above commit): Reboots fine
without the oops.

This is petty specific to the particular userspace, looks like.
I only see this on SLES10 installation. Also, I need a non-root user
logged in at least once after boot through X to see this problem. I was
always seeing this as I had autologin on local terminal and was remotely
rebooting the system. If I just boot to init 3 or boot to init 5 with no
user logged in or boot to init 5 with root logged in, I do not see this
problem.

Thanks,
Venki

