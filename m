Return-Path: <linux-kernel-owner+w=401wt.eu-S1752400AbZGWFOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbZGWFOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 01:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZGWFOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 01:14:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45951 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbZGWFOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 01:14:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 23 Jul 2009 14:13:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: akpm@linux-foundation.org, lizf@cn.fujitsu.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] CGroup: Support for named and empty hierarchies
Message-Id: <20090723141301.05401a5c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090722194644.7481.47805.stgit@menage.mtv.corp.google.com>
References: <20090722194644.7481.47805.stgit@menage.mtv.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 12:50:24 -0700
Paul Menage <menage@google.com> wrote:

> The following series implements support for named cgroup hierarchies,
> and for cgroup hierarchies that have no bound subsystems.
> 
> This is a subset of the patch series that I sent out as an RFC earlier
> in the month; I'm not pushing the additional support for
> multiply-bound hierarchies at this point.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 

Thank you. I'd like to look into procps package to allow

 #ps -lf -cgroup=/xxxx/yyy
or
 #top -cgroup=/xxx/yyy

I think this can reduce scanning cost of ps/top/pgrep/pkill etc...
(ps can take 1ms if there are lots of processes.)
If rejected, I'll find some other way ;) ../add cgps to libcgroup.

Thanks,
-Kame



> ---
> 
> Paul Menage (4):
>       Support named cgroups hierarchies
>       Move the cgroup debug subsys into cgroup.c to access internal state
>       Add a back-pointer from struct cg_cgroup_link to struct cgroup
>       Allow cgroup hierarchies to be created with no bound subsystems
> 
> 
>  Documentation/cgroups/cgroups.txt |   19 +
>  kernel/Makefile                   |    1 
>  kernel/cgroup.c                   |  660 +++++++++++++++++++++++++++++--------
>  kernel/cgroup_debug.c             |  105 ------
>  4 files changed, 533 insertions(+), 252 deletions(-)
>  delete mode 100644 kernel/cgroup_debug.c
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers

