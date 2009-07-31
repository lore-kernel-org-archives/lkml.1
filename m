Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbZGaVNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbZGaVNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZGaVNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:13:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753173AbZGaVNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:13:36 -0400
Date: Fri, 31 Jul 2009 14:11:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: oleg@redhat.com, eranian@gmail.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
Subject: Re: [RFC][PATCH] fcntl: F_[SG]ETOWN_TID
Message-Id: <20090731141122.a1939712.akpm@linux-foundation.org>
In-Reply-To: <1249029320.6391.72.camel@twins>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
	<1248869948.6987.3083.camel@twins>
	<20090729221703.GA25368@redhat.com>
	<1248953485.6391.41.camel@twins>
	<20090730192040.GA9503@redhat.com>
	<1248984003.4164.0.camel@laptop>
	<20090730202804.GA13675@redhat.com>
	<1249029320.6391.72.camel@twins>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009 10:35:20 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> In order to direct the SIGIO signal to a particular thread of a
> multi-threaded application we cannot, like suggested by the manpage, put
> a TID into the regular fcntl(F_SETOWN) call. It will still be send to
> the whole process of which that thread is part.
> 
> Since people do want to properly direct SIGIO we introduce F_SETOWN_TID,
> which functions similarly to F_SETOWN, except positive arguments are
> interpreted as TIDs and negative arguments are interpreted as PIDs.
> 
> This extension is fully bug compatible with the old F_GETOWN
> implementation in that F_GETOWN_TID will be troubled by the negative
> return value for PIDs similarly to F_GETOWN's trouble with process
> groups.

I'd be interested in seeing a bit more explanation about the "people do
want to properly direct SIGIO" thing - use cases, how the current code
causes them problems, etc.  As it stands, it's a bit of a mystery-patch.

> [ compile tested only so far ]

I will continue to lurk :)

> arch/parisc/include/asm/fcntl.h |    2 +
> fs/fcntl.c                      |   64 +++++++++++++++++++++++++++++++++-----
> include/asm-generic/fcntl.h     |    4 ++
> include/linux/fs.h              |   11 +++++-
> net/socket.c                    |    2 +-

OK.



Alpha has private definitions of F_SETSIG and F_GETSIG which are
identical to the generic ones.  That's somewhat logical, given that
alpha's F_SETOWN/F_GETOWN _differ_ from the asm-generic ones.

Alpha appears to have made the decision to spell out _all_ the F_*
flags, given that some of them are different.  That has some merit, I
guess.

But your patch broke that.
