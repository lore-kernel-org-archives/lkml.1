Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbYK0BWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbYK0BWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 20:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYK0BV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 20:21:57 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:44334 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbYK0BV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 20:21:57 -0500
Date: Thu, 27 Nov 2008 02:01:01 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       xemul@openvz.org
Subject: Re: [RFC][PATCH 3/5] Determine if sender is from ancestor ns
Message-ID: <20081127010101.GA13545@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, oleg@redhat.com,
	ebiederm@xmission.com, roland@redhat.com, containers@lists.osdl.org,
	linux-kernel@vger.kernel.org, xemul@openvz.org
References: <20081126034242.GA23120@us.ibm.com> <20081126034611.GC23238@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081126034611.GC23238@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 07:46:11PM -0800, Sukadev Bhattiprolu wrote:
> +#ifdef CONFIG_PID_NS
> +#define SIG_FROM_USER  INT_MIN         /* MSB */

Is it really a wise idea to mix this into the signal number? Also this
definition looks odd. If you want the highest bit, you should mention
this explicitely with 1U<<31.

If I see this correctly this information is already covered in si_code
with SI_USER and SI_TKILL. SI_KERNEL is used for explicit kernel
generated signals.

> +static inline int siginfo_from_ancestor_ns(struct task_struct *t,
> +			siginfo_t *info)
> +{
> +	if (!is_si_special(info) && (info->si_signo & SIG_FROM_USER)) {
> +		/* if t can't see us we are from parent ns */

What?

>  static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  			int group)
>  {
>  	struct sigpending *pending;
>  	struct sigqueue *q;
> +	int from_ancestor_ns;
>  
>  	trace_sched_signal_send(sig, t);
>  
> +	from_ancestor_ns = siginfo_from_ancestor_ns(t, info);
> +

This is not used at all here?

Bastian

-- 
Those who hate and fight must stop themselves -- otherwise it is not stopped.
		-- Spock, "Day of the Dove", stardate unknown
