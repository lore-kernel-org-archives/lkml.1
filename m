Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbXCXE6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbXCXE6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 00:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbXCXE6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 00:58:40 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33395 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbXCXE62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 00:58:28 -0400
Date: Sat, 24 Mar 2007 10:35:37 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, winget@google.com,
       rohitseth@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070324050537.GA27040@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085105.170265000@menage.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212085105.170265000@menage.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 12:15:28AM -0800, menage@google.com wrote:
> +/*
> + * Rules: you can only create a container if
> + *     1. you are capable(CAP_SYS_ADMIN)
> + *     2. the target container is a descendant of your own container
> + */
> +static int ns_create(struct container_subsys *ss, struct container *cont)
> +{
> +	struct nscont *ns;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;

Does this check break existing namespace semantics in a subtle way?
It now requires that unshare() of namespaces by any task requires
CAP_SYS_ADMIN capabilities.

clone(.., CLONE_NEWUTS, ..)->copy_namespaces()->ns_container_clone()->
	->container_clone()-> .. -> container_create() -> ns_create()

Earlier, one could unshare his uts namespace w/o CAP_SYS_ADMIN
capabilities. Now it is required. Is that fine? Don't know.

I feel we can avoid this check totally and let the directory permissions
take care of these checks.

Serge, what do you think?

-- 
Regards,
vatsa
