Return-Path: <linux-kernel-owner+w=401wt.eu-S2992770AbXDYNjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992770AbXDYNjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992768AbXDYNjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:39:52 -0400
Received: from mail.suse.de ([195.135.220.2]:35797 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161742AbXDYNju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:39:50 -0400
To: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Pratt <slpratt@austin.ibm.com>, Ram Pai <linuxram@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] on-demand readahead
References: <377506695.54393@ustc.edu.cn>
From: Andi Kleen <andi@firstfloor.org>
Date: 25 Apr 2007 16:37:41 +0200
In-Reply-To: <377506695.54393@ustc.edu.cn>
Message-ID: <p73odlc34ga.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@gmail.com> writes:

> OVERHEADS
> 
> The new code reduced the overheads of
> 
> 	- excessively calling the readahead routine on small sized reads
> 	  (the current readahead code insists on seeing all requests)
> 
> 	- doing a lot of pointless page-cache lookups for small cached files
> 	  (the current readahead only turns itself off after 256 cache hits,
> 	  unfortunately most files are < 1MB, so never see that chance)

Would it make sense to keep track in the AS if the file is completely in cache?
Then you could probably avoid a lot of these lookups for small in cache files

> --- linux-2.6.21-rc7-mm1.orig/mm/readahead.c
> +++ linux-2.6.21-rc7-mm1/mm/readahead.c
> @@ -733,6 +733,11 @@ unsigned long max_sane_readahead(unsigne

Quite simple patch, why is it that much simpler than your earlier patchkits?
Or is that on top of them?

You seem to have a lot of magic numbers. They probably all need symbols and 
explanations.

Your white space also needs some work.

-Andi
