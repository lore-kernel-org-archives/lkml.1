Return-Path: <linux-kernel-owner+w=401wt.eu-S966951AbXEGVGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966951AbXEGVGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966692AbXEGVGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:06:14 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:51310 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966942AbXEGVGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:06:09 -0400
Date: Mon, 7 May 2007 14:06:07 -0700
From: Andreas Dilger <adilger@clusterfs.com>
To: Theodore Tso <tytso@mit.edu>, david@lang.hm,
       Frank van Maarseveen <frankvm@frankvm.com>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: JBD: ext2online wants too many credits (744 > 256)
Message-ID: <20070507210607.GC8181@schatzie.adilger.int>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, david@lang.hm,
	Frank van Maarseveen <frankvm@frankvm.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <20070506222626.GA25632@janus> <20070507142736.GC17180@thunk.org> <Pine.LNX.4.64.0705070744350.18013@asgard.lang.hm> <20070507155021.GD17180@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507155021.GD17180@thunk.org>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 07, 2007  11:50 -0400, Theodore Tso wrote:
> On Mon, May 07, 2007 at 07:46:38AM -0700, david@lang.hm wrote:
> > On Mon, 7 May 2007, Theodore Tso wrote:
> > >We're going to have to rethink the defaults of the journal size as it
> > >relates to on-line resizing, but there might not be a lot of great
> > >answers here.  We'll also have to look at the on-line resizing code
> > >and see if there's a way to break up the resize operation into smaller
> > >transactions as a way of avoiding this problem --- but that would
> > >still leave the user stuck with a pathetically small 4M journal on a
> > >3G filesystem.
> 
> Clearly the right thing for resize2fs to do when it's doing an
> off-line resize is to just adjust the journal inode and make it
> bigger.  I'll add that to my todo list, but of course, patches to do
> that would be gratefully accepted...

For that matter, there was a paper from U. Wisconsin showing that
having the journal in the middle of the filesystem gave noticably
better performance due to lower average seek times.  If anyone is
looking at messing with the journal that is probably also a good
and easy place to start (e.g. may be as easy as just giving a goal
block of s_blocks_count / 2 to the journal create code).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

