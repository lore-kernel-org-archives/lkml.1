Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbXFTOXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbXFTOXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 10:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXFTOWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 10:22:55 -0400
Received: from pat.uio.no ([129.240.10.15]:51967 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbXFTOWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 10:22:54 -0400
Subject: Re: [RFC PATCH 4/4] Directory listing support for union mounted
	directories.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christoph Hellwig <hch@infradead.org>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
In-Reply-To: <20070620120947.GA3973@infradead.org>
References: <20070620055050.GB4267@in.ibm.com>
	 <20070620055418.GF4267@in.ibm.com>  <20070620120947.GA3973@infradead.org>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 10:22:28 -0400
Message-Id: <1182349348.6225.15.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.148)
X-UiO-Scanned: DC53B993FF9156DE3134CF4199294CDB27384E7C
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 493 total 2478675 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 13:09 +0100, Christoph Hellwig wrote:
> On Wed, Jun 20, 2007 at 11:24:18AM +0530, Bharata B Rao wrote:
> > From: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > Subject: Directory listing support for union mounted directories.
> > 
> > Modifies readdir()/getdents() to support union mounted directories.
> > 
> > This patch adds support to readdir()/getdents() to read directory entries
> > from all the directories of the union stack, and present a merged view to
> > the userspace. This is achieved by maintaining a cache of read entries.
> > 
> > TODO: Breaks lseek on union mounted directories, Fix this.
> 
> Btw, to avoid dealing with file structs representing multiple objects
> ->readdir should be changed to an inode_operation and not take a struct
> file * but rather struct inode + loff_t *ppos.  This sounds like a nice
> preparatory patch for any kind of union mount implementation and is
> acceptable standing on it's own.

No it shouldn't. The struct file contains other stateful information
from the open() call (such as authentication info) that needs to be
passed into readdir.

Trond

