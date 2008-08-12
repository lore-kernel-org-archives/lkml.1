Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbYHLUr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbYHLUr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbYHLUrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:47:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34699 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbYHLUrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:47:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH 4/5] Container Freezer: Skip frozen cgroups during power management resume
Date: Tue, 12 Aug 2008 22:50:08 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
References: <20080811235323.872291138@us.ibm.com> <20080811235325.485466148@us.ibm.com>
In-Reply-To: <20080811235325.485466148@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808122250.08699.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 of August 2008, Matt Helsley wrote:
> When a system is resumed after a suspend, it will also unfreeze
> frozen cgroups.
> 
> This patchs modifies the resume sequence to skip the tasks which
> are part of a frozen control group.
> 
> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> Acked-by: Serge E. Hallyn <serue@us.ibm.com>
> Tested-by: Matt Helsley <matthltc@us.ibm.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  kernel/power/process.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6.27-rc1-mm1/kernel/power/process.c
> ===================================================================
> --- linux-2.6.27-rc1-mm1.orig/kernel/power/process.c
> +++ linux-2.6.27-rc1-mm1/kernel/power/process.c
> @@ -135,6 +135,9 @@ static void thaw_tasks(bool nosig_only)
>  		if (nosig_only && should_send_signal(p))
>  			continue;
>  
> +		if (cgroup_frozen(p))
> +			continue;
> +
>  		thaw_process(p);
>  	} while_each_thread(g, p);
>  	read_unlock(&tasklist_lock);
> 


