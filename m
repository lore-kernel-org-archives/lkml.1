Return-Path: <linux-kernel-owner+w=401wt.eu-S964792AbZGQOFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792AbZGQOFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 10:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934673AbZGQOFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 10:05:38 -0400
Received: from fieldses.org ([174.143.236.118]:42525 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934660AbZGQOFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 10:05:37 -0400
Date: Fri, 17 Jul 2009 10:05:34 -0400
To: Sage Weil <sage@newdream.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/20] ceph: nfs re-export support
Message-ID: <20090717140534.GD10710@fieldses.org>
References: <1247693090-27796-12-git-send-email-sage@newdream.net> <1247693090-27796-13-git-send-email-sage@newdream.net> <1247693090-27796-14-git-send-email-sage@newdream.net> <1247693090-27796-15-git-send-email-sage@newdream.net> <1247693090-27796-16-git-send-email-sage@newdream.net> <1247693090-27796-17-git-send-email-sage@newdream.net> <20090716192755.GE2495@fieldses.org> <Pine.LNX.4.64.0907161241300.8026@cobra.newdream.net> <1247779311.12292.162.camel@heimdal.trondhjem.org> <Pine.LNX.4.64.0907161459360.8026@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907161459360.8026@cobra.newdream.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 03:07:35PM -0700, Sage Weil wrote:
> On Thu, 16 Jul 2009, Trond Myklebust wrote:
> > On Thu, 2009-07-16 at 12:50 -0700, Sage Weil wrote:
> > > On Thu, 16 Jul 2009, J. Bruce Fields wrote:
> > > > On Wed, Jul 15, 2009 at 02:24:46PM -0700, Sage Weil wrote:
> > > > > Basic NFS re-export support is included.  This mostly works.  However,
> > > > > Ceph's MDS design precludes the ability to generate a (small)
> > > > > filehandle that will be valid forever, so this is of limited utility.
> > > > 
> > > > Is there any hope of fixing that?
> > > 
> > > Yes, but it requires some additional ondisk metadata the MDS isn't 
> > > maintaining yet (a parent directory backpointer on file objects).  
> > > 
> > > The MDS changes will mean more random IO for rename intensive workloads, 
> > > but the backpointers would also be useful for rebuilding the directory 
> > > tree in the event of some catastrophic metadata loss or corruption.  
> > > (Currently they're only there for directories, not all files.)
> > 
> > Note that a filehandle that contains parent directory information is
> > still not one that is valid forever. It will change in the case of a
> > cross-directory rename, and so isn't a filehandle in the NFSv2/v3 sense.
> > Even in the NFSv4 case, it would have to be labelled as 'volatile'.
> 
> Right.  The parent directory information in the fh it used as a hint, but 
> can't be relied on because of the rename problem.  That's exactly why the 
> Ceph MDS will need to be changed to maintain backpointers on all files, 
> not just directories.  When that happens, reexporting via NFS will work 
> reliably.  Until then, old and idle filehandles for renamed files will 
> eventually go stale.

Maybe I should look again at the patch instead of continuing to ask,
but....  I'm confused: how will having a backpointers from inodes to
directories help do the filehandle-to-inode lookup?  (If you can't look
up the inode in the first place, what use is any pointer stored in that
inode?)

--b.
