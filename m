Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbYGASyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbYGASyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbYGASyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:54:12 -0400
Received: from relay1.sgi.com ([192.48.171.29]:40450 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751053AbYGASyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:54:12 -0400
Date: Tue, 1 Jul 2008 13:54:09 -0500
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: dhaval@linux.vnet.ibm.com, menage@google.com, akpm@linux-foundation.org,
       balbir@in.ibm.com, skumar@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: Attaching PID 0 to a cgroup
Message-Id: <20080701135409.5e68ccd8.pj@sgi.com>
In-Reply-To: <486A06B7.7020906@cn.fujitsu.com>
References: <20080701094545.GD3925@linux.vnet.ibm.com>
	<20080701094734.GE3925@linux.vnet.ibm.com>
	<486A06B7.7020906@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But it's better to document this.

Good idea.

Acked-by: Paul Jackson <pj@sgi.com>

You (Li Zefan) might want to resend this as a patch, in case Andrew
doesn't happen to see this embedded here.

Something like the following:

  Subject: [PATCH] cgroup: document zero pid means current task

  From: Li Zefan <lizf@cn.fujitsu.com>

  Document that a pid of zero(0) can be used to refer to the
  current task when attaching a task to a cgroup, as in the
  following usage:
  
    # echo 0 > /dev/cgroup/tasks

  This is consistent with existing cpuset behavior.

  Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
  Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
  Acked-by: Paul Jackson <pj@sgi.com>

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


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
