Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbZIMXLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbZIMXLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 19:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZIMXLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 19:11:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbZIMXLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 19:11:48 -0400
Subject: Re: [GIT BISECT] BUG kmalloc-8192: Object already free from
 kmem_cache_destroy
From: Eric Paris <eparis@redhat.com>
To: cl@linux-foundation.org
Cc: dfeng@redhat.com, penberg@cs.helsinki.fi, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1252866835.13780.37.camel@dhcp231-106.rdu.redhat.com>
References: <1252866835.13780.37.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Sep 2009 19:11:33 -0400
Message-Id: <1252883493.16335.8.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-13 at 14:33 -0400, Eric Paris wrote:
> 2a38a002fbee06556489091c30b04746222167e4 is first bad commit
> commit 2a38a002fbee06556489091c30b04746222167e4
> Author: Xiaotian Feng <dfeng@redhat.com>
> Date:   Wed Jul 22 17:03:57 2009 +0800
> 
>     slub: sysfs_slab_remove should free kmem_cache when debug is enabled
>     
>     kmem_cache_destroy use sysfs_slab_remove to release the kmem_cache,
>     but when CONFIG_SLUB_DEBUG is enabled, sysfs_slab_remove just release
>     related kobject, the whole kmem_cache is missed to release and cause
>     a memory leak.
>     
>     Acked-by: Christoph Lameer <cl@linux-foundation.org>
>     Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
>     Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> CONFIG_SLUB_DEBUG=y
> CONFIG_SLUB=y
> CONFIG_SLUB_DEBUG_ON=y
> # CONFIG_SLUB_STATS is not set

I also had problems destroying a kmem_cache in a security_initcall()
function which had a different backtrace (it's what made me create the
module and bisect.)   So be sure to let me know what you find so I can
be sure that we fix that place as well   (I believe that was a kref
problem rather than a double free)

-Eric

