Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbYAVHGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbYAVHGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 02:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYAVHFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 02:05:53 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:27765 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbYAVHFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 02:05:52 -0500
Date: Tue, 22 Jan 2008 00:05:11 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
In-reply-to: <20080122033830.GR155259@sgi.com>
To: David Chinner <dgc@sgi.com>
Cc: Valerie Henson <val@vahconsulting.com>, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@clusterfs.com>,
       Ric Wheeler <ric@emc.com>
Mail-followup-to: David Chinner <dgc@sgi.com>,
 Valerie Henson <val@vahconsulting.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@clusterfs.com>,
 Ric Wheeler <ric@emc.com>
Message-id: <20080122070511.GN3180@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <70b6f0bf0801161322k2740a8dch6a0d6e6e112cd2d0@mail.gmail.com>
 <70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com>
 <20080121230041.GL3180@webber.adilger.int> <20080122033830.GR155259@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 22, 2008  14:38 +1100, David Chinner wrote:
> On Mon, Jan 21, 2008 at 04:00:41PM -0700, Andreas Dilger wrote:
> > I discussed this with Ted at one point also.  This is a generic problem,
> > not just for readahead, because "fsck" can run multiple e2fsck in parallel
> > and in case of many large filesystems on a single node this can cause
> > memory usage problems also.
> > 
> > What I was proposing is that "fsck.{fstype}" be modified to return an
> > estimated minimum amount of memory needed, and some "desired" amount of
> > memory (i.e. readahead) to fsck the filesystem, using some parameter like
> > "fsck.{fstype} --report-memory-needed /dev/XXX".  If this does not
> > return the output in the expected format, or returns an error then fsck
> > will assume some amount of memory based on the device size and continue
> > as it does today.
> 
> And while fsck is running, some other program runs that uses
> memory and blows your carefully calculated paramters to smithereens?

Well, fsck has a rather restricted working environment, because it is
run before most other processes start (i.e. single-user mode).  For fsck
initiated by an admin in other runlevels the admin would need to specify
the upper limit of memory usage.  My proposal was only for the single-user
fsck at boot time.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

