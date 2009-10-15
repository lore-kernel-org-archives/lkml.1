Return-Path: <linux-kernel-owner+w=401wt.eu-S1762966AbZJOWYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762966AbZJOWYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 18:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758534AbZJOWYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 18:24:03 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:60197 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756281AbZJOWYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 18:24:01 -0400
X-Trace: 275023207/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.3.134/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.3.134
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAKM910pPRQOG/2dsb2JhbACBUtdGhDAE
X-IronPort-AV: E=Sophos;i="4.44,568,1249254000"; 
   d="scan'208";a="275023207"
Date: Thu, 15 Oct 2009 23:23:24 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 8/9] swap_info: note SWAP_MAP_SHMEM
In-Reply-To: <20091015123219.43cfd7b1.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0910152317290.4447@sister.anvils>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
 <Pine.LNX.4.64.0910150156060.3291@sister.anvils>
 <20091015123219.43cfd7b1.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, KAMEZAWA Hiroyuki wrote:
> On Thu, 15 Oct 2009 01:57:28 +0100 (BST)
> Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> 
> > While we're fiddling with the swap_map values, let's assign a particular
> > value to shmem/tmpfs swap pages: their swap counts are never incremented,
> > and it helps swapoff's try_to_unuse() a little if it can immediately
> > distinguish those pages from process pages.
> > 
> > Since we've no use for SWAP_MAP_BAD | COUNT_CONTINUED,
> > we might as well use that 0xbf value for SWAP_MAP_SHMEM.
> > 
> > Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> I welcome this!

Ah, I did wonder whether you might find some memcg use for it too:
I'm guessing your welcome means that you do have some such in mind.

(By the way, there's no particular need to use that 0xbf value:
during most of my testing I was using SWAP_MAP_SHMEM 0x3e and
SWAP_MAP_MAX 0x3d; but then noticed that 0xbf just happened to be
free, and also happened to sail through the tests in the right way.
But if it ever becomes a nuisance there, no problem to move it.)

Hugh
