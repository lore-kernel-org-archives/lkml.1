Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbXDJOow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbXDJOow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030784AbXDJOow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:44:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:42702 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbXDJOot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:44:49 -0400
Date: Tue, 10 Apr 2007 20:22:20 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: akpm@linux-foundation.org, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 3/7] Containers (V8): Add generic multi-subsystem API to containers
Message-ID: <20070410145220.GB3611@in.ibm.com>
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
> +struct container_subsys {
> +	int (*create)(struct container_subsys *ss,
> +		      struct container *cont);
> +	void (*destroy)(struct container_subsys *ss, struct container *cont);
> +	int (*can_attach)(struct container_subsys *ss,
> +			  struct container *cont, struct task_struct *tsk);
> +	void (*attach)(struct container_subsys *ss, struct container *cont,
> +			struct container *old_cont, struct task_struct *tsk);
> +	void (*fork)(struct container_subsys *ss, struct task_struct *task);
> +	void (*exit)(struct container_subsys *ss, struct task_struct *task);
> +	int (*populate)(struct container_subsys *ss,
> +			struct container *cont);
> +	void (*bind)(struct container_subsys *ss, struct container *root);

Is the first argument into all the callbacks, struct container_subsys *ss,
necessary?

> +struct container_subsys cpuset_subsys = {
> +	.name = "cpuset",
> +	.create = cpuset_create,
> +	.destroy  = cpuset_destroy,
> +	.can_attach = cpuset_can_attach,
> +	.attach = cpuset_attach,
> +	.populate = cpuset_populate,
> +	.subsys_id = cpuset_subsys_id,
> +	.early_init = 1,
> +};

We seem to be missing a register call here as well ..

-- 
Regards,
vatsa
