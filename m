Return-Path: <linux-kernel-owner+w=401wt.eu-S935767AbXGMHDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935767AbXGMHDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXGMHDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:03:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60193 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134AbXGMHDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:03:11 -0400
Date: Thu, 12 Jul 2007 23:57:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Jin <joe.jin@oracle.com>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org, gurudas.pai@oracle.com
Cc: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-Id: <20070712235707.a08f0d42.akpm@linux-foundation.org>
In-Reply-To: <20070712234938.c77f3a48.akpm@linux-foundation.org>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
	<20070712221842.f5e47065.akpm@linux-foundation.org>
	<20070713064004.GA21833@joejin-pc.cn.oracle.com>
	<20070712234938.c77f3a48.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 23:49:38 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> first_node(node_online_map);

Incidentally, we have a helper for this operation:

#if MAX_NUMNODES > 1
...
#define first_online_node	first_node(node_online_map)
...
#else
...
#define first_online_node	0
...
#endif

So I suppose we should use that - it should generate better code for
non-NUMA builds.

It's a pretty sadly implemented helper though.  It should be
"first_online_node()", not "first_online_node".


I'm scratching my head over that min_t in __first_node(), too.   I don't think
it's possible for find_first_bit(..., N) to return anything >N _anyway_.  And if
it does, we want to know about it.

<looks at Paul>
