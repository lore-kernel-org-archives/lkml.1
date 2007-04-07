Return-Path: <linux-kernel-owner+w=401wt.eu-S965233AbXDGELb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965233AbXDGELb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 00:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965271AbXDGELb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 00:11:31 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42251 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965233AbXDGELa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 00:11:30 -0400
Date: Sat, 7 Apr 2007 09:48:51 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: akpm@linux-foundation.org, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 3/7] Containers (V8): Add generic multi-subsystem API to containers
Message-ID: <20070407041851.GA15007@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070406233221.989528000@menage.corp.google.com> <20070407001324.271959000@menage.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070407001324.271959000@menage.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 04:32:24PM -0700, menage@google.com wrote:
> +static int attach_task(struct container *cont, struct task_struct *tsk)
>  {

[snip]

> +	task_lock(tsk);

You need to check here if task state is PF_EXITING and fail with
-ESRCH if so? Otherwise we risk breaking refcount on
init_container_group.

> +	rcu_assign_pointer(tsk->containers, newcg);
> +	task_unlock(tsk);

-- 
Regards,
vatsa
