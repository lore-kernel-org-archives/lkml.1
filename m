Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbXDTFKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbXDTFKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbXDTFKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:10:00 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752992AbXDTFJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:09:59 -0400
Date: Thu, 19 Apr 2007 22:08:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelianov <xemul@sw.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eric Dumazet <dada1@cosmosbay.com>, Dave Hansen <hansendc@us.ibm.com>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH] Show slab memory usage on OOM and SysRq-M (v3)
Message-Id: <20070419220801.2f73083f.akpm@linux-foundation.org>
In-Reply-To: <4625C4FD.9020600@sw.ru>
References: <4625C4FD.9020600@sw.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007 11:13:01 +0400 Pavel Emelianov <xemul@sw.ru> wrote:

> The out_of_memory() function and SysRq-M handler call
> show_mem() to show the current memory usage state.
> 
> This is also helpful to see which slabs are the largest
> in the system.
> 
> Thanks Pekka for good idea of how to make it better.
> 
> The nr_pages is stored on kmem_list3 because:
> 
> 1. as Eric pointed out, we do not want to defeat 
>    NUMA optimizations;
> 2. we do not need for additional LOCK-ed operation on
>    altering this field - l3->list_lock is already taken
>    where needed.
> 
> Made naming more descriptive according to Dave.
> 
> Signed-off-by: Pavel Emelianov <xemul@openvz.org>
> Signed-off-by: Kirill Korotaev <dev@openvz.org>
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Eric Dumazet <dada1@cosmosbay.com>
> Cc: Dave Hansen <hansendc@us.ibm.com>
> 

This is rather a lot of new code and even new locking.

Any time we actually need this what-the-heck-is-happening-in-slab info, the
reporter is able to work out the problem via /proc/slabinfo.  Either by
taking a look in there before the system dies completely, or by looking in
there after the oom-killing.
