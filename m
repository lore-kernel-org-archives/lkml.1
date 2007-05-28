Return-Path: <linux-kernel-owner+w=401wt.eu-S1759850AbXE1Cxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850AbXE1Cxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 22:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbXE1Cxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 22:53:33 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:45131 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbXE1Cxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 22:53:32 -0400
Date: Sun, 27 May 2007 22:53:26 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: young dave <hidave.darkstar@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch -mm 1/1] remove useless tolower in isofs
In-Reply-To: <a8e1da0705271808w3a6dc453rfb47dd3db100718@mail.gmail.com>
Message-ID: <alpine.DEB.0.99.0705272248110.6131@sigma.j-a-k-j.com>
References: <a8e1da0705271808w3a6dc453rfb47dd3db100718@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> Remove useless tolower in isofs
> 
> Signed-off-by: dave young <hidave.darkstar@gmail.com>
> 
> inode.c |    2 +-
> 1 file changed, 1 insertions(+), 1 deletions(-)
> 
> diff -dur linux/fs/isofs/inode.c linux.new/fs/isofs/inode.c
> --- linux/fs/isofs/inode.c      2007-05-28 08:54:33.000000000 +0000
> +++ linux.new/fs/isofs/inode.c  2007-05-28 08:55:02.000000000 +0000
> @@ -197,7 +197,7 @@
>        hash = init_name_hash();
>        while (len--) {
>                c = tolower(*name++);
> -               hash = partial_name_hash(tolower(c), hash);
> +               hash = partial_name_hash(c, hash);
>        }
>        qstr->hash = end_name_hash(hash);

How about this? A lot more readable and doesn't even need an intermediate 
value.

for (; len; len--, name++) {
	hash = partial_name_hash(tolower(*name), hash);
}

Or if you don't think that way is more readable, how about this?

while (len) {
	hash = partial_name_hash(tolower(*name), hash);
	name++;
	len--;
}

And then there's the supercompact form.

while (len--) {
	hash = partial_name_hash(tolower(*name++), hash);
}

But I do not like the last one at all. The first one is the best, because 
it clearly separates the condition and iteration parts of the expression, 
while STILL being only three lines long. Or two, if you omit the braces. 
(But you shouldn't.)
