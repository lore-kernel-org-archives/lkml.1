Return-Path: <linux-kernel-owner+w=401wt.eu-S1030240AbXAYPpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030240AbXAYPpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030243AbXAYPpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:45:06 -0500
Received: from mail.screens.ru ([213.234.233.54]:56473 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030240AbXAYPpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:45:04 -0500
Date: Thu, 25 Jan 2007 18:43:24 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: sebastien.dugue@bull.net
Cc: Zach Brown <zach.brown@oracle.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ulrich Drepper <drepper@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: + make-good_sigevent-non-static.patch added to -mm tree
Message-ID: <20070125154324.GA183@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sébastien Dugué wrote:
>
> +struct task_struct *good_sigevent(sigevent_t *event)
> +{
> +	struct task_struct *task = current->group_leader;
> +
> +	if ((event->sigev_notify & SIGEV_THREAD_ID) == SIGEV_THREAD_ID) {
> +		task = find_task_by_pid(event->sigev_notify_thread_id);
> +
> +		if (!task || task->tgid != current->tgid)
> +			return NULL;
> +	} else if (event->sigev_notify == SIGEV_SIGNAL) {

No, no, we can't use "else" here,

> +		if (event->sigev_signo <= 0 || event->sigev_signo > SIGRTMAX)

because we skip the check above in SIGEV_THREAD_ID case.

This way any user can crash the kernel with a minimal effort.

Oleg.

