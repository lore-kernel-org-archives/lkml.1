Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbZEKVfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbZEKVfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbZEKVfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:35:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754086AbZEKVfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:35:44 -0400
Date: Mon, 11 May 2009 14:29:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: gregkh@suse.de, npiggin@suse.de, mel@csn.ul.ie, a.p.ziljstra@chello.nl,
       cl@linux-foundation.org, dave@linux.vnet.ibm.com, san@android.com,
       arve@android.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
Message-Id: <20090511142936.dd68005b.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0905101502050.18804@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
	<alpine.DEB.2.00.0905101502050.18804@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 May 2009 15:07:21 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> The oom killer must be invoked regardless of the order if the allocation
> is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to
> free some memory.

We should discourage callers from using __GFP_NOFAIL at all.  We should
electrocute callers for using __GFP_NOFAIL on large allocations.  How's about

	WARN_ON_ONCE(order > PAGE_ALLOC_COSTLY_ORDER &&	
			(gfp_mask & __GFP_NOFAIL));
or, preferably:

	WARN_ON_ONCE(order > 0 && (gfp_mask & __GFP_NOFAIL));

?
