Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbXJ2Sno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbXJ2Sno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXJ2Snh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:43:37 -0400
Received: from pat.uio.no ([129.240.10.15]:60147 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbXJ2Sng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:43:36 -0400
Subject: Re: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Florin Iucha <florin@iucha.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20071029150154.GC25561@iucha.net>
References: <20071028152428.GJ7918@iucha.net>
	 <1193665619.7396.8.camel@heimdal.trondhjem.org>
	 <20071029150154.GC25561@iucha.net>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 14:43:32 -0400
Message-Id: <1193683412.7497.10.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.6, required=12.0, autolearn=disabled, AWL=-0.571)
X-UiO-Scanned: A5945EDADEF4880F4025F56B8BF721675214DABC
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -5 maxlevel 200 minaction 2 bait 0 mail/h: 605 total 4790743 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-29 at 10:01 -0500, Florin Iucha wrote:
> On Mon, Oct 29, 2007 at 09:46:59AM -0400, Trond Myklebust wrote:
> > > What could cause this?  I use NFS4 to automount the home directories
> > > from a Solaris10 server, and this box found a few bugs in the NFS4
> > > code (fixed in the 2.6.22 kernel).
> > > 
> > > I'll try running with 2.6.23 again for a few days, to see if I get the
> > > pdflush stuck.  Any other ideas?
> > 
> > One of them appears to be waiting for i/o congestion to clear up. If the
> > filesystem is NFS, then that means that some other thread is busy
> > writing data out to the server. You'll need to look at the rest of the
> > thread dump to figure out which thread is writing the data out, and
> > where it is getting stuck.
> 
> Trond,
> 
> The full dmesg is at http://iucha.net/2.6.24-rc1/dmesg.stuck_pdflush.gz
> 
> Cheers,
> florin

I can't see any evidence of NFS traffic at all in those traces, but
there is a fuse process that is sleeping in :fuse:fuse_dev_read(). Could
that perhaps be relevant.

Trond

