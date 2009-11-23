Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbZKWNQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbZKWNQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757238AbZKWNQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:16:09 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:21001 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757401AbZKWNQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:16:08 -0500
Date: Mon, 23 Nov 2009 16:16:13 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] jffs2: Fix memory corruption in
 jffs2_read_inode_range()
Message-ID: <20091123131613.GA14619@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20091120194532.GA9455@oksana.dev.rtsoft.ru>
 <1258885259.1127.80.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1258885259.1127.80.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 22, 2009 at 10:20:59AM +0000, David Woodhouse wrote:
> On Fri, 2009-11-20 at 12:45 -0700, Anton Vorontsov wrote:
> > +       if (pg->index > ((i_size_read(inode) - 1) >> PAGE_CACHE_SHIFT)) {
> > +               ret = 0;
> > +               memset(pg_buf, 0, PAGE_CACHE_SIZE);
> > +       } else {
> > +               ret = jffs2_read_inode_range(c, f, pg_buf,
> > +                       pg->index << PAGE_CACHE_SHIFT, PAGE_CACHE_SIZE);
> > +       } 
> 
> Thank you for the excellent diagnosis and the patch. 
> 
> I think I'd prefer to fix it a little differently though -- I would be
> happier to make jffs2_read_inode_range() cope with out-of-file reads,
> rather than adding this special case where we don't call it.
> 
> That way we aren't at all susceptible to potential races between the
> VFS-maintained i_size and our own internal fragtree handling. And
> jffs2_read_inode_range() already handles the memset to zero for various
> other reasons anyway.
> 
> Does this patch look OK to you? It seems to work on the test cases I've
> tried.

Yep, it looks good (and works).

Thanks David!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
