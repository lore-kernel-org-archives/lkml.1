Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbZGWP7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbZGWP7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 11:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZGWP7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 11:59:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48223 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbZGWP7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 11:59:37 -0400
Date: Thu, 23 Jul 2009 17:56:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: mmotm-0716 - selinux_bprm_commited_creds patch missing..
Message-ID: <20090723155626.GA5466@redhat.com>
References: <13397.1248357159@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13397.1248357159@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23, Valdis.Kletnieks@vt.edu wrote:
>
> Andrew - mmotm-0716 dies at boot because it's missing this patch from Oleg
> for a problem originally spotted in -0630/0702:
>
>
> --- WAIT/security/selinux/hooks.c~SEL_WAKE_PARENT	2009-06-16 17:01:42.000000000 +0200
> +++ WAIT/security/selinux/hooks.c	2009-07-03 11:15:08.000000000 +0200
> @@ -2404,7 +2404,7 @@ static void selinux_bprm_committed_creds
>  	/* Wake up the parent if it is waiting so that it can recheck
>  	 * wait permission to the new task SID. */
>  	read_lock(&tasklist_lock);
> -	wake_up_interruptible(&current->real_parent->signal->wait_chldexit);
> +	__wake_up_parent(current, current->real_parent);
>  	read_unlock(&tasklist_lock);

Thanks Valdis! but it is already (since Jul 18) in -mm,
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch

Oleg.

