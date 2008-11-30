Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbYK3S6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbYK3S6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 13:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYK3S6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 13:58:13 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54518 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556AbYK3S6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 13:58:12 -0500
Date: Sun, 30 Nov 2008 19:58:05 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, akpm@linux-foundation.org
Subject: Re: [PATCH] UBIFS: fix compilation warnings
Message-ID: <20081130185805.GB2839@Chamillionaire.breakpoint.cc>
References: <1227287970-14684-1-git-send-email-dedekind@infradead.org> <1227287970-14684-5-git-send-email-dedekind@infradead.org> <20081122185429.GA21433@Chamillionaire.breakpoint.cc> <492A7BFD.7000206@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <492A7BFD.7000206@nokia.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Hunter | 2008-11-24 12:03:41 [+0200]:

> Doesn't help:
>
> fs/ubifs/journal.c:699: warning: format ???%zu??? expects type 
> ???size_t???, but argument 4 has type ???ino_t???
Indeed. BUT:

Is there actually a reason why Alpha is the only arch having
__kernel_ino_t defined as unsigned int instead of unsigned long ?
(except s390 in 32bit mode).

I just checked and I haven't seen anything that would point out that
__kernel_ino_t / ino_t is part of user space API.
What I've found instead is for instance that ext2 relies that ino_t is a
long:

|struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
|{
....
|        raw_inode = ext2_get_inode(inode->i_sb, ino, &bh);

and the prototype is:
|static struct ext2_inode *ext2_get_inode(struct super_block *sb, ino_t ino,
|                                         struct buffer_head **p)

So we lose the upper 32bit on Alpha. Unless the whole system is
self-contained and the ext2_iget() user never passes something > ino_t.

Any comments?

Sebastian
