Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbZIQPZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbZIQPZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbZIQPZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:25:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbZIQPZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:25:08 -0400
Date: Thu, 17 Sep 2009 17:25:10 +0200
From: Jan Kara <jack@suse.cz>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       pbadari@us.ibm.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Is nobh code still useful?
Message-ID: <20090917152510.GC13660@duck.suse.cz>
References: <20090917135627.GB13660@duck.suse.cz> <4AB2519F.8020409@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB2519F.8020409@panasas.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 17-09-09 18:11:27, Boaz Harrosh wrote:
> On 09/17/2009 04:56 PM, Jan Kara wrote:
> >   Hi,
> > 
> >   during my page_mkwrite() work, I've looked at who uses nobh_ versions of
> > various functions in fs/buffer.c. It seems only ext2 and jfs use them. ext3
> > uses them only from writepage() (which means we needn't attach buffers to a
> > page when it was written via mmap in writeback mode) and ext4 tries to use
> > them but in fact it's nop because it always attaches buffers to the page
> > earlier. So it's not really widely used, there's quite some code to support
> > it (including one page flag), and it also slightly complicates my
> > page_mkwrite() fixes.
> >   So I wanted to ask does somebody actually remember what it is good for?
> > Buffer heads obviously consume some memory so was that the reason? OTOH we
> > have to map the page whenever we write to it or send it to disk via
> > writepage().
> > 
> > 								Honza
> 
> I'm currently using nobh_truncate_page() in fs/exofs/inode.c::exofs_truncate().
> 
> Though, I suspect that once I do the conversion to Nick's:
> 	"[patch 00/11] new truncate sequence" 
> and it is submitted, that use will disappear.
  Yeah, actually with page_mkwrite patches I've just sent, this would
definitely go away so this isn't a use I'm too much worried about ;). But
thanks for info anyway.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
