Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbXCZVXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbXCZVXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 17:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbXCZVXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 17:23:38 -0400
Received: from waste.org ([66.93.16.53]:42694 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbXCZVXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 17:23:37 -0400
Date: Mon, 26 Mar 2007 16:10:09 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
Message-ID: <20070326211008.GS10459@waste.org>
References: <E1HVZyn-0008T8-00@dorka.pomaz.szeredi.hu> <20070326140036.f3352f81.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326140036.f3352f81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 02:00:36PM -0700, Andrew Morton wrote:
> On Sun, 25 Mar 2007 23:10:21 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > This patch makes writing to shared memory mappings update st_ctime and
> > st_mtime as defined by SUSv3:
> 
> Boy this is complicated.
> 
> Is there a simpler way of doing all this?  Say, we define a new page flag
> PG_dirtiedbywrite and we do SetPageDirtiedByWrite() inside write() and
> ClearPageDirtiedByWrite() whenever we propagate pte-dirtiness into
> page-dirtiness.  Then, when performing writeback we look to see if any of
> the dirty pages are !PageDirtiedByWrite() and, if so, we update [mc]time to
> current-time.
> 
> Or something like that - I'm just thinking out loud and picking holes in
> the above doesn't shut me up ;) We're adding complexity and some overhead
> and we're losing our recent msync() simplifications and this all hurts.  Is
> there some other way?  I think burning a page flag to avoid this additional
> complexity would be worthwhile.  

Aren't we basically out of those?

-- 
Mathematics is the supreme nostalgia of our time.
