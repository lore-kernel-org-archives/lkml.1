Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab0BUXvu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 18:51:50 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44995 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab0BUXvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 18:51:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 22 Feb 2010 08:48:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Righi <arighi@develer.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Suleiman Souhlal <suleiman@google.com>, Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 0/2] memcg: per cgroup dirty limit
Message-Id: <20100222084807.fee163f6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1266765525-30890-1-git-send-email-arighi@develer.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Feb 2010 16:18:43 +0100
Andrea Righi <arighi@develer.com> wrote:

> Control the maximum amount of dirty pages a cgroup can have at any given time.
> 
> Per cgroup dirty limit is like fixing the max amount of dirty (hard to reclaim)
> page cache used by any cgroup. So, in case of multiple cgroup writers, they
> will not be able to consume more than their designated share of dirty pages and
> will be forced to perform write-out if they cross that limit.
> 
> The overall design is the following:
> 
>  - account dirty pages per cgroup
>  - limit the number of dirty pages via memory.dirty_bytes in cgroupfs
>  - start to write-out in balance_dirty_pages() when the cgroup or global limit
>    is exceeded
> 
> This feature is supposed to be strictly connected to any underlying IO
> controller implementation, so we can stop increasing dirty pages in VM layer
> and enforce a write-out before any cgroup will consume the global amount of
> dirty pages defined by the /proc/sys/vm/dirty_ratio|dirty_bytes limit.
> 
> TODO:
>  - handle the migration of tasks across different cgroups (a page may be set
>    dirty when a task runs in a cgroup and cleared after the task is moved to
>    another cgroup).
>  - provide an appropriate documentation (in Documentation/cgroups/memory.txt)
> 

Thank you, this was a long concern in memcg.

Regards,
-Kame


> -Andrea
> 

