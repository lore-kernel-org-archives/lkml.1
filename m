Return-Path: <linux-kernel-owner+w=401wt.eu-S933414AbXCZW0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbXCZW0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 18:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933584AbXCZW0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 18:26:23 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55550 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933353AbXCZW0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 18:26:22 -0400
Date: Mon, 26 Mar 2007 15:25:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
Message-Id: <20070326152539.51d654ed.akpm@linux-foundation.org>
In-Reply-To: <20070326211008.GS10459@waste.org>
References: <E1HVZyn-0008T8-00@dorka.pomaz.szeredi.hu>
	<20070326140036.f3352f81.akpm@linux-foundation.org>
	<20070326211008.GS10459@waste.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007 16:10:09 -0500
Matt Mackall <mpm@selenic.com> wrote:

> On Mon, Mar 26, 2007 at 02:00:36PM -0700, Andrew Morton wrote:
> > On Sun, 25 Mar 2007 23:10:21 +0200
> > Miklos Szeredi <miklos@szeredi.hu> wrote:
> > 
> > > This patch makes writing to shared memory mappings update st_ctime and
> > > st_mtime as defined by SUSv3:
> > 
> > Boy this is complicated.
> > 
> > Is there a simpler way of doing all this?  Say, we define a new page flag
> > PG_dirtiedbywrite and we do SetPageDirtiedByWrite() inside write() and
> > ClearPageDirtiedByWrite() whenever we propagate pte-dirtiness into
> > page-dirtiness.  Then, when performing writeback we look to see if any of
> > the dirty pages are !PageDirtiedByWrite() and, if so, we update [mc]time to
> > current-time.
> > 
> > Or something like that - I'm just thinking out loud and picking holes in
> > the above doesn't shut me up ;) We're adding complexity and some overhead
> > and we're losing our recent msync() simplifications and this all hurts.  Is
> > there some other way?  I think burning a page flag to avoid this additional
> > complexity would be worthwhile.  
> 
> Aren't we basically out of those?

Rafael has liberated a couple of the flags which swsusp was using.
