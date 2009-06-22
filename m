Return-Path: <linux-kernel-owner+w=401wt.eu-S1751550AbZFVAkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbZFVAkL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 20:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbZFVAj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 20:39:59 -0400
Received: from mail-px0-f202.google.com ([209.85.216.202]:48494 "EHLO
	mail-px0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbZFVAj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 20:39:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=hwz285e7TBXVvwNYdsLkl0qrrSSLEvo4xQzpcYLpUdKni5MH/UTbcIen8GTifUMeX7
         aBxTfYsALtpMawMYwwaluGAHc/ONFpNjRO5hb0aoZr6fSRU8qZvs6kh4SMy9DAXPT7LS
         LFKbMDDupfk8kTHhyVx11mIo+JKv4z97hm/+c=
Date: Mon, 22 Jun 2009 09:32:47 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: pass mm to grab_swap_token
Message-Id: <20090622093247.bc4f4c0f.minchan.kim@barrios-desktop>
In-Reply-To: <Pine.LNX.4.64.0906211326520.6124@sister.anvils>
References: <4A37DEE7.1000208@redhat.com>
	<20090616181325.GC23969@random.random>
	<Pine.LNX.4.64.0906161930050.24878@sister.anvils>
	<20090616200852.GA16265@cmpxchg.org>
	<Pine.LNX.4.64.0906162152250.12770@sister.anvils>
	<20090616215200.GA19781@cmpxchg.org>
	<Pine.LNX.4.64.0906211326520.6124@sister.anvils>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jun 2009 14:02:43 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> If a kthread happens to use get_user_pages() on an mm (as KSM does),
> there's a chance that it will end up trying to read in a swap page,
> then oops in grab_swap_token() because the kthread has no mm: GUP
> passes down the right mm, so grab_swap_token() ought to be using it.
> 
> We have not identified a stronger case than KSM's daemon (not yet
> in mainline), but the issue must have come up before, since RHEL has
> included a fix for this for years (though a different fix, they just
> back out of grab_swap_token if current->mm is unset: which is what
> we first proposed, but using the right mm here seems more correct).
> 
> Reported-by: Izik Eidus <ieidus@redhat.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

I already added my sign to Hannes but it is folded in this patch.

-- 
Kinds Regards
Minchan Kim
