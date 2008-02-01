Return-Path: <linux-kernel-owner+w=401wt.eu-S1761621AbYBAV2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761621AbYBAV2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758226AbYBAV2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:28:03 -0500
Received: from [212.12.190.188] ([212.12.190.188]:55698 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757815AbYBAV2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:28:00 -0500
From: Al Boldi <a1426z@gawab.com>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Date: Sat, 2 Feb 2008 00:26:00 +0300
User-Agent: KMail/1.5
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@sun.com>,
       Chris Snook <csnook@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200801242336.00340.a1426z@gawab.com> <20080131171040.GL1461@duck.suse.cz> <200801311214.55287.chris.mason@oracle.com>
In-Reply-To: <200801311214.55287.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200802020026.00998.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
> On Thursday 31 January 2008, Jan Kara wrote:
> > On Thu 31-01-08 11:56:01, Chris Mason wrote:
> > > On Thursday 31 January 2008, Al Boldi wrote:
> > > > The big difference between ordered and writeback is that once the
> > > > slowdown starts, ordered goes into ~100% iowait, whereas writeback
> > > > continues 100% user.
> > >
> > > Does data=ordered write buffers in the order they were dirtied?  This
> > > might explain the extreme problems in transactional workloads.
> >
> >   Well, it does but we submit them to block layer all at once so
> > elevator should sort the requests for us...
>
> nr_requests is fairly small, so a long stream of random requests should
> still end up being random IO.
>
> Al, could you please compare the write throughput from vmstat for the
> data=ordered vs data=writeback runs?  I would guess the data=ordered one
> has a lower overall write throughput.

That's what I would have guessed, but it's actually going up 4x fold for 
mysql from 559mb to 2135mb, while the db-size ends up at 549mb.

This may mean that data=ordered isn't buffering redundant writes; or worse.


Thanks!

--
Al

