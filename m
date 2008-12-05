Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbYLESQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbYLESQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 13:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYLESP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 13:15:58 -0500
Received: from waste.org ([66.93.16.53]:49438 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbYLESP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:15:57 -0500
Subject: Re: [PATCH] shmem: unify regular and tiny shmem
From: Matt Mackall <mpm@selenic.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0812051311530.10157@blonde.anvils>
References: <1228425564.3255.121.camel@calx>
	 <Pine.LNX.4.64.0812051311530.10157@blonde.anvils>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 12:15:36 -0600
Message-Id: <1228500936.3255.210.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 13:18 +0000, Hugh Dickins wrote:
> I agree with where you're going (surrendering your empire to mine!
> or perhaps you don't you see it quite that way?), but I think this
> isn't quite the patch you meant to send: it shouldn't contain that
> 
> > -			&shmem_file_operations);
> > +		  &shmem_file_operations);
> > +
> > +#ifndef CONFIG_MMU
> > +	error = ramfs_nommu_expand_for_mapping(inode, size);
> > +	if (error)
> > +		goto close_file;
> > +#endif
> 
> hunk in mm/shmem.c

I'm staring at the source and I'm at a loss as to why not? SHMEM depends
on MMU, so this only gets done when !SHMEM && !MMU, which makes it the
same as the tiny-shmem.c code it's unifying, no?

> and it should be deleting mm/tiny-shmem.c?

Not sure how that bit fell off, yes.

-- 
Mathematics is the supreme nostalgia of our time.

