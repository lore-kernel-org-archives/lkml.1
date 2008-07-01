Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbYGAKaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbYGAKaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 06:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYGAK3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 06:29:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50156 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbYGAK3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 06:29:55 -0400
Message-ID: <486A06B7.7020906@cn.fujitsu.com>
Date: Tue, 01 Jul 2008 18:28:07 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@in.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, containers@lists.osdl.org,
       Paul Jackson <pj@sgi.com>
Subject: Re: Attaching PID 0 to a cgroup
References: <20080701094545.GD3925@linux.vnet.ibm.com> <20080701094734.GE3925@linux.vnet.ibm.com>
In-Reply-To: <20080701094734.GE3925@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Paul Jackson <pj@sgi.com>

Dhaval Giani wrote:
> [put in the wrong alias for containers list correcting it.]
> 
> On Tue, Jul 01, 2008 at 03:15:45PM +0530, Dhaval Giani wrote:
>> Hi Paul,
>>
>> Attaching PID 0 to a cgroup caused the current task to be attached to
>> the cgroup. Looking at the code,
>>

[...]

>>
>> I was wondering, why this was done. It seems to be unexpected behavior.
>> Wouldn't something like the following be a better response? (I've used
>> EINVAL, but I can change it to ESRCH if that is better.)
>>

Why is it unexpected? it follows the behavior of cpuset, so this patch will
break backward compatibility of cpuset.

But it's better to document this.

-----------------------------------------

Document the following cgroup usage:
 # echo 0 > /dev/cgroup/tasks

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 cgroups.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/cgroups.txt b/Documentation/cgroups.txt
index 824fc02..213f533 100644
--- a/Documentation/cgroups.txt
+++ b/Documentation/cgroups.txt
@@ -390,6 +390,10 @@ If you have several tasks to attach, you have to do it one after another:
 	...
 # /bin/echo PIDn > tasks
 
+You can attach the current task by echoing 0:
+
+# /bin/echo 0 > tasks
+
 3. Kernel API
 =============
 


