Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbZGMG7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbZGMG7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 02:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbZGMG7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 02:59:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbZGMG7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 02:59:21 -0400
Date: Mon, 13 Jul 2009 08:59:17 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 3/4] fs: new truncate sequence
Message-ID: <20090713065917.GO14666@wotan.suse.de>
References: <20090707150758.GA18075@infradead.org> <20090707154809.GH2714@wotan.suse.de> <20090707163042.GA14947@infradead.org> <20090708063225.GL2714@wotan.suse.de> <20090708104701.GA31419@infradead.org> <20090708123412.GQ2714@wotan.suse.de> <4A54C435.1000503@panasas.com> <20090709075100.GU2714@wotan.suse.de> <4A59A517.1080605@panasas.com> <20090712144717.GA18163@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090712144717.GA18163@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 10:47:18AM -0400, Christoph Hellwig wrote:
> On Sun, Jul 12, 2009 at 11:55:51AM +0300, Boaz Harrosh wrote:
> > I wish you would split it.
> > 
> > one - helper to be called by converted file systems
> >       (Which just ignores the ATTR_SIZE)
> > second - to be set into .setattr which does the simple_setsize + above.
> > 
> > More clear for FS users like me (and that ugly unmask of ATTR_SIZE)
> > 
> > or it's just me?
> 
> Yeah, that seems be a lot cleaner.  But let's wait until we got
> rid of ->truncate for all filesystems to have the bigger picture.

Agreed, if it is a common sequence / requirement for filesystems
then of course I will not object to a helper to make things clearer
or share code.

I would like to see inode_setattr renamed into simple_setattr, and
then also .setattr made mandatory, so I don't like to cut code out
of inode_setattr which makes it unable to be the simple_setattr
after the old truncate code is removed.

