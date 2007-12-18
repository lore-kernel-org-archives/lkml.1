Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbXLRPU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbXLRPU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbXLRPUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:20:06 -0500
Received: from relay2.sgi.com ([192.48.171.30]:36528 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756790AbXLRPUE (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:20:04 -0500
Date: Wed, 19 Dec 2007 02:19:47 +1100
From: David Chinner <dgc@sgi.com>
To: Damien Wyart <damien.wyart@free.fr>
Cc: David Chinner <dgc@sgi.com>, Christoph Hellwig <hch@infradead.org>,
       Lachlan McIlroy <lachlan@sgi.com>, Peter Leckie <pleckie@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs@oss.sgi.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Important regression with XFS update for 2.6.24-rc6
Message-ID: <20071218151946.GQ4396912@sgi.com>
References: <20071218112804.GA3069@localhost.localdomain> <20071218122445.GJ4396912@sgi.com> <877ijckrco.fsf@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877ijckrco.fsf@free.fr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 03:30:31PM +0100, Damien Wyart wrote:
> * David Chinner <dgc@sgi.com> [071218 13:24]:
> > Ok. I haven't noticed anything wrong with directories up to about
> > 250,000 files in the last few days. The ls -l I just did on
> > a directory with 15000 entries (btree format) used about 5MB of RAM.
> > extent format directories appear to work fine as well (tested 500
> > entries).
> 
> Ok, nice to know the problem is not so frequent.

.....

> I have put the files at http://damien.wyart.free.fr/xfs/
> 
> strace_xfs_problem.1.gz and strace_xfs_problem.2.gz have been created
> with the problematic kernel, and are quite bigger than
> strace_xfs_problem.normal.gz, which has been created with the vanilla
> rc5-git5. There is also xfs_info.

Looks like several getdents() through the directory the getdents()
call starts outputting the first files again. It gets to a certain
point and always goes back to the beginning. However, it appears to
get to the end eventually (without ever getting past the bad offset).

I'll ook into this more in the morning as it's not obvious what is
wrong in my sleep-deprived state....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
