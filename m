Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbYLVW2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbYLVW2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYLVW20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 17:28:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42055 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbYLVW20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:28:26 -0500
Date: Mon, 22 Dec 2008 23:26:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: Re: [RFC][PATCH 4/6][v3] Define siginfo_from_ancestor_ns()
Message-ID: <20081222222604.GA1536@redhat.com>
References: <20081221005106.GA4912@us.ibm.com> <20081221005424.GD5025@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081221005424.GD5025@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20, Sukadev Bhattiprolu wrote:
>
> + * TODO:
> + * 	  Making SI_ASYNCIO a kernel signal could make this less hacky.
> + */
> +#ifdef CONFIG_PID_NS
> +static inline int siginfo_from_user(siginfo_t *info)
> +{
> +	if (!is_si_special(info) && SI_FROMUSER(info) &&

OK, if we can trust SI_FROMUSER(), then it is better, i agree.

I was worried about in-kernel usage of .si_code <= 0 ...

> +				info->si_code != SI_ASYNCIO)

but this is horrible, imho.

OK, if we can't change the ABI, then perhaps we can change
kill_pid_info_as_uid() to not send the fatal signals to UNKILLABLE
task? This helper is strange and ugly anyway,


To clarify, I do not blame the patch itself, and I do not suggest
to do this right now.

Oleg.

