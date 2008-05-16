Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbYEPKdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbYEPKdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 06:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYEPKdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 06:33:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbYEPKdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 06:33:17 -0400
Date: Fri, 16 May 2008 03:33:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10] Bsdacct: account dying tasks in all relevant
 namespaces
Message-Id: <20080516033304.78e58fa2.akpm@linux-foundation.org>
In-Reply-To: <482D5DB8.4030200@openvz.org>
References: <482C15FE.7070300@openvz.org>
	<482C1A7B.8050601@openvz.org>
	<20080515194438.5b609568.akpm@linux-foundation.org>
	<482D5DB8.4030200@openvz.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008 14:11:04 +0400 Pavel Emelyanov <xemul@openvz.org> wrote:

> 
> >> + * handles process accounting for an exiting task
> >> + */
> >> +void acct_process(void)
> >> +{
> >> +	struct pid_namespace *ns;
> >> +
> >> +	for (ns = task_active_pid_ns(current); ns != NULL; ns = ns->parent)
> >> +		acct_process_in_ns(ns);
> >> +}
> > 
> > Is it really safe to walk this list locklessly?
> 
> Well, yes - I wrote it in the comment to the 10th patch:
> 
>  "ns->parent access if safe lockless, since current it still
>   alive and holds its namespace, which in turn holds its parent."

oic.

> Should I also add this as a comment here?

It wouldn't hurt...
