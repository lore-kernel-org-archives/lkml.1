Return-Path: <linux-kernel-owner+w=401wt.eu-S933641AbXCOUHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641AbXCOUHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933638AbXCOUHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:07:14 -0400
Received: from pat.uio.no ([129.240.10.15]:41468 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933228AbXCOUHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:07:11 -0400
Subject: Re: [patch 2/5] fs: introduce new aops and infrastructure
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070315041329.GB21942@ca-server1.us.oracle.com>
References: <20070314112529.13798.35417.sendpatchset@linux.site>
	 <20070314112540.13798.97719.sendpatchset@linux.site>
	 <20070315041329.GB21942@ca-server1.us.oracle.com>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 16:06:39 -0400
Message-Id: <1173989199.6506.109.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: DA8F928E7FA823A471917BC022FD73CD558C150A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 113 total 506109 max/h 7466 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 21:13 -0700, Mark Fasheh wrote:
> Hi Nick,
> 
> On Wed, Mar 14, 2007 at 02:38:22PM +0100, Nick Piggin wrote:
> > Introduce write_begin, write_end, and perform_write aops.
> > 
> > These are intended to replace prepare_write and commit_write with more
> > flexible alternatives that are also able to avoid the buffered write
> > deadlock problems efficiently (which prepare_write is unable to do).
> 
> > Index: linux-2.6/include/linux/fs.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/fs.h
> > +++ linux-2.6/include/linux/fs.h
> > @@ -449,6 +449,17 @@ struct address_space_operations {
> >  	 */
> >  	int (*prepare_write)(struct file *, struct page *, unsigned, unsigned);
> >  	int (*commit_write)(struct file *, struct page *, unsigned, unsigned);
> > +
> > +	int (*write_begin)(struct file *, struct address_space *mapping,
> > +				loff_t pos, unsigned len, int intr,
> > +				struct page **pagep, void **fsdata);
> > +	int (*write_end)(struct file *, struct address_space *mapping,
> > +				loff_t pos, unsigned len, unsigned copied,
> > +				struct page *page, void *fsdata);
> 
> Are we going to get rid of the file and intr arguments btw? I'm not sure
> intr is useful, and mapping is probably enough to get whatever we inside
> ->write_begin / ->write_end.

Hell no! Struct file carries information that is essential for those of
us that use strong authentication. It stays.

Trond

