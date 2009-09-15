Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbZIOUP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbZIOUP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 16:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbZIOUPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 16:15:53 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:40536 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753687AbZIOUPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 16:15:53 -0400
X-Trace: 259116194/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.84.74/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.84.74
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgFACWTr0pPRVRK/2dsb2JhbACBU98BhBcF
X-IronPort-AV: E=Sophos;i="4.44,391,1249254000"; 
   d="scan'208";a="259116194"
Date: Tue, 15 Sep 2009 21:15:07 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 7/8] mm: reinstate ZERO_PAGE
In-Reply-To: <20090909104423.4bd23a2c.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0909152111330.22199@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
 <Pine.LNX.4.64.0909072238320.15430@sister.anvils>
 <20090908113734.869cdad7.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0909081231480.25652@sister.anvils>
 <20090909104423.4bd23a2c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009, KAMEZAWA Hiroyuki wrote:
> On Tue, 8 Sep 2009 12:56:57 +0100 (BST)
> Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> > 
> > Though I like that we don't _need_ to change mlock.c for reinstated
> > ZERO_PAGE, this morning I'm having trouble persuading myself that
> > mlocking a readonly anonymous area is too silly to optimize for.
> > 
> > Maybe the very people who persuaded you to bring back the anonymous
> > use of ZERO_PAGE, are also doing a huge mlock of the area first?
> No, as far as I know, they'll not do huge mlock.

Thanks for that (not entirely conclusive!) info.

I've decided for the moment to make a couple of further optimizations
in mlock.c (along with the comment you asked for), and leave adding
another __get_user_pages flag until a case for it is demonstrated.

Small patch series following shortly.

Hugh
