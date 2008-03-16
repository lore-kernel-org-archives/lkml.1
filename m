Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbYCPSeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbYCPSeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 14:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYCPSeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 14:34:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53637 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYCPSeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 14:34:08 -0400
Date: Sun, 16 Mar 2008 11:32:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][3/3] Update documentation for virtual address space
 control
Message-Id: <20080316113200.cc6da618.randy.dunlap@oracle.com>
In-Reply-To: <20080316173017.8812.41614.sendpatchset@localhost.localdomain>
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain>
	<20080316173017.8812.41614.sendpatchset@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Mar 2008 23:00:17 +0530 Balbir Singh wrote:

> This patch adds documentation for virtual address space control.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
>  Documentation/controllers/memory.txt |   26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff -puN Documentation/controllers/memory.txt~memory-controller-virtual-address-control-documentation Documentation/controllers/memory.txt
> --- linux-2.6.25-rc5/Documentation/controllers/memory.txt~memory-controller-virtual-address-control-documentation	2008-03-16 22:57:44.000000000 +0530
> +++ linux-2.6.25-rc5-balbir/Documentation/controllers/memory.txt	2008-03-16 22:57:44.000000000 +0530
> @@ -237,7 +237,31 @@ cgroup might have some charge associated
>  tasks have migrated away from it. Such charges are automatically dropped at
>  rmdir() if there are no tasks.
>  
> -5. TODO
> +5. Virtual address space accounting
> +
> +A new resource counter controls the address space expansion of the tasks in
> +the cgroup. Address space control is provided along the same lines as
> +RLIMIT_AS control, which is available via getrlimit(2)/setrlimit(2).
> +The interface for controlling address space is provided through
> +"as_limit_in_bytes". The file is similar to "limit_in_bytes" w.r.t the user

                                                                w.r.t.
  or even spelled out.

> +interface. Please see section 3 for more details on how to use the user
> +interface to get and set values.
> +
> +The "as_usage_in_bytes" file provides information about the total address
> +space usage of the cgroup in bytes.
> +
> +5.1 Advantages of providing this feature
> +
> +1. Control over virtual address space allows for a cgroup to fail gracefully
> +   i.e, via a malloc or mmap failure as compared to OOM kill when no

      i.e.,

> +   pages can be reclaimed

end with period.

> +2. It provides better control over how many pages can be swapped out when
> +   the cgroup goes over it's limit. A badly setup cgroup can cause excessive

                           its (not "it is")

> +   swapping. Providing control over the address space allocations ensures
> +   that the system administrator has control over the total swapping that
> +   can take place.
> +
> +6. TODO
>  
>  1. Add support for accounting huge pages (as a separate controller)
>  2. Make per-cgroup scanner reclaim not-shared pages first
> _

---
~Randy
