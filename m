Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbYKDRBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbYKDRBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbYKDRBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:01:04 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:40706 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbYKDRBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:01:03 -0500
Date: Tue, 4 Nov 2008 10:55:40 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com, sgrubb@redhat.com,
       morgan@kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH -v2 4/4] AUDIT: emit new record type showing all capset
	information
Message-ID: <20081104165540.GA25093@us.ibm.com>
References: <20081103201742.12059.36030.stgit@paris.rdu.redhat.com> <20081103201759.12059.44897.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103201759.12059.44897.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 33e51e7..3d7fc70 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -7,6 +7,7 @@
>   * 30 May 2002:	Cleanup, Robert M. Love <rml@tech9.net>
>   */
> 
> +#include <linux/audit.h>
>  #include <linux/capability.h>
>  #include <linux/mm.h>
>  #include <linux/module.h>
> @@ -457,6 +458,8 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
>  		i++;
>  	}
> 
> +	audit_log_capset(pid, &effective, &inheritable, &permitted);

Shouldn't sys_capset() fail if audit_log_capset() returns -ENOMEM?

> +
>  	if (pid && (pid != task_pid_vnr(current)))
>  		ret = do_sys_capset_other_tasks(pid, &effective, &inheritable,
>  						&permitted);
