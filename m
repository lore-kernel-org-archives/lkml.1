Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbXJ0Qsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbXJ0Qsn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 12:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXJ0Qsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 12:48:35 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40071 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbXJ0Qsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 12:48:35 -0400
Date: Sat, 27 Oct 2007 10:48:32 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Message-ID: <20071027164832.GW27248@parisc-linux.org>
References: <20071024195847.GE27248@parisc-linux.org> <200710261211.01423.rusty@rustcorp.com.au> <84144f020710270447m6f77848fl1f0c43312d172309@mail.gmail.com> <200710272250.16323.rusty@rustcorp.com.au> <84144f020710270934j54153c8bibb2d1fb48abd8dca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020710270934j54153c8bibb2d1fb48abd8dca@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 07:34:47PM +0300, Pekka Enberg wrote:
> On 10/27/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Saturday 27 October 2007 21:47:09 Pekka Enberg wrote:
> > > Why don't we just return -ENOMEM here just like all other APIs in the
> > > kernel?
> > I think Willy did it because this is for printk.  It makes more sense than
> > everyone opencoding an -ENOMEM handler, which will have to be replaced by
> > some mildly amusing string like "I want to printk but I have no memory!".
> > Next think you know 70% of the kernel will be bad limericks as everyone tries
> > to one-up each other.
> 
> My point was, of course, that the caller gets to decide what to do on
> OOM. For the most part, you probably want to ignore it but for things
> like pseudo filesystems where you generate a human-readable string,
> returning -ENOMEM from read(2) is preferable.

That was why I had an sb_error() as part of the API so a caller who
cared could check, and a caller who didn't care would never know --
they'd just print the out-of-memory string and continue happily.

It's not hard to add an sb_error to Rusty's rewrite.  It looks something
like:

static inline int sb_error(struct stringbuf *sb)
{
	if (sb == sb_enomem_string)
		return -ENOMEM;
	return 0;
}

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
