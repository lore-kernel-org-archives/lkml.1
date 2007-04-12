Return-Path: <linux-kernel-owner+w=401wt.eu-S2992448AbXDLKSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992448AbXDLKSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 06:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992438AbXDLKSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 06:18:30 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35770 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992448AbXDLKS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 06:18:28 -0400
Date: Thu, 12 Apr 2007 11:21:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       John Johansen <jjohansen@suse.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 38/41] AppArmor: Module and LSM hooks
Message-ID: <20070412112101.328fd7cd@the-village.bc.nu>
In-Reply-To: <20070412090849.112397000@suse.de>
References: <20070412090809.917795000@suse.de>
	<20070412090849.112397000@suse.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +	/**
> +	 * parent can ptrace child when
> +	 * - parent is unconfined
> +	 * - parent is in complain mode
> +	 * - parent and child are confined by the same profile
> +	 */

Your profiles are name based. That means the same profile in a different
namespace does different things. It would be a very odd case where it
mattered but surely the parent ptrace child rule should also require that
the parent and child are in the same namespace when using apparmor name
based security.

> +static int apparmor_capget(struct task_struct *task,
> +			    kernel_cap_t *effective,
> +			    kernel_cap_t *inheritable,
> +			    kernel_cap_t *permitted)
> +{
> +	return cap_capget(task, effective, inheritable, permitted);
> +}

Pointless function should go away.

> +static int apparmor_sysctl(struct ctl_table *table, int op)
> +{
> +	int error = 0;
> +
> +	if ((op & 002) && !capable(CAP_SYS_ADMIN))
> +		error = aa_reject_syscall(current, GFP_KERNEL,
> +					  "sysctl (write)");
> +
> +	return error;

The usual file permission security override is DAC not ADMIN. What is the
logic of this choice.

> +}
> +
> +static int apparmor_syslog(int type)
> +{
> +	return cap_syslog(type);
> +}

More pointless functions to delete.


