Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbXJDTQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbXJDTQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 15:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756307AbXJDTQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 15:16:31 -0400
Received: from pat.uio.no ([129.240.10.15]:43585 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbXJDTQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 15:16:30 -0400
Subject: Re: [NFS] What's slated for inclusion in 2.6.24-rc1 from the NFS
	client git tree...
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, staubach@redhat.com,
       nfsv4@linux-nfs.org, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071004114243.3161af16.akpm@linux-foundation.org>
References: <1191454876.6726.32.camel@heimdal.trondhjem.org>
	 <20071004085206.0a8e37b5@poseidon.drzeus.cx>
	 <1191506450.6685.17.camel@heimdal.trondhjem.org>
	 <20071004184304.6e71ab6d@poseidon.drzeus.cx>
	 <20071004114243.3161af16.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 04 Oct 2007 15:16:03 -0400
Message-Id: <1191525363.6739.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, AWL=0.019)
X-UiO-Scanned: DE7D40BBAE3E92264886266C4E9D733171A8A8A8
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 243 total 4296702 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-04 at 11:42 -0700, Andrew Morton wrote:
> On Thu, 4 Oct 2007 18:43:04 +0200
> Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> 
> > On Thu, 04 Oct 2007 10:00:50 -0400
> > Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > 
> > > On Thu, 2007-10-04 at 08:52 +0200, Pierre Ossman wrote:
> > > > On Wed, 03 Oct 2007 19:41:16 -0400
> > > > Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > > > 
> > > > > 
> > > > > We also have the 64-bit inode support from RedHat/Peter Staubach.
> > > > > 
> > > > 
> > > > As has been pointed[1] out[2], this will cause regressions for
> > > > non-LFS applications (of which there are still lots and lots). This
> > > > change should be in feature-removal (the "feature" being removed is
> > > > legacy support for non-LFS applications using NFS servers that make
> > > > full use of the protocol) and preferably accompanied with
> > > > appropriate user space changes (e.g. compatibility option in glibc).
> > > > 
> > > > [1] https://bugzilla.redhat.com/show_bug.cgi?id=241348
> > > > [2] http://marc.info/?l=linux-nfs&m=118701088726477&w=2
> > > > 
> > > > Rgds
> > > 
> > > How about a boot/module parameter to turn it on or off?
> > > 
> > 
> > That would be perfect. It can even be in non-legacy mode by default,
> > just as long as you can go back to the old behaviour when/if you run
> > into a non-LFS application.
> > 
> 
> Wouldn't a mount option be better?

I suppose that might be OK if you know that the 32-bit legacy
applications will only touch one or two servers, but that sounds like a
niche thing.

On the downside, forcing all those people who have portable 64-bit aware
applications to upgrade their version of mount just in order to have
stat64() work correctly seems unnecessarily complicated. I'd prefer not
to have to do that unless someone comes up with a good reason why we
must.

Cheers
  Trond

