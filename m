Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbZKRGbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbZKRGbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 01:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbZKRGbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 01:31:19 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35892 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbZKRGbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 01:31:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 6/7] cifs: Don't use PF_MEMALLOC
Cc: kosaki.motohiro@jp.fujitsu.com, Jeff Layton <jlayton@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, samba-technical@lists.samba.org,
       Steve French <sfrench@samba.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-cifs-client@lists.samba.org
In-Reply-To: <524f69650911170840o5be241a0q5d9863c8d7f4e571@mail.gmail.com>
References: <20091117074739.4abaef85@tlielax.poochiereds.net> <524f69650911170840o5be241a0q5d9863c8d7f4e571@mail.gmail.com>
Message-Id: <20091118152007.3E1D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 18 Nov 2009 15:31:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is hard to follow exactly what this flag does in /mm (other than try
> harder on memory allocations) - I haven't found much about this flag (e.g.
> http://lwn.net/Articles/246928/) but it does look like most of the fs no
> longer set this (except xfs) e.g. ext3_ordered_writepage.  When running out
> of memory in the cifs_demultiplex_thread it will retry 3 seconds later, but
> if memory allocations ever fail in this path we could potentially be holding
> up (an already issued write in) writepages for that period by not having
> memory to get the response to see if the write succeeded.
> 
> We pass in few flags for these memory allocation requests: GFP_NOFS (on the
> mempool_alloc) and SLAB_HWCACHE_ALIGN (on the kmem_cache_create of the pool)
> should we be passing in other flags on the allocations?

I don't think you  need change more.



