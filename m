Return-Path: <linux-kernel-owner+w=401wt.eu-S1763665AbYARSMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763665AbYARSMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759375AbYARSL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:11:56 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39389 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758004AbYARSLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:11:55 -0500
To: torvalds@linux-foundation.org
CC: peterz@infradead.org, miklos@szeredi.hu, salikhmetov@gmail.com,
       linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, akpm@linux-foundation.org,
       protasnb@gmail.com, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
In-reply-to: <alpine.LFD.1.00.0801180949040.2957@woody.linux-foundation.org>
	(message from Linus Torvalds on Fri, 18 Jan 2008 09:58:04 -0800 (PST))
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped
 files
References: <12006091182260-git-send-email-salikhmetov@gmail.com>  <12006091211208-git-send-email-salikhmetov@gmail.com>  <E1JFnsg-0008UU-LU@pomaz-ex.szeredi.hu>  <1200651337.5920.9.camel@twins> <1200651958.5920.12.camel@twins> <alpine.LFD.1.00.0801180949040.2957@woody.linux-foundation.org>
Message-Id: <E1JFvgx-0000zz-2C@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 Jan 2008 19:11:47 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And even in that four-liner, I suspect that the *last* two lines are 
> actually incorrect: there's no point in updating the file time when the 
> page *becomes* dirty,

Actually all four lines do that.  The first two for a write access on
a present, read-only pte, the other two for a write on a non-present
pte.

> we should update the file time when it is marked 
> clean, and "msync(MS_SYNC)" should update it as part of *that*.

That would need a new page flag (PG_mmap_dirty?).  Do we have one
available?

Miklos
