Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbXKSJBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbXKSJBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 04:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbXKSJBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 04:01:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49135 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889AbXKSJBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 04:01:32 -0500
Date: Mon, 19 Nov 2007 01:00:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Cc: "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       nfs@lists.sourceforge.net, "Andy Whitcroft" <apw@shadowen.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Jan Blunck" <jblunck@suse.de>, steved@redhat.com
Subject: Re: [BUG] 2.6.24-rc2-mm1 - kernel bug on nfs v4
Message-Id: <20071119010002.9387d36b.akpm@linux-foundation.org>
In-Reply-To: <64bb37e0711182315s1d159c80h11811acb07566f03@mail.gmail.com>
References: <473DA608.1020804@linux.vnet.ibm.com>
	<64bb37e0711170953p67d1be49lf4eaa190d662e2b4@mail.gmail.com>
	<20071117180946.GA14055@elte.hu>
	<20071117101957.7562639d.akpm@linux-foundation.org>
	<64bb37e0711171140w5f1451e0qea081a4fbc7a45f7@mail.gmail.com>
	<20071117230508.GB25905@dyad>
	<64bb37e0711181044s75fd1081sdf44dac2e060d49a@mail.gmail.com>
	<1195413486.7893.16.camel@heimdal.trondhjem.org>
	<64bb37e0711182315s1d159c80h11811acb07566f03@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 08:15:48 +0100 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:

> On Nov 18, 2007 8:18 PM, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > On Sun, 2007-11-18 at 19:44 +0100, Torsten Kaiser wrote:
> > > NFSv2/3 and NFSv4 share the same dentry_iput and so share the same
> > > unlink and sillyrename logic.
> > > But they do not share nfs_init_server()!
> > >
> > > I wonder why this doesn't blow up more violently, but only hangs...
> > >
> > > But as I don't know if it is correct to add the workqueue
> > > initialization to nfs4_init_server() or remove the nfs_sb_active /
> > > nfs_sb_deactive for the NFSv4 case, I can't offer a patch to fix this.
> > >
> > > Torsten
> >
> > I had already fixed that one in my own stack. Attached are the 3 patches
> > that I've got. 1 from SteveD, 2 fixes.
> >
> 
> Moving the init_waitqueue_head() like patch
> linux-2.6.24-006-fix_to_fix_sillyrename_bug_on_umount.dif and applying
> linux-2.6.24-007-fix_nfs_free_unlinkdata.dif lets my testcase work.
> Also lockdep no longer complains about the non-static key.
> 

Thanks.

To avoid goofups, could you please send the full fix against 2.6.24-rc2-mm1?
