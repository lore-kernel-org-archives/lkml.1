Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbXJXCaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbXJXCaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbXJXCai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:30:38 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52231 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbXJXCah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:30:37 -0400
Date: Tue, 23 Oct 2007 20:30:35 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Message-ID: <20071024023035.GV27248@parisc-linux.org>
References: <1193173966-3550-1-git-send-email-matthew@wil.cx> <alpine.LFD.0.999.0710231641480.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710231641480.30120@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 04:43:53PM -0700, Linus Torvalds wrote:
> On Tue, 23 Oct 2007, Matthew Wilcox wrote:
> > This is a generic string buffer which can also be used for non-printk
> > purposes.  There is no sb_scanf implementation yet as I haven't identified
> > a user for it.
> 
> Hmm. Have you looked at the git "strbuf" code? 

I hadn't.  It's quite spookily similar in some ways.  There's a lot of
things you've added because you presumably have use for them in git that
could easily be added once we had users for them in the kernel.  There's
a few things stringbufs do that strbufs don't need to because they're in
userspace.

I can easily change the API at this point, so if renaming things will
make you happier, just say so.

> And stuff like "sb_string()" are just evil. The string is there. Just call 
> it something better than "s", and let people just use "sb->buf" or 
> something. Why make the interface harder to use than necessary?

It's a matter of taste ... some people prefer to use accessors for
everything, other people prefer to expose the underlying structure
directly.  I have to confess to being influenced by Java in 1998-99,
so possibly I tend to go for accessors too often.  Or possibly it's
just my experience of restructuring things in Linux where diffs would
be smaller if we only had used accessors for something.  In any case,
I don't care to fight about this; if you want it to be called buf,
then buf it shall be called, and I'll get rid of sb_string.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
