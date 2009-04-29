Return-Path: <linux-kernel-owner+w=401wt.eu-S1760726AbZD2NPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726AbZD2NPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759510AbZD2NJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:09:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52385 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759443AbZD2NJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:09:17 -0400
Date: Wed, 29 Apr 2009 15:05:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SELinux: Remove excessive interrupt disablement
Message-ID: <20090429130522.GA29151@redhat.com>
References: <20090429124719.19278.51952.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429124719.19278.51952.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, David Howells wrote:
>
> @@ -2410,9 +2409,9 @@ static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
>  	 * wait permission to the new task SID. */
>  	read_lock_irq(&tasklist_lock);

_irq is not needed, just read_lock(&tasklist_lock) should be fine.

>  	psig = current->parent->sighand;
> -	spin_lock_irqsave(&psig->siglock, flags);
> +	spin_lock(&psig->siglock);

I think we don't need ->siglock at all.

>  	wake_up_interruptible(&current->parent->signal->wait_chldexit);

off-topic wrt this patch, but I believe we need

	__wake_up_parent(curremt, current->real_parent);

Oleg.

