Return-Path: <linux-kernel-owner+w=401wt.eu-S1752447AbZL1LGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbZL1LGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 06:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZL1LGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 06:06:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41696 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbZL1LGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 06:06:41 -0500
Subject: Re: [RFC PATCH] asynchronous page fault.
From: Peter Zijlstra <peterz@infradead.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org
In-Reply-To: <50863609fb8263f3a0f9111a304a9dbc.squirrel@webmail-b.css.fujitsu.com>
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
	 <1261915391.15854.31.camel@laptop>
	 <20091228093606.9f2e666c.kamezawa.hiroyu@jp.fujitsu.com>
	 <1261989047.7135.3.camel@laptop>
	 <27db4d47e5a95e7a85942c0278892467.squirrel@webmail-b.css.fujitsu.com>
	 <1261996258.7135.67.camel@laptop>
	 <50863609fb8263f3a0f9111a304a9dbc.squirrel@webmail-b.css.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 12:06:01 +0100
Message-ID: <1261998361.7135.78.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-28 at 19:57 +0900, KAMEZAWA Hiroyuki wrote:
>   - because pmd has some trobles because of quicklists..I don't wanted to
>     touch free routine of them. 

I really doubt the value of that quicklist horror. IIRC x86 stopped
supporting that a while ago as well.

I would suspect the page-table retention scheme possible with RCU freed
page tables could be far more efficient than quicklists, but then that's
all speculation since I don't know what kind of workloads we're talking
about and this glaring lack of implementation to compare.

