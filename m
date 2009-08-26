Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbZHZKe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbZHZKe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757275AbZHZKey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:34:54 -0400
Received: from cmpxchg.org ([85.214.51.133]:49347 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261AbZHZKew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:34:52 -0400
Date: Wed, 26 Aug 2009 12:33:58 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mmotm] mm: introduce page_lru_base_type fix
Message-ID: <20090826103358.GA26897@cmpxchg.org>
References: <Pine.LNX.4.64.0908261050080.18633@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908261050080.18633@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 10:53:47AM +0100, Hugh Dickins wrote:
> My usual tmpfs swapping loads on recent mmotms have oddly
> aroused the OOM killer after an hour or two.  Bisection led to
> mm-return-boolean-from-page_is_file_cache.patch, but really it's
> the prior mm-introduce-page_lru_base_type.patch that's at fault.
> 
> It converted page_lru() to use page_lru_base_type(), but forgot
> to convert del_page_from_lru() - which then decremented the wrong
> stats once page_is_file_cache() was changed to a boolean.

Ouch, sorry.  Thanks for your fix.

> Fix that, move page_lru_base_type() before del_page_from_lru(),
> and mark it "inline" like the other mm_inline.h functions.

	Hannes
