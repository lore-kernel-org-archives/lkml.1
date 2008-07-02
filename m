Return-Path: <linux-kernel-owner+w=401wt.eu-S1761614AbYGBJn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614AbYGBJn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYGBJnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:43:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54878 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbYGBJnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:43:20 -0400
Message-ID: <486B4D52.80402@cn.fujitsu.com>
Date: Wed, 02 Jul 2008 17:41:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: miaox@cn.fujitsu.com, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>
Subject: Re: [PATCH 1/2] cpusets: restructure the function update_cpumask()
 and update_nodemask()
References: <4843AFC9.7000100@cn.fujitsu.com> <20080702021908.81a5f1bb.akpm@linux-foundation.org>
In-Reply-To: <20080702021908.81a5f1bb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 02 Jun 2008 16:31:05 +0800 Miao Xie <miaox@cn.fujitsu.com> wrote:
> 
>> extract two functions from update_cpumask() and update_nodemask().They will be
>> used later for updating tasks' cpus_allowed and mems_allowed after CPU/NODE
>> offline/online.
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> Acked-by: Paul Jackson <pj@sgi.com>
> 
> This patch has problems.
> 
> kernel/cpuset.c: In function 'cpuset_write_resmask':
> kernel/cpuset.c:1374: warning: passing argument 2 of 'update_nodemask' discards qualifiers from pointer target type
> 
> Did you not get this warning also?
> 
> I don't know how to fix it.  cftype.write_string() requires a const
> char* in the third arg, but we then go on to call update_nodemask(),
> which does a strstrip() on this allegedly-const char array.
> 

That strstrip() should be removed. because cgroup_write_string() already strstrip()ed
the buffer. Paul M's original patch removed that 2 strstrip()s in cpuset.c.

> Taking a copy of the string in update_nodemask() would fix things, but
> that's pretty lame.
> 
