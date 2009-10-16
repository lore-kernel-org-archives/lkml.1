Return-Path: <linux-kernel-owner+w=401wt.eu-S1763308AbZJPAHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763308AbZJPAHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 20:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758849AbZJPAHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 20:07:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38229 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758847AbZJPAHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 20:07:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 16 Oct 2009 09:04:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 8/9] swap_info: note SWAP_MAP_SHMEM
Message-Id: <20091016090446.824292c4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0910152317290.4447@sister.anvils>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
	<Pine.LNX.4.64.0910150156060.3291@sister.anvils>
	<20091015123219.43cfd7b1.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0910152317290.4447@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 23:23:24 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> On Thu, 15 Oct 2009, KAMEZAWA Hiroyuki wrote:
> > On Thu, 15 Oct 2009 01:57:28 +0100 (BST)
> > Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> > 
> > > While we're fiddling with the swap_map values, let's assign a particular
> > > value to shmem/tmpfs swap pages: their swap counts are never incremented,
> > > and it helps swapoff's try_to_unuse() a little if it can immediately
> > > distinguish those pages from process pages.
> > > 
> > > Since we've no use for SWAP_MAP_BAD | COUNT_CONTINUED,
> > > we might as well use that 0xbf value for SWAP_MAP_SHMEM.
> > > 
> > > Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> > 
> > I welcome this!
> 
> Ah, I did wonder whether you might find some memcg use for it too:
> I'm guessing your welcome means that you do have some such in mind.
> 
yes, I'm thinking I can use this or not on memcg for simplifying memcg's hooks
for shmem. It's complicated ;)
I have to test memcg+shmem carefully again after this patch but I think
there will be no trouble, now.

> (By the way, there's no particular need to use that 0xbf value:
> during most of my testing I was using SWAP_MAP_SHMEM 0x3e and
> SWAP_MAP_MAX 0x3d; but then noticed that 0xbf just happened to be
> free, and also happened to sail through the tests in the right way.
> But if it ever becomes a nuisance there, no problem to move it.)
> 

Hmm. I myself have no troubles whatever free vaule is used. 
let me clarify..

  xx00 0000
  xx11 1110 - swap count max
  01xx xxxx - swap has cache
  1xxx xxxx - swap count has continuation
  1x11 1111 - swap for shmem

seems not very bad.

Regards,
-Kame

