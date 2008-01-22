Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbYAVIRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbYAVIRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 03:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbYAVIRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 03:17:07 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42012 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751146AbYAVIRF (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 03:17:05 -0500
Date: Tue, 22 Jan 2008 19:16:39 +1100
From: David Chinner <dgc@sgi.com>
To: David Chinner <dgc@sgi.com>, Valerie Henson <val@vahconsulting.com>,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
       Andreas Dilger <adilger@clusterfs.com>, Ric Wheeler <ric@emc.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
Message-ID: <20080122081639.GV155259@sgi.com>
References: <70b6f0bf0801161322k2740a8dch6a0d6e6e112cd2d0@mail.gmail.com> <70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com> <20080121230041.GL3180@webber.adilger.int> <20080122033830.GR155259@sgi.com> <20080122070511.GN3180@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122070511.GN3180@webber.adilger.int>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 12:05:11AM -0700, Andreas Dilger wrote:
> On Jan 22, 2008  14:38 +1100, David Chinner wrote:
> > On Mon, Jan 21, 2008 at 04:00:41PM -0700, Andreas Dilger wrote:
> > > I discussed this with Ted at one point also.  This is a generic problem,
> > > not just for readahead, because "fsck" can run multiple e2fsck in parallel
> > > and in case of many large filesystems on a single node this can cause
> > > memory usage problems also.
> > > 
> > > What I was proposing is that "fsck.{fstype}" be modified to return an
> > > estimated minimum amount of memory needed, and some "desired" amount of
> > > memory (i.e. readahead) to fsck the filesystem, using some parameter like
> > > "fsck.{fstype} --report-memory-needed /dev/XXX".  If this does not
> > > return the output in the expected format, or returns an error then fsck
> > > will assume some amount of memory based on the device size and continue
> > > as it does today.
> > 
> > And while fsck is running, some other program runs that uses
> > memory and blows your carefully calculated paramters to smithereens?
> 
> Well, fsck has a rather restricted working environment, because it is
> run before most other processes start (i.e. single-user mode).  For fsck
> initiated by an admin in other runlevels the admin would need to specify
> the upper limit of memory usage.  My proposal was only for the single-user
> fsck at boot time.

The simple case. ;)

Because XFS has shutdown features, it's not uncommon to hear about
people running xfs_repair on an otherwise live system. e.g. XFS
detects a corrupted block, shuts down the filesystem, the admin
unmounts it, runs xfs_repair, puts it back online. meanwhile, all
the other filesystems and users continue unaffected. In this use
case, getting feedback about memory usage is, IMO, very worthwhile.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
