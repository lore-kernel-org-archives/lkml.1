Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbXE3HSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbXE3HSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 03:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbXE3HRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 03:17:55 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbXE3HRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 03:17:54 -0400
Date: Wed, 30 May 2007 00:16:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: menage@google.com
Cc: dev@sw.ru, xemul@sw.ru, serue@us.ibm.com, vatsa@in.ibm.com,
       ebiederm@xmission.com, haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com,
       balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 02/10] Containers(V10): Example CPU accounting subsystem
Message-Id: <20070530001600.1d44f5b7.akpm@linux-foundation.org>
In-Reply-To: <20070529132142.238927000@menage.corp.google.com>
References: <20070529130104.461765000@menage.corp.google.com>
	<20070529132142.238927000@menage.corp.google.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 06:01:06 -0700 menage@google.com wrote:

> This example demonstrates how to use the generic container subsystem
> for a simple resource tracker that counts, for the processes in a
> container, the total CPU time used and the %CPU used in the last
> complete 10 second interval.
> 
> ...
>
> --- /dev/null
> +++ container-2.6.22-rc2-mm1/kernel/cpu_acct.c
> @@ -0,0 +1,185 @@
> +/*
> + * kernel/cpu_acct.c - CPU accounting container subsystem
> + *
> + * Copyright (C) Google Inc, 2006
> + *
> + * Developed by Paul Menage (menage@google.com) and Balbir Singh
> + * (balbir@in.ibm.com)
> + *
> + */
>
> ...
>
> +static u64 cpuusage_read(struct container *cont,
> +			 struct cftype *cft)
> +{
> +	struct cpuacct *ca = container_ca(cont);
> +	u64 time;
> +
> +	spin_lock_irq(&ca->lock);
> +	cpuusage_update(ca);
> +	time = cputime64_to_jiffies64(ca->time);
> +	spin_unlock_irq(&ca->lock);
> +
> +	/* Convert 64-bit jiffies to seconds */
> +	time *= 1000;
> +	do_div(time, HZ);

hm, we have jiffies_to_lotsofthings, but we don't appear to have a
jiffies_to_seconds.  How odd.


