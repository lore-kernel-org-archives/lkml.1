Return-Path: <linux-kernel-owner+w=401wt.eu-S1750874AbXCXMoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750874AbXCXMoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 08:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbXCXMoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 08:44:24 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44009 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbXCXMoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 08:44:23 -0400
Date: Sat, 24 Mar 2007 18:21:31 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, winget@google.com,
       rohitseth@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 3/7] containers (V7): Add generic multi-subsystem API to containers
Message-ID: <20070324125131.GA9475@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.485337000@menage.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212085104.485337000@menage.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 12:15:24AM -0800, menage@google.com wrote:
> +static int attach_task(struct container *cont, struct task_struct *tsk)
>  {

[snip]

> +	for_each_subsys(h, ss) {
> +		if (ss->can_attach) {
> +			retval = ss->can_attach(ss, cont, tsk);
> +			if (retval) {
> +				put_task_struct(tsk);

We don't need this put_task_struct(), since our caller
attach_task_by_pid() would do it for us.

> +				return retval;
> +			}
> +		}
>  	}
> -}
> 
> +	/* Locate or allocate a new container_group for this task,
> +	 * based on its final set of containers */
> + 	oldcg = tsk->containers;
> +	newcg = find_container_group(oldcg, cont);
> +	if (!newcg) {
> +		put_task_struct(tsk);

Ditto

> +		return -ENOMEM;
> +	}

-- 
Regards,
vatsa
