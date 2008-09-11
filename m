Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbYIKK4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbYIKK4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 06:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYIKK4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 06:56:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44799 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751521AbYIKK4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 06:56:33 -0400
Date: Thu, 11 Sep 2008 05:56:30 -0500
From: Paul Jackson <pj@sgi.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] cgroup,cpuset: use alternative malloc to allocate
 large memory buf for tasks
Message-Id: <20080911055630.b50e8717.pj@sgi.com>
In-Reply-To: <48C8F32E.2020004@cn.fujitsu.com>
References: <48C8F32E.2020004@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> This new alternative allocation implementation can allocate memory
> up to 64M in 32bits system or 512M in 64bits system.

Just a random idea - it seems to me that this new allocation
implementation might be more generally useful than just for cgroups.

So, instead of having cgroup_huge_mem_alloc() and cgroup_huge_mem_free()
in kernel/cgroup.c, one might have say big_kmalloc() and big_kfree() in
some mm/*.c file.  I used "big" instead of "huge" or "compound" or
"large", as these other adjectives already have other meanings in these
allocator functions.

However ... I would suggest that you do not spend anytime implementing
the above idea unless either (1) it strikes you as absolutely brilliant,
or (2) Paul Menage endorses it.  Paul M has been paying closer attention
to this change than I have, so his recommendations are worth far more
than mine are here.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
