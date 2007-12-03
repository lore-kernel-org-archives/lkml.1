Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbXLCSu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbXLCSu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 13:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbXLCSuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 13:50:15 -0500
Received: from waste.org ([66.93.16.53]:33970 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbXLCSuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 13:50:14 -0500
Date: Mon, 3 Dec 2007 12:49:59 -0600
From: Matt Mackall <mpm@selenic.com>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: drivers/char/random.c:write_pool() -- cond_resched needed?
Message-ID: <20071203184958.GN17536@waste.org>
References: <20071130215810.d3m43bwobifihfiu@m.safari.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130215810.d3m43bwobifihfiu@m.safari.iki.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 11:58:10PM +0200, Sami Farin wrote:
> In write_pool(), isn't cond_resched() needed after call to
> add_entropy_words() because otherwise there can be large latencies
> (think of command "dd if=/dev/zero of=/dev/random bs=100000000" ) ?

Yes, looks like you're right.

Reduce latency for large writes to /dev/[u]random

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r c60016ba6237 drivers/char/random.c
--- a/drivers/char/random.c	Tue Nov 13 09:09:36 2007 -0800
+++ b/drivers/char/random.c	Mon Dec 03 12:48:30 2007 -0600
@@ -1041,6 +1041,7 @@ write_pool(struct entropy_store *r, cons
 		p += bytes;
 
 		add_entropy_words(r, buf, (bytes + 3) / 4);
+		cond_resched();
 	}
 
 	return 0;


-- 
Mathematics is the supreme nostalgia of our time.
