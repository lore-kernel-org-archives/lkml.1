Return-Path: <linux-kernel-owner+w=401wt.eu-S1030781AbXDKExv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030781AbXDKExv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 00:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030803AbXDKExv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 00:53:51 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58765 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030781AbXDKExu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 00:53:50 -0400
Date: Wed, 11 Apr 2007 10:31:21 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: akpm@linux-foundation.org, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 3/7] Containers (V8): Add generic multi-subsystem API to containers
Message-ID: <20070411050121.GB15786@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070406233221.989528000@menage.corp.google.com> <20070407001324.271959000@menage.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070407001324.271959000@menage.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Sorry abt piece meal reviews, I am sending comments as and when I spot
something ]

On Fri, Apr 06, 2007 at 04:32:24PM -0700, menage@google.com wrote:
> -void container_exit(struct task_struct *tsk)
> +void container_exit(struct task_struct *tsk, int run_callbacks)
>  {

[snip]

> +	/* Reassign the task to the init_container_group. */
>  	task_lock(tsk);

[snip]

> +	if (tsk->containers != &init_container_group) {

Is this check needed? If we have the check, then:

> +	task_unlock(tsk);
> +	if (cg)
> +		put_container_group(cg);

init_container_group refcount is leaky (fork increments it, but exit
doesnt). Not a big prob perhaps, but ..would be nice to avoid?

-- 
Regards,
vatsa
