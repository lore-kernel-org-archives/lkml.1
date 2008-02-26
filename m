Return-Path: <linux-kernel-owner+w=401wt.eu-S1763553AbYBZR3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763553AbYBZR3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761547AbYBZR3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:29:31 -0500
Received: from mail2.shareable.org ([80.68.89.115]:52024 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760375AbYBZR33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:29:29 -0500
Date: Tue, 26 Feb 2008 17:29:13 +0000
From: Jamie Lokier <jamie@shareable.org>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
Message-ID: <20080226172913.GB22471@shareable.org>
References: <20080226072649.GB30238@shareable.org> <20080225234319.f4589ae4.akpm@linux-foundation.org> <20080226075921.GG30238@shareable.org> <200802262016.11297.nickpiggin@yahoo.com.au> <20080226140925.GB20428@lazybastard.org> <20080226152810.GB18118@shareable.org> <20080226170214.GA23829@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080226170214.GA23829@lazybastard.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Tue, 26 February 2008 15:28:10 +0000, Jamie Lokier wrote:
> > 
> > > One interesting aspect of this comes with COW filesystems like btrfs or
> > > logfs.  Writing out data pages is not sufficient, because those will get
> > > lost unless their referencing metadata is written as well.  So either we
> > > have to call fsync for those filesystems or add another callback and let
> > > filesystems override the default implementation.
> > 
> > Doesn't the ->fsync callback get called in the sys_fdatasync() case,
> > with appropriate arguments?
> 
> My paragraph above was aimed at the sync_file_range() case.  fsync and
> fdatasync do the right thing within the limitations you brought up in
> this thread.  sync_file_range() without further changes will only write
> data pages, not the metadata required to actually access those data
> pages.  This works just fine for non-COW filesystems, which covers all
> currently merged ones.
> 
> With COW filesystems it is currently impossible to do sync_file_range()
> properly.  The problem is orthogonal to your's, I just brought it up
> since you were already mentioning sync_file_range().

You're right.  Though, doesn't normal page writeback enqueue the COW
metadata changes?  If not, how do they get written in a timely
fashion?

-- Jamie
