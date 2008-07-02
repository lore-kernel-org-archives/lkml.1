Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYGBJT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYGBJT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYGBJTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:19:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934AbYGBJTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:19:19 -0400
Date: Wed, 2 Jul 2008 02:19:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: miaox@cn.fujitsu.com
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>, Paul Jackson <pj@sgi.com>,
       Paul Menage <menage@google.com>
Subject: Re: [PATCH 1/2] cpusets: restructure the function update_cpumask()
 and update_nodemask()
Message-Id: <20080702021908.81a5f1bb.akpm@linux-foundation.org>
In-Reply-To: <4843AFC9.7000100@cn.fujitsu.com>
References: <4843AFC9.7000100@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2008 16:31:05 +0800 Miao Xie <miaox@cn.fujitsu.com> wrote:

> extract two functions from update_cpumask() and update_nodemask().They will be
> used later for updating tasks' cpus_allowed and mems_allowed after CPU/NODE
> offline/online.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> Acked-by: Paul Jackson <pj@sgi.com>

This patch has problems.

kernel/cpuset.c: In function 'cpuset_write_resmask':
kernel/cpuset.c:1374: warning: passing argument 2 of 'update_nodemask' discards qualifiers from pointer target type

Did you not get this warning also?

I don't know how to fix it.  cftype.write_string() requires a const
char* in the third arg, but we then go on to call update_nodemask(),
which does a strstrip() on this allegedly-const char array.

Taking a copy of the string in update_nodemask() would fix things, but
that's pretty lame.

