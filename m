Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYG1Eh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYG1Eh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 00:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbYG1Eht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 00:37:49 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54562 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750922AbYG1Eht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 00:37:49 -0400
Date: Sun, 27 Jul 2008 23:37:46 -0500
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, menage@google.com,
       seto.hidetoshi@jp.fujitsu.com, laijs@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cpuset: clean up cpuset hierarchy traversal code
Message-Id: <20080727233746.7f057e74.pj@sgi.com>
In-Reply-To: <488D332A.1030008@cn.fujitsu.com>
References: <488D332A.1030008@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> +	list_add(&top_cpuset.stack_list, &q);

Can you figure out if we are holding any system wide lock, such as
cgroup_mutex, at this point?  There is only one top_cpuset.stack_list
in the system, so I would think that we need to single thread its usage
somehow.

The hotplug hooks, such as common_cpu_mem_hotplug_unplug() that were
added sometime in the last few months (while the so called maintainer,
who's initials seem to be 'pj', was asleep ;) don't describe what
locking applies to them very well, and they call rebuild_sched_domains(),
where the above line of code lives.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
