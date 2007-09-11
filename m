Return-Path: <linux-kernel-owner+w=401wt.eu-S933510AbXIKJ0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510AbXIKJ0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 05:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762225AbXIKJ0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 05:26:40 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17234 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759490AbXIKJ0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 05:26:39 -0400
Date: Tue, 11 Sep 2007 11:35:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@snapgear.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] splice: Disable vmsplice on nommu.
Message-ID: <20070911093510.GA15405@kernel.dk>
References: <20070911082307.GB19495@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911082307.GB19495@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11 2007, Paul Mundt wrote:
> The vmsplice rework in -mm breaks nommu:
> 
> fs/built-in.o: In function `splice_setup_vma':
> fs/splice.c:1272: undefined reference to `may_expand_vm'
> fs/splice.c:1272: undefined reference to `protection_map'
> fs/splice.c:1272: undefined reference to `insert_vm_struct'
> fs/splice.c:1272: undefined reference to `vm_stat_account'
> 
> This is going to be non-trivial to wire up properly on nommu, and
> it's debateable whether there's even any point in trying. For now,
> disable vmsplice if CONFIG_MMU=n and wire it up as a cond syscall
> for the platforms that support both.

It's a bit of a sledge hammer... Since get_user_pages() appears to work
on nummu, we can just disable the vmsplice-to-userspace bits and leave
the (working) vmsplice-from-userspace in place.

I'm reworking this code anyway in the block branches, so I'll update and
take CONFIG_MMU into consideration.

-- 
Jens Axboe

