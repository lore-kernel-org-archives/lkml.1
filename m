Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbXJGW4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbXJGW4w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 18:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbXJGW4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 18:56:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60737 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753965AbXJGW4n (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 18:56:43 -0400
Date: Mon, 8 Oct 2007 08:56:09 +1000
From: David Chinner <dgc@sgi.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Valdis.Kletnieks@vt.edu, Peter Staubach <staubach@redhat.com>,
       Andrew@sc8-sf-spam2-b.sourceforge.net, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>, nfs@lists.sourceforge.net,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       Morton <akpm@linux-foundation.org>
Subject: Re: [NFS] What's slated for inclusion in 2.6.24-rc1 from the NFS client git tree...
Message-ID: <20071007225609.GQ23367404@sgi.com>
References: <1191454876.6726.32.camel@heimdal.trondhjem.org> <20071004085206.0a8e37b5@poseidon.drzeus.cx> <1191506450.6685.17.camel@heimdal.trondhjem.org> <30494.1191605410@turing-police.cc.vt.edu> <20071005141222.5afbb6b9.jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071005141222.5afbb6b9.jlayton@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 02:12:22PM -0400, Jeff Layton wrote:
> On Fri, 05 Oct 2007 13:30:10 -0400
> Valdis.Kletnieks@vt.edu wrote:
> 
> > On Thu, 04 Oct 2007 10:00:50 EDT, Trond Myklebust said:
> > 
> > > How about a boot/module parameter to turn it on or off?
> > > 
> > > I don't see any point in having a sysctl for something like this: either
> > > you have legacy applications or you don't. It is not something that you
> > > switch off as you go off to lunch.
> > 
> > How does Joe Sysadmin tell if he has an affected legacy app or not?
> > 
> > (The obvious "try it and see what breaks" is a non-starter for many places,
> > because you too easily end up in a loop of "enable it, find 4-5 show stoppers,
> > turn it off, fix them, lather rinse repease".  Been there, done that, got
> > the tshirt - a project I got dragged into involves a large storage array that
> > appears to insist on exporting 64-bit stuff, and a large farm of clients that
> > are very 64-bit unclean....)
> > 
> 
> Note that "try it and see what breaks" isn't reliable either. If glibc
> gets back a 64 bit inode number that just happens to fit in the 32-bit
> field, then everything will work. You don't actually get an EOVERFLOW
> until st_ino overflows the field, and that may not happen often enough
> for testing this way to detect it...

There's a damn easy way of testing this.

Use XFS on a 64 bit Linux NFS server, mount is '-o inode64,ino64'
and then export it to you client that is going to have problems.
the "ino64" mount option guarantees that the userspace visible
inode number is always > 32 bits in length....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
