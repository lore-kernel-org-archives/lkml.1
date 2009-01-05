Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbZAEOgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbZAEOgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZAEOgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:36:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41355 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521AbZAEOgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:36:03 -0500
Date: Mon, 5 Jan 2009 15:33:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6][v5] Define siginfo_from_ancestor_ns()
Message-ID: <20090105143334.GD3313@redhat.com>
References: <20081227204658.GA27197@us.ibm.com> <20081227205222.GB27337@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227205222.GB27337@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Really minor nit, just noticed...

On 12/27, Sukadev Bhattiprolu wrote:
>
> +static inline int siginfo_from_ancestor_ns(struct task_struct *t,
> +                       siginfo_t *info)
> +{
> +	struct pid_namespace *ns;
> +
> +	/*
> +	 * Ensure signal is from user-space before checking pid namespace.
> +	 * (We maybe called from interrupt context and dereferencing
> +	 * pid namespace would be safe).
> +	 */
> +	if (siginfo_from_user(info)) {

I can't parse the comment above, and imho it is confusing and
misleading. We can dereference pid namespace even in interrupt
context.

Also, the comment looks as if "when siginfo_from_user() is false,
it is not safe/possible to derive from_ancestor_ns". This is not
true, in that case we know that from_ancestor_ns must be false.

from_ancestor_ns == T means the signal was sent from the user
space, and it was sent to the task in the sub-namespace, so it
is clear why we check siginfo_from_user().

Oleg.

