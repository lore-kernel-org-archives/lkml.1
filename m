Return-Path: <linux-kernel-owner+w=401wt.eu-S1762132AbZD3Aj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132AbZD3Aj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZD3Ajp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:39:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54683 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758942AbZD3Ajo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:39:44 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] vmscan: evict use-once pages first (v3)
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
       Elladan <elladan@eskimo.com>, linux-kernel@vger.kernel.org,
       tytso@mit.edu, linux-mm@kvack.org
In-Reply-To: <20090429131436.640f09ab@cuia.bos.redhat.com>
References: <2f11576a0904290907g48e94e74ye97aae593f6ac519@mail.gmail.com> <20090429131436.640f09ab@cuia.bos.redhat.com>
Message-Id: <20090430093733.D20C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu, 30 Apr 2009 09:39:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When the file LRU lists are dominated by streaming IO pages,
> evict those pages first, before considering evicting other
> pages.
> 
> This should be safe from deadlocks or performance problems
> because only three things can happen to an inactive file page:
> 1) referenced twice and promoted to the active list
> 2) evicted by the pageout code
> 3) under IO, after which it will get evicted or promoted
> 
> The pages freed in this way can either be reused for streaming
> IO, or allocated for something else. If the pages are used for
> streaming IO, this pageout pattern continues. Otherwise, we will
> fall back to the normal pageout pattern.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> 
> ---
> On Thu, 30 Apr 2009 01:07:51 +0900
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > we handle active_anon vs inactive_anon ratio by shrink_list().
> > Why do you insert this logic insert shrink_zone() ?
> 
> Kosaki, this implementation mirrors the anon side of things precisely.
> Does this look good?
> 
> Elladan, this patch should work just like the second version. Please
> let me know how it works for you.

Looks good to me. thanks.
but I don't hit Rik's explained issue, I hope Elladan report his test result.



