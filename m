Return-Path: <linux-kernel-owner+w=401wt.eu-S1765006AbZAQWPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765006AbZAQWPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 17:15:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758930AbZAQWO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 17:14:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36717 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758636AbZAQWO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 17:14:56 -0500
Date: Sat, 17 Jan 2009 23:12:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7][v7] Protect cinit from unblocked SIG_DFL signals
Message-ID: <20090117221242.GA3962@redhat.com>
References: <20090117202638.GA11825@us.ibm.com> <20090117203621.GE11825@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117203621.GE11825@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17, Sukadev Bhattiprolu wrote:
>
> @@ -1331,7 +1341,7 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
>  		goto ret;
>
>  	ret = 1; /* the signal is ignored */
> -	if (!prepare_signal(sig, t))
> +	if (!prepare_signal(sig, t, 1))

Hmm, just noticed. This looks wrong, it should be prepare_signal(sig, t, 0),
no?

For example, /sbin/init can create the posix timer with sigev_signo = SIGKILL
and it won't be killed before this patch.

This also looks wrong from the masquerading pov.


Otherwise, the patches 1-6 are imho fine.

Oleg.

