Return-Path: <linux-kernel-owner+w=401wt.eu-S1763959AbXGFU0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763959AbXGFU0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 16:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762127AbXGFU0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 16:26:42 -0400
Received: from mail.screens.ru ([213.234.233.54]:33350 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761037AbXGFU0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 16:26:42 -0400
Date: Sat, 7 Jul 2007 00:26:30 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH -mm] Freezer: Handle uninterruptible tasks
Message-ID: <20070706202629.GA158@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>
> This patch makes the freezer skip uninterruptible user space tasks (ie. such
> that have an mm of their own) when counting the tasks to be frozen.  As a
> result, these tasks have the TIF_FREEZE and TIF_SIGPENDING flags set, but the
> freezer doesn't wait for them to enter the refrigerator.  Nevertheless, they
> will enter the refrigerator as soon as they change their state.

A small correction: they will enter the refrigerator on return to user-space.
Actually, TASK_INTERRUPTIBLE doesn't mean the task actually sleeps. It could
be running or preempted... I am a bit worried :)

> +static int freezer_should_skip(struct task_struct *p)
> +{
> +       return (has_mm(p) && (p->state | TASK_UNINTERRUPTIBLE));
                                        ^^^
I guess you meant "&", not "|".

Oleg.

