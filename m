Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbXJUTQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbXJUTQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 15:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbXJUTQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 15:16:23 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11297 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbXJUTQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 15:16:23 -0400
Date: Sun, 21 Oct 2007 21:16:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq_get_queue: fix possible NULL pointer access
Message-ID: <20071021191618.GU10674@kernel.dk>
References: <20071020131148.GA3033@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071020131148.GA3033@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20 2007, Oleg Nesterov wrote:
> cfq_get_queue()->cfq_find_alloc_queue() can fail, check the returned value.

Thanks, applied! No normal IO paths use it without __GFP_WAIT, so it's
not a critical fix. But that could change in the future and then cause
allocation failure, so I'll add the patch.

-- 
Jens Axboe

