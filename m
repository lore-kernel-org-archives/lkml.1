Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbXJ0GAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbXJ0GAv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 02:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbXJ0GAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 02:00:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53920 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728AbXJ0GAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 02:00:40 -0400
Date: Fri, 26 Oct 2007 22:59:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, spamtrap@knobisoft.de,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       wfg@mail.ustc.edu.cn, torvalds@linux-foundation.org, riel@redhat.com
Subject: Re: 2.6.24-rc1: First impressions
Message-Id: <20071026225951.db374baf.akpm@linux-foundation.org>
In-Reply-To: <20071026224657.11dcf950@laptopd505.fenrus.org>
References: <796505.25770.qm@web32612.mail.mud.yahoo.com>
	<20071026152221.GA26619@elte.hu>
	<20071026122155.45ce72e7.akpm@linux-foundation.org>
	<20071026224657.11dcf950@laptopd505.fenrus.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 22:46:57 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> > > > dd1 - copy 16 GB from /dev/zero to local FS
> > > > dd1-dir - same, but using O_DIRECT for output
> > > > dd2/dd2-dir - copy 2x7.6 GB in parallel from /dev/zero to local FS
> > > > dd3/dd3-dir - copy 3x5.2 GB in parallel from /dev/zero lo local FS
> > > > net1 - copy 5.2 GB from NFS3 share to local FS
> > > > mix3 - copy 3x5.2 GB from /dev/zero to local disk and two NFS3
> > > > shares
> > > > 
> > > >  I did the numbers for 2.6.19.2, 2.6.22.6 and 2.6.24-rc1. All
> > > > units are MB/sec.
> > > > 
> > > > test           2.6.19.2     2.6.22.6    2.6.24.-rc1
> > > > ----------------------------------------------------------------
> > > > dd1                  28           50             96
> > > > dd1-dir              88           88             86
> > > > dd2              2x16.5         2x11         2x44.5
> > > > dd2-dir            2x44         2x44           2x43
> > > > dd3               3x9.8        3x8.7           3x30
> > > > dd3-dir          3x29.5       3x29.5         3x28.5
> > > > net1              30-33        50-55          37-52
> > > > mix3              17/32        25/50          96/35
> > > > (disk/combined-network)
> > > 
> > > wow, really nice results!
> > 
> > Those changes seem suspiciously large to me.  I wonder if there's less
> > physical IO happening during the timed run, and correspondingly more
> > afterwards.
> > 
> 
> another option... this is ext2.. didn't the ext2 reservation stuff get
> merged into -rc1? for ext3 that gave a 4x or so speed boost (much
> better sequential allocation pattern)
> 

Yes, one would expect that to make a large difference in dd2/dd2-dir and
dd3/dd3-dir - but only on SMP.  On UP there's not enough concurrency in the
fs block allocator for any damage to occur.

Reservations won't affect dd1 though, and that went faster too.
