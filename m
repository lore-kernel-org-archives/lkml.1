Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbZANCus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbZANCus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbZANCuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:50:16 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:56470 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754675AbZANCuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:50:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvcDAJrebEl5LDnlgWdsb2JhbACUGgEBFiK5PYVv
X-IronPort-AV: E=Sophos;i="4.37,261,1231075800"; 
   d="scan'208";a="293181703"
Date: Wed, 14 Jan 2009 13:49:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] async: Add some documentation.
Message-ID: <20090114024952.GS8071@disturbed>
Mail-Followup-To: Cornelia Huck <cornelia.huck@de.ibm.com>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org
References: <20090113174306.0f620476@gondolin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113174306.0f620476@gondolin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 05:43:06PM +0100, Cornelia Huck wrote:
> Add some kerneldoc to the async interface.
> 
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> +/**
> + * async_schedule_special - schedule a function for asynchronous execution with a special running queue
> + * @ptr: function to execute asynchronously
> + * @data: data pointer to pass to the function
> + * @running: list head to add to while running
> + *
> + * Returns an async_cookie_t that may be used for checkpointing later.
> + * @running may be used in the async_synchronize_*_special() functions
> + * to wait on a special running queue rather than on the global running
> + * queue.
> + * Note: This function may be called from atomic or non-atomic contexts.
> + */
>  async_cookie_t async_schedule_special(async_func_ptr *ptr, void *data, struct list_head *running)

Rather than polishing a turd, can we rename this "special" stuff to
something more descriptive? I'm not the only person to complain
about this. How about async_schedule_list()?

After all, async_schedule_list() describes *exactly* how it is
different to async_schedule(), while the "_special" keywords really
suck when you consider code is supposed to be self documenting....

> +/**
> + * async_synchronize_cookie_special - synchronize asynchronous function calls on a running list with cookie checkpointing
> + * @cookie: async_cookie_t to use as checkpoint
> + * @running: running list to synchronize on

And I think that description proves my point about the real
meaning of "special" in this API.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
