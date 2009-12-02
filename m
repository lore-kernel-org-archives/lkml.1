Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbZLBIwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbZLBIwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbZLBIwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:52:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879AbZLBIwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:52:20 -0500
Date: Wed, 2 Dec 2009 09:52:23 +0100
From: Nick Piggin <npiggin@suse.de>
To: tytso@mit.edu, Marcin Slusarz <marcin.slusarz@gmail.com>,
       Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [Patch] fs: remove a useless BUG()
Message-ID: <20091202085223.GD21967@wotan.suse.de>
References: <20091201023714.3863.92566.sendpatchset@localhost.localdomain> <20091201165440.GA2688@joi.lan> <20091201185225.GB6278@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201185225.GB6278@thunk.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 01:52:25PM -0500, tytso@mit.edu wrote:
> On Tue, Dec 01, 2009 at 05:55:11PM +0100, Marcin Slusarz wrote:
> > On Mon, Nov 30, 2009 at 09:34:14PM -0500, Amerigo Wang wrote:
> > > This BUG() is suspicious, it makes its following statements
> > > unreachable, 
> > only when CONFIG_BUG=y
> 
> Which is true for all kernels except for the very rare embedded case.
> 
> > > and it seems to be useless, since the caller
> > > of this function already handles the failure properly.
> > because this function can return NULL in other codepath
> > 
> > > Remove it.
> > I don't know why this BUG() is there (and maybe it's not really
> > needed), but your rationale is wrong.
> 
> Your reply is a bit snarky, IMHO.  It might have been nicer and more
> courteous if you had bothered to take a closer look at the patch
> before firing off a reply.
> 
> In fact, it's good to avoid BUG() if at all possible, especially if it
> can happen in the normally course of events --- such as running out of
> memory.  Having code which triggers an BUG in an low memory situation
> is very bad form.
> 
> Looks good to me.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Maybe convert it to  a warning?

