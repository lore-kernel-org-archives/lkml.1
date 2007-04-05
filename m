Return-Path: <linux-kernel-owner+w=401wt.eu-S1767383AbXDEWiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767383AbXDEWiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 18:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767381AbXDEWiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 18:38:50 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56029 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767383AbXDEWit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 18:38:49 -0400
Date: Thu, 5 Apr 2007 15:37:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: root@programming.kicks-ass.net
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       a.p.zijlstra@chello.nl, nikita@clusterfs.com
Subject: Re: [PATCH 02/12] mm: scalable bdi statistics counters.
Message-Id: <20070405153746.3cdb9bcd.akpm@linux-foundation.org>
In-Reply-To: <20070405174317.854739299@programming.kicks-ass.net>
References: <20070405174209.498059336@programming.kicks-ass.net>
	<20070405174317.854739299@programming.kicks-ass.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Apr 2007 19:42:11 +0200
root@programming.kicks-ass.net wrote:

> Provide scalable per backing_dev_info statistics counters modeled on the ZVC
> code.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  block/ll_rw_blk.c           |    1 
>  drivers/block/rd.c          |    2 
>  drivers/char/mem.c          |    2 
>  fs/char_dev.c               |    1 
>  fs/fuse/inode.c             |    1 
>  fs/nfs/client.c             |    1 
>  include/linux/backing-dev.h |   98 +++++++++++++++++++++++++++++++++++++++++
>  mm/backing-dev.c            |  103 ++++++++++++++++++++++++++++++++++++++++++++

madness!  Quite duplicative of vmstat.h, yet all this infrastructure
is still only usable in one specific application.

Can we please look at generalising the vmstat.h stuff?

Or, the API in percpu_counter.h appears suitable to this application.
(The comment at line 6 is a total lie).
