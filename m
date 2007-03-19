Return-Path: <linux-kernel-owner+w=401wt.eu-S1030758AbXCSX6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030758AbXCSX6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 19:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030754AbXCSX6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 19:58:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40490
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030766AbXCSX6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 19:58:04 -0400
Date: Mon, 19 Mar 2007 16:58:03 -0700 (PDT)
Message-Id: <20070319.165803.55508162.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: clameter@sgi.com, linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070319165329.b5830789.akpm@linux-foundation.org>
References: <20070319233716.13775.45569.sendpatchset@schroedinger.engr.sgi.com>
	<20070319165329.b5830789.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 19 Mar 2007 16:53:29 -0700

> Would it provide a superior solution if we were to a) stop zeroing out the
> pte's when doing a fullmm==1 teardown and b) go direct to the page allocator
> for these pages?

While you could avoid zero'ing them out, you certainly can't avoid
reading them into the cpu caches.

And for the PGDs you have to initialize these things partially to
non-zero values on x86{,_64} on every new PGD you allocate, which is a
complete waste of cpu cache dirtying.  Avoiding this overhead alone
justifies the quicklists I think.  It's not just a "zero" thing,
so GFP_ZERO cannot help you here.

The more I think about it the more I like the quicklists.

