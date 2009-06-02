Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbZFBGmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbZFBGmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 02:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZFBGmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 02:42:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60032 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbZFBGmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 02:42:14 -0400
Message-ID: <4A24CA1B.5020604@cn.fujitsu.com>
Date: Tue, 02 Jun 2009 14:43:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroups: forbid noprefix if mounting more than just cpuset
 subsystem
References: <4A24911F.4070601@cn.fujitsu.com> <20090601230251.57411c83.akpm@linux-foundation.org>
In-Reply-To: <20090601230251.57411c83.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +	/* We allow noprefix only if mounting just the cpuset subsystem */
>> +	if (test_bit(ROOT_NOPREFIX, &opts->flags) &&
>> +	    (opts->subsys_bits & mask))
>> +		return -EINVAL;
>> +
> 
> uh, OK.  I hope that comment is clear enough for anyone who wants to
> understand it.   It doesn't explain _why_ this is done..
> 

I agree more explanation is better..

====

From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] cgroups: forbid noprefix if mounting more than just cpuset subsystem, fix2

Explain more on the noprefix option.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ad17f9d..d15432c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -891,7 +891,11 @@ static int parse_cgroupfs_options(char *data,
 		}
 	}
 
-	/* We allow noprefix only if mounting just the cpuset subsystem */
+	/*
+	 * Option noprefix was introduced just for backward compatibility
+	 * with the old cpuset, so we allow noprefix only if mounting just
+	 * the cpuset subsystem.
+	 */
 	if (test_bit(ROOT_NOPREFIX, &opts->flags) &&
 	    (opts->subsys_bits & mask))
 		return -EINVAL;
-- 
1.5.4.rc3


