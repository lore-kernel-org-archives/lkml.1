Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbXKPQq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbXKPQq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 11:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbXKPQqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 11:46:50 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:32007 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbXKPQqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 11:46:49 -0500
Date: Fri, 16 Nov 2007 08:45:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 2/4] proc: detect duplicate names on registration
Message-Id: <20071116084526.81569440.randy.dunlap@oracle.com>
In-Reply-To: <20071116150839.GD19517@localhost.sw.ru>
References: <20071116150839.GD19517@localhost.sw.ru>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007 18:08:40 +0300 Alexey Dobriyan wrote:

> Andrew, please drop procfs-detect-duplicate-names.patch and apply this
> instead.
> ------------
> [PATCH] proc: detect duplicate names on registration
> 
> From: Zhang Rui <rui.zhang@intel.com>
> 
> Print a warning if PDE is registered with a name which already exists in
> target directory.
> 
> Bug report and a simple fix can be found here:
> http://bugzilla.kernel.org/show_bug.cgi?id=8798
> 
> [\n fixlet and no undescriptive variable usage --adobriyan]
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> ---
> 
>  fs/proc/generic.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c

> @@ -536,6 +537,15 @@ static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp
>  	}
>  
>  	spin_lock(&proc_subdir_lock);
> +
> +	for (tmp = dir->subdir; tmp; tmp = tmp->next)
> +		if (strcmp(tmp->name, dp->name) == 0) {
> +			printk(KERN_WARNING "PDE '%s' already registered\n",
> +				dp->name);
> +			dump_stack();
> +			break;
> +		}
> +

Please just s/PDE/proc_dir_entry/.

---
~Randy
