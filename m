Return-Path: <linux-kernel-owner+w=401wt.eu-S932537AbYCFTN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbYCFTN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 14:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763075AbYCFTNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 14:13:01 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:17803 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103AbYCFTNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 14:13:00 -0500
Date: Thu, 6 Mar 2008 11:11:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Add cgroup support for enabling controllers at boot
 time
Message-Id: <20080306111145.27efc74c.randy.dunlap@oracle.com>
In-Reply-To: <20080306185952.23290.49571.sendpatchset@localhost.localdomain>
References: <20080306185952.23290.49571.sendpatchset@localhost.localdomain>
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

On Fri, 07 Mar 2008 00:29:52 +0530 Balbir Singh wrote:

> From: Paul Menage <menage@google.com>
> 
> The effects of cgroup_disable=foo are:
> 
> - foo doesn't show up in /proc/cgroups
> - foo isn't auto-mounted if you mount all cgroups in a single hierarchy
> - foo isn't visible as an individually mountable subsystem
> 
> As a result there will only ever be one call to foo->create(), at init
> time; all processes will stay in this group, and the group will never
> be mounted on a visible hierarchy. Any additional effects (e.g. not
> allocating metadata) are up to the foo subsystem.
> 
> This doesn't handle early_init subsystems (their "disabled" bit isn't
> set be, but it could easily be extended to do so if any of the early_init
> systems wanted it - I think it would just involve some nastier parameter
> processing since it would occur before the command-line argument parser
> had been run.
> 
> [Balbir added Documentation/kernel-parameters updates]
> 
> Signed-off-by: Paul Menage <menage@google.com>
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
>  Documentation/kernel-parameters.txt |    4 ++++
>  include/linux/cgroup.h              |    1 +
>  kernel/cgroup.c                     |   27 +++++++++++++++++++++++++--
>  3 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff -puN Documentation/kernel-parameters.txt~cgroup_disable Documentation/kernel-parameters.txt
> --- linux-2.6.25-rc4/Documentation/kernel-parameters.txt~cgroup_disable	2008-03-06 17:57:32.000000000 +0530
> +++ linux-2.6.25-rc4-balbir/Documentation/kernel-parameters.txt	2008-03-06 18:00:32.000000000 +0530
> @@ -383,6 +383,10 @@ and is between 256 and 4096 characters. 
>  	ccw_timeout_log [S390]
>  			See Documentation/s390/CommonIO for details.
>  
> +	cgroup_disable= [KNL] Enable disable a particular controller

So it can enable or disable?  or the text has extra text?

> +			Format: {name of the controller}
> +			See /proc/cgroups for a list of compiled controllers
> +
>  	checkreqprot	[SELINUX] Set initial checkreqprot flag value.
>  			Format: { "0" | "1" }
>  			See security/selinux/Kconfig help text.


---
~Randy
