Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbYEPCo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbYEPCo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 22:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYEPCov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 22:44:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753687AbYEPCov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 22:44:51 -0400
Date: Thu, 15 May 2008 19:44:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10] Bsdacct: account dying tasks in all relevant
 namespaces
Message-Id: <20080515194438.5b609568.akpm@linux-foundation.org>
In-Reply-To: <482C1A7B.8050601@openvz.org>
References: <482C15FE.7070300@openvz.org>
	<482C1A7B.8050601@openvz.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 15:11:55 +0400 Pavel Emelyanov <xemul@openvz.org> wrote:

> +/**
> + * acct_process - now just a wrapper around do_acct_process

comment seems wrong.

> + * handles process accounting for an exiting task
> + */
> +void acct_process(void)
> +{
> +	struct pid_namespace *ns;
> +
> +	for (ns = task_active_pid_ns(current); ns != NULL; ns = ns->parent)
> +		acct_process_in_ns(ns);
> +}

Is it really safe to walk this list locklessly?
