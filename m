Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbZLDOtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbZLDOtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbZLDOtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:49:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952AbZLDOtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:49:10 -0500
Date: Fri, 4 Dec 2009 15:49:08 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Chris Wright <chrisw@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
Message-ID: <20091204144908.GJ28697@random.random>
References: <20091202125501.GD28697@random.random>
 <20091203134610.586E.A69D9226@jp.fujitsu.com>
 <20091204135938.5886.A69D9226@jp.fujitsu.com>
 <20091204141617.f4c491e7.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204141617.f4c491e7.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 02:16:17PM +0900, KAMEZAWA Hiroyuki wrote:
> Hmm, can't we use ZERO_PAGE we have now ?
> If do so,
>  - no mapcount check
>  - never on LRU
>  - don't have to maintain shared information because ZERO_PAGE itself has
>    copy-on-write nature.

The zero page could be added to the stable tree always to avoid a
memcmp and we could try to merge anon pages into it, instead of
merging it into ksmpages, but it's not a ksm page so it would require
special handling with branches. We considered doing a magic on
zeropage but we though it's not worth it. We need CPU to be efficient
on very shared pages not just zero page without magics, and the memory
saving is just 4k system-wide (all zero pages of all windows are
already shared).
