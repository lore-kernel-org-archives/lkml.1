Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbZCKM6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbZCKM6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 08:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbZCKM5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 08:57:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbZCKM5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 08:57:51 -0400
Date: Wed, 11 Mar 2009 13:57:48 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Jorge Boncompte [DTI2]" <jorge@dti2.net>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>, stable@kernel.org
Subject: Re: [patch] fs: avoid I_NEW inodes
Message-ID: <20090311125748.GA14144@wotan.suse.de>
References: <20090305064554.GA11916@wotan.suse.de> <20090305100000.GA29177@duck.suse.cz> <20090305101637.GB17815@wotan.suse.de> <20090305111226.GB29531@duck.suse.cz> <20090310134106.GA15977@wotan.suse.de> <20090310160321.GB1190@duck.suse.cz> <20090311032918.GE16561@wotan.suse.de> <20090311122420.GB24590@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311122420.GB24590@duck.suse.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 01:24:20PM +0100, Jan Kara wrote:
> On Wed 11-03-09 04:29:18, Nick Piggin wrote:
> > How about this?
>   Looks fine to me.

Thanks for the good review. Andrew, do you think you can apply this
on top of the previous patch? I'm undecided as to whether they should
go together or not. Probably the first one is a minimal fix that
doesn't alter behaviour as much, but things seem more robust after this
2nd patch. I think both would probably be suitable for 2.6.29, being a
nasty bug, but it isn't a recent regression AFAIKS.

> 
> > --
> > To be on the safe side, it should be less fragile to exclude I_NEW inodes
> > from inode list scans by default (unless there is an important reason to
> > have them).
> > 
> > Normally they will get excluded (eg. by zero refcount or writecount etc),
> > however it is a bit fragile for list walkers to know exactly what parts of
> > the inode state is set up and valid to test when in I_NEW. So along these
> > lines, move I_NEW checks upward as well (sometimes taking I_FREEING etc
> > checks with them too -- this shouldn't be a problem should it?)
> > 
> > Signed-off-by: Nick Piggin <npiggin@suse.de>
>   Acked-by: Jan Kara <jack@suse.cz>
