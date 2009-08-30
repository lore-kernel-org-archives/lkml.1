Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZH3RtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZH3RtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 13:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbZH3RtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 13:49:00 -0400
Received: from mail2.shareable.org ([80.68.89.115]:54163 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbZH3Rs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 13:48:59 -0400
Date: Sun, 30 Aug 2009 18:48:52 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
Message-ID: <20090830174852.GF7129@shareable.org>
References: <20090821152459.GC6929@shareable.org> <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org> <20090824023422.GA775@infradead.org> <20090827143459.GB31453@shareable.org> <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com> <20090828154647.GA15808@infradead.org> <20090828164432.GA8036@shareable.org> <4A984758.5020008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A984758.5020008@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On 08/28/2009 09:44 AM, Jamie Lokier wrote:
> >Although libc's __new_open() could have this:
> >
> >     /* Old kernels only look at O_DSYNC.  It's better than nothing. */
> >     if (flags&  O_SYNC)
> >         flags |= O_DSYNC;
> >
> >Imho, it's better to not do that, and instead have
> >
> >     #define O_SYNC          (O_DSYNC|__O_SYNC_KERNEL)
> 
> Why should it be better?  You're replacing something the compiler can do 
> with zero cost with active code.

You misread; I said the zero cost thing is better.

The only reason you might use the active code is this:

    /* Upgrade O_DSYNC to O_SYNC. */

    flags = fcntl(fd, F_GETFL, 0);
    flags = (flags | O_SYNC) & ~O_DSYNC;
    fcntl(fd, F_SETFL, flags);

I'm not sure if that should work in POSIX.

-- Jamie
