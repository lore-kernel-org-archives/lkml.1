Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYLARGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYLARGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 12:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYLARGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 12:06:36 -0500
Received: from styx.suse.cz ([82.119.242.94]:48254 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751830AbYLARGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 12:06:36 -0500
Date: Mon, 1 Dec 2008 18:06:34 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tibor.tajti@gmail.com
Subject: Re: [GIT PULL] UDF tree fixes
Message-ID: <20081201170614.GA20279@duck.suse.cz>
References: <20081127172313.GG32062@duck.suse.cz> <alpine.LFD.2.00.0811301253370.24125@nehalem.linux-foundation.org> <20081201120101.GC17303@duck.suse.cz> <alpine.LFD.2.00.0812010822060.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812010822060.3256@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 01-12-08 08:33:36, Linus Torvalds wrote:
> 
> 
> On Mon, 1 Dec 2008, Jan Kara wrote:
> >
> >   Yes, I would like to do it as well. But as I write in the changelog,
> > currently there's no good callback for that (I've mailed about it at
> > linux-fsdevel and noone had a better idea either). So for now I've just
> > used this kludge to silence the Oops.
> 
> No, I meant just a simple "just call clear_inode() from 
> udf_clear_inode()". But on a slightly closer look I notice that won't 
> work, since it will just cause recursion (well, you could just clear the 
> s_op field to avoid it, but that would be uglier than your fix).
> 
> I wonder if we should perhaps just move the invalidate_inode_buffers() 
> call later in clear_inode(). That's a scary change, though. 
> 
> I just think your patch is pretty ugly. I'm sure it works, but I also 
> suspect it indicates some kind of more fundamental problem. I also wonder 
> why udf needs it but nobody else does (others do preallocation too)
  UDF needs this because it does preallocation on directories (and I don't
know about other in-kernel fs which would do this). For regular files,
preallocation is dropped on the last close() but for directories I don't
know about such a good place so we do it in udf_clear_inode().
  There used to be put_inode() callback which could be used for this but
Christoph Hellwig killed it in April.

								Honza
