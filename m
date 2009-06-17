Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbZFQCA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbZFQCA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 22:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbZFQCAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 22:00:50 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:40296 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbZFQCAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 22:00:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=BOsJhuuSEFlecbyjCFsBe+JBilwXk8dAxBBkBdluvkhRV6B7qO222vUF5nGbMu7WcM
         w61X8bTY5j6EDXe0U/Nwv8BXo93tFseDJXX5oINOatjNcppsgmYtlCaUNa1oR0ezQNIF
         Lx4UxERjHYUG9T/RtAY5Qb2qZmjDOtZxQ1+Eg=
Date: Wed, 17 Jun 2009 11:00:34 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] mm: remove task assumptions from swap token
Message-Id: <20090617110034.db01479b.minchan.kim@barrios-desktop>
In-Reply-To: <1245189037-22961-2-git-send-email-hannes@cmpxchg.org>
References: <Pine.LNX.4.64.0906162152250.12770@sister.anvils>
	<1245189037-22961-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Hannes. 

How about adding Hugh's comment ?

I think that is more straightforward and easy.
And it explained even real example like KSM. 

So I suggest following as.. 

==
grab_swap_token() should not make any assumptions about the running
process as the swap token is an attribute of the address space and the
faulting mm is not necessarily current->mm.

If a kthread happens to use get_user_pages() on an mm (as KSM does),
there's a chance that it will end up trying to read in a swap page,
then oops in grab_swap_token() because the kthread has no mm: GUP
passes down the right mm, so grab_swap_token() ought to be using it.
==

Anyway, It looks good to me. 
It might be just nitpick :)
If you feel it, ignore me. 
Anyway I am OK. 

On Tue, 16 Jun 2009 23:50:37 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> grab_swap_token() should not make any assumptions about the running
> process as the swap token is an attribute of the address space and the
> faulting mm is not necessarily current->mm.
> 
> This fixes get_user_pages() from kernel threads which would blow up
> when encountering a swapped out page and grab_swap_token()
> dereferencing the unset for kernel threads current->mm.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kinds Regards
Minchan Kim
