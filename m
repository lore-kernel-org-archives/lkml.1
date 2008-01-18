Return-Path: <linux-kernel-owner+w=401wt.eu-S1763444AbYARS3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763444AbYARS3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760992AbYARS3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:29:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758104AbYARS3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:29:31 -0500
Date: Fri, 18 Jan 2008 13:28:50 -0500
From: Rik van Riel <riel@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: torvalds@linux-foundation.org, peterz@infradead.org, miklos@szeredi.hu,
       salikhmetov@gmail.com, linux-mm@kvack.org, jakob@unthought.net,
       linux-kernel@vger.kernel.org, valdis.kletnieks@vt.edu, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, akpm@linux-foundation.org,
       protasnb@gmail.com, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped
 files
Message-ID: <20080118132850.044537e5@bree.surriel.com>
In-Reply-To: <E1JFvgx-0000zz-2C@pomaz-ex.szeredi.hu>
References: <12006091182260-git-send-email-salikhmetov@gmail.com>
	<12006091211208-git-send-email-salikhmetov@gmail.com>
	<E1JFnsg-0008UU-LU@pomaz-ex.szeredi.hu>
	<1200651337.5920.9.camel@twins>
	<1200651958.5920.12.camel@twins>
	<alpine.LFD.1.00.0801180949040.2957@woody.linux-foundation.org>
	<E1JFvgx-0000zz-2C@pomaz-ex.szeredi.hu>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 19:11:47 +0100
Miklos Szeredi <miklos@szeredi.hu> wrote:

> > And even in that four-liner, I suspect that the *last* two lines are 
> > actually incorrect: there's no point in updating the file time when the 
> > page *becomes* dirty,
> 
> Actually all four lines do that.  The first two for a write access on
> a present, read-only pte, the other two for a write on a non-present
> pte.
> 
> > we should update the file time when it is marked 
> > clean, and "msync(MS_SYNC)" should update it as part of *that*.
> 
> That would need a new page flag (PG_mmap_dirty?).  Do we have one
> available?

I thought the page writing stuff looked at (and cleared) the pte
dirty bit, too?

-- 
All rights reversed.
