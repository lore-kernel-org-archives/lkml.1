Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbZIUNEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbZIUNEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbZIUNEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:04:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756000AbZIUNEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:04:33 -0400
Message-ID: <4AB77BEF.1050207@redhat.com>
Date: Mon, 21 Sep 2009 16:13:19 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] ksm: fix rare page leak
References: <Pine.LNX.4.64.0909211336300.4809@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909211336300.4809@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> In the rare case when stable_tree_insert() finds a match when the prior
> stable_tree_search() did not, it forgot to free the page reference (the
> omission looks intentional, but I think that's because something else
> used to be done there).
>
> Fix that by one put_page() for all three cases, call it tree_page
> rather than page2[0], clarify the comment on this exceptional case,
> and remove the comment in stable_tree_search() which contradicts it!
>   

I feel small embarrassment, I probably copy-pasted the body of 
unstable_tree_search_insert() when I wrote it.
Good catch Hugh.

Acked-by: Izik Eidus <ieidus@redhat.com>
