Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbZJBQ5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbZJBQ5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbZJBQ5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:57:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:48328 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757308AbZJBQ5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:57:40 -0400
Date: Fri, 2 Oct 2009 09:55:05 -0700
From: Greg KH <gregkh@suse.de>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Mel Gorman <mel@csn.ul.ie>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [121/136] mm: fix anonymous dirtying
Message-ID: <20091002165505.GC3901@suse.de>
References: <20091002011548.335611824@mini.kroah.org>
 <20091002012426.168639081@mini.kroah.org>
 <Pine.LNX.4.64.0910021731230.20933@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910021731230.20933@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 05:34:03PM +0100, Hugh Dickins wrote:
> On Thu, 1 Oct 2009, Greg KH wrote:
> > 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> > 
> > commit 1ac0cb5d0e22d5e483f56b2bc12172dec1cf7536 upstream.
> > 
> > do_anonymous_page() has been wrong to dirty the pte regardless.
> > If it's not going to mark the pte writable, then it won't help
> > to mark it dirty here, and clogs up memory with pages which will
> > need swap instead of being thrown away.  Especially wrong if no
> > overcommit is chosen, and this vma is not yet VM_ACCOUNTed -
> > we could exceed the limit and OOM despite no overcommit.
> 
> Thanks a lot for including this little fix in 2.6.31.2.
> It is equally relevant to both 2.6.27.36 and 2.6.30.9,
> so if not too late, please consider adding it into those too.

Ok, will do.

thanks,

greg k-h
