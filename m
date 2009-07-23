Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbZGWLni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbZGWLni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 07:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbZGWLni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 07:43:38 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:19257 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608AbZGWLnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 07:43:37 -0400
X-Trace: 231366300/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.32.187/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.32.187
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEACvpZ0pPRSC7/2dsb2JhbACBUc8AgjKBWwU
X-IronPort-AV: E=Sophos;i="4.43,254,1246834800"; 
   d="scan'208";a="231366300"
Date: Thu, 23 Jul 2009 12:43:25 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Izik Eidus <ieidus@redhat.com>, akpm@linux-foundation.org,
       chrisw@redhat.com, avi@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 06/10] ksm: identify PageKsm pages
In-Reply-To: <20090723110655.f08cdcdc.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0907231236370.12896@sister.anvils>
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com>
 <1247851850-4298-2-git-send-email-ieidus@redhat.com>
 <1247851850-4298-3-git-send-email-ieidus@redhat.com>
 <1247851850-4298-4-git-send-email-ieidus@redhat.com>
 <1247851850-4298-5-git-send-email-ieidus@redhat.com>
 <1247851850-4298-6-git-send-email-ieidus@redhat.com>
 <1247851850-4298-7-git-send-email-ieidus@redhat.com> <20090721175139.GE2239@random.random>
 <4A660101.3000307@redhat.com> <Pine.LNX.4.64.0907221346040.529@sister.anvils>
 <20090723110655.f08cdcdc.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009, KAMEZAWA Hiroyuki wrote:
> On Wed, 22 Jul 2009 13:54:06 +0100 (BST)
> Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> > 
> > (At this instant I've forgotten why there's an unevictable list at
> > all - somewhere in vmscan.c which is accustomed to dealing with
> > pages on lists, so easier to have them on a list than not?)
> > 
> I forget, too. But in short thinking, Unevictable pages should be
> on LRU (marked as PG_lru) for isolating page (from LRU) called by
> page migration etc.
> 
> isolate_lru_page()
> 	-> put page on private list
> 	-> do some work
> 	-> putback_lru_page()
> 
> sequence is useful at handling pages in a list.
> Because mlock/munclock can be called arbitrarily, unevicatable lru
> works enough good for making above kinds of code simpler.

Yes, I think that's it, thanks.

And for the moment, the KSM pages are therefore unmigratable
as well as unswappable; but that should change in 2.6.33.

Hugh
