Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbXEULuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbXEULuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 07:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbXEULua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 07:50:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56470
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754914AbXEULu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 07:50:29 -0400
Date: Mon, 21 May 2007 04:50:31 -0700 (PDT)
Message-Id: <20070521.045031.45180781.davem@davemloft.net>
To: wli@holomorphy.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: that page count overflow thing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070521113747.GK19966@holomorphy.com>
References: <20070519.152649.102577495.davem@davemloft.net>
	<20070521113747.GK19966@holomorphy.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: William Lee Irwin III <wli@holomorphy.com>
Date: Mon, 21 May 2007 04:37:47 -0700

> This could be awkward with allocation requirements. How about an
> open-addressed hash table? It can be made so large as to never
> need to expand in advance with a very small constant factor space
> overhead.

I was just thinking of a normal hash table with entries that
looked simply like:

struct page_big_count_hash {
       struct page_big_count_hash *next; /* or list_head or hlist_head etc. */
       struct page *key;
       atomic64_t count;
};
