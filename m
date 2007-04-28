Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbXD1Jy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbXD1Jy3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 05:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbXD1Jy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 05:54:29 -0400
Received: from ns.suse.de ([195.135.220.2]:37198 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbXD1Jy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 05:54:28 -0400
To: Roland Dreier <rdreier@cisco.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
References: <20070423141123.GA21174@skybase>
	<20070423104534.51bac974.akpm@linux-foundation.org>
	<20070425112133.4ae86399.randy.dunlap@oracle.com>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<20070426003911.GA19383@redhat.com> <4630109F.6090002@oracle.com>
	<20070425200207.77a2721a.akpm@linux-foundation.org>
	<20070428030805.GA13331@redhat.com>
	<20070427221803.2a117c23.akpm@linux-foundation.org>
	<adaodl9m4ia.fsf@cisco.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 28 Apr 2007 12:52:14 +0200
In-Reply-To: <adaodl9m4ia.fsf@cisco.com>
Message-ID: <p73ps5o22ld.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> writes:

>  > Checking patches/git-infiniband.patch:  signoffs = 113
>  > Use WARN_ON & Recovery code rather than BUG() and BUG_ON()
>  > 8143:+  BUG_ON(mlx4_ib_alloc_db_from_pgdir(pgdir, db, order));
>  > 12629:+ BUG_ON(cmd->free_head < 0);
>  > 16580:+         BUG_ON(index < dev->caps.num_mgms);
>  > 16665:+                 BUG_ON(amgm_index_to_free < dev->caps.num_mgms);
>  > 16681:+         BUG_ON(index < dev->caps.num_mgms);
> 
> I agree -- killing the kernel for a driver bug is dump.  I'll remove
> all these BUGs before merging.

So you prefer to corrupt data instead?  I don't think that's a good idea.
Don't do it. Silent failures are really bad.

BUG_ONs are only fatal when you're in interrupt context anyways because
it often ends up trying to kill the idle task. In process context
while there might be some lost locks in most cases the system continues
running happily. 

At some point I had  a hack to just restart idle to handle the 
interrupt case too. Perhaps that might be worth resurrecting if you
want to solve this properly. 

Would be imho far preferable over not having the BUGs imho.

-Andi
