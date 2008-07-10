Return-Path: <linux-kernel-owner+w=401wt.eu-S1760785AbYGJRdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbYGJRdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758745AbYGJRdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:33:05 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59577 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759589AbYGJRdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:33:03 -0400
Date: Thu, 10 Jul 2008 12:32:46 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Kirill Korotaev <dev@parallels.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nadia.Derbey@bull.net, Andrew Morton <akpm@linux-foundation.org>,
       nick@nick-andrew.net, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 - Object creation
	with a specified id)
Message-ID: <20080710173246.GA1857@us.ibm.com>
References: <20080418054459.891481000@bull.net> <20080422193612.GA15835@martell.zuzino.mipt.ru> <1208890580.17117.14.camel@nimitz.home.sr71.net> <20080422210130.GA15937@martell.zuzino.mipt.ru> <1208904967.17117.51.camel@nimitz.home.sr71.net> <480ED9D5.1010906@parallels.com> <480FE037.2010302@cs.columbia.edu> <m1y74a7b4w.fsf@frodo.ebiederm.org> <1215709949.9398.15.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215709949.9398.15.camel@nimitz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> On Wed, 2008-07-09 at 18:58 -0700, Eric W. Biederman wrote:
> > In the worst case today we can restore a checkpoint by replaying all of
> > the user space actions that took us to get there.  That is a tedious
> > and slow approach.
> 
> Yes, tedious and slow, *and* minimally invasive in the kernel.  Once we
> have a tedious and slow process, we'll have some really good points when
> we try to push the next set of patches to make it less slow and tedious.
> We'll be able to describe an _actual_ set of problems to our fellow
> kernel hackers.
> 
> So, the checkpoint-as-a-corefile idea sounds good to me, but it
> definitely leaves a lot of questions about exactly how we'll need to do
> the restore.

Talking with Dave over irc, I kind of liked the idea of creating a new
fs/binfmt_cr.c that executes a checkpoint-as-a-coredump file.

One thing I do not like about the checkpoint-as-coredump is that it begs
us to dump all memory out into the file.  Our plan/hope was to save
ourselves from writing out most memory by:

	1. associating a separate swapfile with each container
	2. doing a swapfile snapshot at each checkpoint
	3. dumping the pte entries (/proc/self/)

If we do checkpoint-as-a-coredump, then we need userspace to coordinate
a kernel-generated coredump with a user-generated (?) swapfile snapshot.
But I guess we figure that out later.

-serge
