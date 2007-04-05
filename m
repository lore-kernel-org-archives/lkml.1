Return-Path: <linux-kernel-owner+w=401wt.eu-S2992486AbXDEMIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992486AbXDEMIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 08:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992572AbXDEMIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 08:08:11 -0400
Received: from mail.screens.ru ([213.234.233.54]:35485 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992486AbXDEMIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 08:08:09 -0400
Date: Thu, 5 Apr 2007 16:08:02 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@elte.hu,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 5/8] __cpu_up: use singlethreaded workqueue
Message-ID: <20070405120802.GB755@tv-sign.ru>
References: <20070402053457.GA9076@in.ibm.com> <20070402054017.GE12962@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402054017.GE12962@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, Gautham R Shenoy wrote:
>
> Currently i386 and x86_64 __cpu_up uses the services of the kevents
> workqueue to bring the cpu up. Change this and use kthread workqueue
> instead which is single_threaded and won't be frozen during
> CPU_HOTPLUG.
>
> [...snip...]
>
> +void kthreadwq_queue_work(struct work_struct *work)
> +{
> +	queue_work(helper_wq, work);
> +}
> +
> +int kthreadwq_up()
> +{
> +	return (helper_wq != NULL);
> +}

Off-topic question: can't kernel/kmod.c use this workqueue too instead
of its own khelper_wq?

Oleg.

