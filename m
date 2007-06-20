Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbXFTRpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbXFTRpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbXFTRpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:45:00 -0400
Received: from pat.uio.no ([129.240.10.15]:34944 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbXFTRo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:44:59 -0400
Subject: Re: [RFC PATCH 4/4] Directory listing support for union mounted
	directories.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christoph Hellwig <hch@infradead.org>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
In-Reply-To: <20070620170221.GA13237@infradead.org>
References: <20070620055050.GB4267@in.ibm.com>
	 <20070620055418.GF4267@in.ibm.com> <20070620120947.GA3973@infradead.org>
	 <1182349348.6225.15.camel@heimdal.trondhjem.org>
	 <20070620170221.GA13237@infradead.org>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 13:44:52 -0400
Message-Id: <1182361492.6480.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.145)
X-UiO-Scanned: DE71F0927072AD49A2A9D04BF26C9A2673D58A61
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 457 total 2481289 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 18:02 +0100, Christoph Hellwig wrote:
> On Wed, Jun 20, 2007 at 10:22:28AM -0400, Trond Myklebust wrote:
> > No it shouldn't. The struct file contains other stateful information
> > from the open() call (such as authentication info) that needs to be
> > passed into readdir.
> 
> Which is exactly that problem this tries to solve.  Once you have
> union mounts you'll have a single open file descriptor for multiple
> actual directories.   Beause of that you can't simply attach to the
> state to the struct file but have to keep it in a different way.

Which creates another, much WORSE problem.

Authentication information is part of a series of things that POSIX
requires you to keep on per-descriptor basis (because POSIX assumes that
you can suid/sgid a process without any security implications for file
descriptors that are already open). It is quite natural to pass it
around by means of the struct file.

If you don't want to pass the struct file around, then you at least need
to come up with an alternative mechanism that allows filesystems to
provide correct semantics in the standard non-union case.

Trond

