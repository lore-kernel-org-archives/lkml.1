Return-Path: <linux-kernel-owner+w=401wt.eu-S932837AbXFRXTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbXFRXTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 19:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933548AbXFRXSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 19:18:44 -0400
Received: from paragon.brong.net ([66.232.154.163]:38685 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933413AbXFRXSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 19:18:43 -0400
Date: Tue, 19 Jun 2007 09:18:36 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Chris Mason <chris.mason@oracle.com>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       alan <alan@clueserver.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070618231836.GA28851@brong.net>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <20070616145337.GA13391@lazybastard.org> <20070618094524.GF5181@schatzie.adilger.int> <20070618153238.GG2061@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618153238.GG2061@think.oraclecorp.com>
Organization: brong.net
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 11:32:38AM -0400, Chris Mason wrote:
> On Mon, Jun 18, 2007 at 03:45:24AM -0600, Andreas Dilger wrote:
> > Too bad everyone is spending time on 10 similar-but-slightly-different
> > filesystems.  This will likely end up with a bunch of filesystems that
> > implement some easy subset of features, but will not get polished for
> > users or have a full set of features implemented (e.g. ACL, quota, fsck,
> > etc).  While I don't think there is a single answer to every question,
> > it does seem that the number of filesystem projects has climbed lately.
> > 
> > Maybe there should be a BOF at OLS to merge these filesystem projects
> > (btrfs, chunkfs, tilefs, logfs, etc) into a single project with multiple
> > people working on getting it solid, scalable (parallel readers/writers on
> > lots of CPUs), robust (checksums, failure localization), recoverable, etc.
> > I thought Val's FS summits were designed to get developers to collaborate,
> > but it seems everyone has gone back to their corners to work on their own
> > filesystem?
> 
> Unfortunately, I can't do OLS this year, but anyone who wants to talk on
> these things can drop me a line and we can setup phone calls or whatever
> for planning.  Adding polish to any FS is not a one man show, and so I know
> I'll need to get more people on board to really finish btrfs off.
> 
> One of my long term goals for btrfs is to figure out the features and
> layout people are most interested in for filesystems that don't have to
> be ext* backwards compatible.  I've got a pretty good start, but I'm
> sure parts of it will change if I can get a big enough developer base.

I have no filesystem programming experience, but I am certainly
interested, and I'm spending some time reading through the code that
you've written so far.  Oh, and running it - though I'm probably going
to want to fiddle with some smaller filesystems than my entire Maildir
set if I want to make any sense of the structure dumps!

That and of course if I get involved in development I can be sure that
my favourite workload (big Cyrus installs) is well optimized for!

Actually, my biggest interest is decent unlink performance, in
particular when you are unlinking multiple items in a directory or
even the entire directory plus everything in it.  I find that to be
an incredibly slow and IO hurting operation.  We run cyr_expire
(the process in Cyrus that actually deletes expunged messages) once
per week, and only one process at a time on a machine which might have
20 otherwise busy instances of Cyrus running - because the IO hit on
those data partitions is massive.  Load average more than doubles and
the log entries for commands which took longer than a second to return
increase massively.

And this is on a Sunday when there's barely any use compared to a
weekday.

So yeah, my main interest is making unlink (especially multiple unlinks
from the same directory) into a less extreme experience.

Bron.
