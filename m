Return-Path: <linux-kernel-owner+w=401wt.eu-S1764404AbXGNBWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764404AbXGNBWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761489AbXGNBWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:22:33 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58417 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760283AbXGNBWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:22:32 -0400
Date: Fri, 13 Jul 2007 18:22:25 -0700
From: sukadev@us.ibm.com
To: Pavel Emelianov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Cedric Le Goater <clg@fr.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 3/3] Dynamic kmem cache allocator for pid namespaces
Message-ID: <20070714012225.GA29647@us.ibm.com>
References: <46939561.4070100@openvz.org> <4693977A.5030501@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4693977A.5030501@openvz.org>
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov [xemul@openvz.org] wrote:
| Add kmem_cache to pid_namespace to allocate pids from.
| 
| Since booth implementations expand the struct pid to carry
| more numerical values each namespace should have separate
| cache to store pids of different sizes.
| 
| Each kmem cache is names "pid_<NR>", where <NR> is the number
| of numerical ids on the pid. Different namespaces with same
| level of nesting will have same caches.
| 
| This patch has two FIXMEs that are to be fixed after we reach
| the consensus about the struct pid itself.
| 
| The first one is that the namespace to free the pid from in
| free_pid() must be taken from pid. Now the init_pid_ns is
| used.
| 
| The second FIXME is about the cache allocation. When we do know
| how long the object will be then we'll have to calculate this
| size in create_pid_cachep. Right now the sizeof(struct pid)
| value is used.
| 
| Signed-off-by: Pavel Emelianov <xemul@openvz.org>
| Acked-by: Cedric Le Goater <clg@fr.ibm.com>
| Acked-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
| 
| ---
| 
| diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
| index ddb9a4c..27cfad3 100644
| --- a/include/linux/pid_namespace.h
| +++ b/include/linux/pid_namespace.h
| @@ -20,6 +20,7 @@ struct pid_namespace {
|  	struct pidmap pidmap[PIDMAP_ENTRIES];
|  	int last_pid;
|  	struct task_struct *child_reaper;
| +	struct kmem_cache_t *pid_cachep;

Shouldn't this be 'struct kmem_cache *' ?
