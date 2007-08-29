Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbXH2PPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbXH2PPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 11:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbXH2PPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 11:15:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58727 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbXH2PPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 11:15:09 -0400
Date: Wed, 29 Aug 2007 17:15:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [RFC][PATCH 2/2 -mm] kexec based hibernation: kexec restore
Message-ID: <20070829151508.GA11179@atrey.karlin.mff.cuni.cz>
References: <1188177296.3247.38.camel@caritas-dev.intel.com> <20070827213134.GE3398@elf.ucw.cz> <1188263677.2050.8.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188263677.2050.8.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2007-08-27 at 23:31 +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > This patch adds writing support for /dev/oldmem. This is used to
> > > restore the memory contents of hibernated system.
> > > 
> > > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > 
> > > +ssize_t write_oldmem_page(unsigned long pfn, const char *buf,
> > > +			  size_t csize, unsigned long offset, int userbuf)
> > 
> > Hmm, int userbuf is only ever set to one... Does it make sense to have
> > write_oldmem_page in the separate file? The onl user is mem.c, perhaps
> > it should go there?
> > 
> 
> write_oldmem_page is kept to be consistent with copy_oldmem_page as much
> as possible. The userbuf is used by copy_oldmem_page too, and
> write_oldmem_page is in the same file as copy_oldmem_page. I think the
> consistence between them is reasonable.
> 
> And the copy_oldmem_page/write_oldmem_page is considered to be
> architecture dependent. Now, there are different implementations for
> copy_oldmem_page on different architectures. So I think the
> copy_oldmem_page/write_oldmem_page should be kept in separate file
> instead of go mem.c.

I thought it may have something to do with consistency. ACK on that
one. Perhaps it should be pushed to akpm?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
