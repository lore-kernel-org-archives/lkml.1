Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbZLBJmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbZLBJmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 04:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbZLBJmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 04:42:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbZLBJmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 04:42:45 -0500
Date: Wed, 2 Dec 2009 10:42:50 +0100
From: Nick Piggin <npiggin@suse.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Liuweni <qingshenlwy@gmail.com>, strongzgy <strongzgy@gmail.com>,
       xgr178 <xgr178@163.com>, Liu Hui <onlyflyer@gmail.com>,
       viro <viro@zeniv.linux.org.uk>, akpm <akpm@linux-foundation.org>,
       jack <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH 1/3]fs/inode: iunique() Optimize Performance
Message-ID: <20091202094250.GB31517@wotan.suse.de>
References: <20091201120337.GV9482@parisc-linux.org> <200912012115341872867@gmail.com> <20091201140041.GW9482@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201140041.GW9482@parisc-linux.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 07:00:41AM -0700, Matthew Wilcox wrote:
> On Tue, Dec 01, 2009 at 09:21:32PM +0800, Liuweni wrote:
> >  *	BUGS:
> >  *	With a large number of inodes live on the file system this function
> >  *	currently becomes quite slow.
> > 
> 
> I don't believe that comment is correct.  In any case, your optimisation
> wouldn't make a lick of difference to the speed; it's a single comparison
> in a loop which also calculates a hash, makes a function call, and walks
> the length of a hash chain.
> 
> The old adage about debugging code, not comments applies here.  Don't take
> somebody else's word for it that there's a performance problem here.
> Devise a test to demonstrate the performance problem.  Otherwise, how
> will you know if you solved it?

Yeah I agree. And then we can debate the usefulness of that workload.

iunique is not used in many filesystems.  If performance really becomes a
problem, then you most likely need another data structure. A per-sb ida or
something would come to mind, but I expect any filesystem that cares already
has a decent inode number allocation so iunique is just a simple hack for
those that don't care so much.

