Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZGZQBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZGZQBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 12:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZGZQBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 12:01:19 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:28762 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751850AbZGZQBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 12:01:19 -0400
X-Trace: 236284260/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.106.223/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.106.223
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkQFANcabEpQKWrf/2dsb2JhbACBUMpqhA0F
X-IronPort-AV: E=Sophos;i="4.43,272,1246834800"; 
   d="scan'208";a="236284260"
Date: Sun, 26 Jul 2009 17:00:54 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de, avi@redhat.com,
       torvalds@linux-foundation.org, aarcange@redhat.com
Subject: Re: [PATCH 0/2] ZERO PAGE again v4.
In-Reply-To: <20090723093334.3166e9d2.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0907261639570.32238@sister.anvils>
References: <20090709122428.8c2d4232.kamezawa.hiroyu@jp.fujitsu.com>
 <20090716180134.3393acde.kamezawa.hiroyu@jp.fujitsu.com>
 <20090723085137.b14fe267.kamezawa.hiroyu@jp.fujitsu.com>
 <20090722171245.d5b3a108.akpm@linux-foundation.org>
 <20090723093334.3166e9d2.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009, KAMEZAWA Hiroyuki wrote:
> On Wed, 22 Jul 2009 17:12:45 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Thu, 23 Jul 2009 08:51:37 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > On Thu, 16 Jul 2009 18:01:34 +0900
> > > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > > 
> > > > Rebased onto  mm-of-the-moment snapshot 2009-07-15-20-57.
> > > > And modifeied to make vm_normal_page() eat FOLL_NOZERO, directly.
> > > > 
> > > > Any comments ?

Sorry, I've been waiting to have something positive to suggest,
but today still busy with my own issues (handling OOM in KSM).

I do dislike that additional argument to vm_normal_page, and
feel that's a problem to be solved in follow_page, rather
than spread to every other vm_normal_page user.

Does follow_page even need to be using vm_normal_page?
Hmm, VM_MIXEDMAP, __get_user_pages doesn't exclude that.

I also feel a strong (but not yet fulfilled) urge to check
all the use_zero_page ignore_zero stuff: which is far from
self-evident.

Hugh
