Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbXBNP0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbXBNP0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 10:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932340AbXBNP0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 10:26:24 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40825 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbXBNP0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 10:26:24 -0500
Date: Wed, 14 Feb 2007 20:54:58 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu, dipankar@in.ibm.com,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org,
       oleg@tv-sign.ru, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 2/4] Revert changes to workqueue.c
Message-ID: <20070214152458.GA5200@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214144305.GB19789@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214144305.GB19789@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 08:13:05PM +0530, Gautham R Shenoy wrote:
> +	switch (action) {
> +	case CPU_UP_PREPARE:
> +		/* Create a new workqueue thread for it. */
> +		list_for_each_entry(wq, &workqueues, list) {

Its probably safe to take the workqueue (spin) lock here (and other
notifiers as well), before traversing the list.

> +			cwq = per_cpu_ptr(wq->cpu_wq, hotcpu);
> +			if (create_workqueue_thread(cwq, hotcpu)) {
> +				printk("workqueue for %i failed\n", hotcpu);
> +				return NOTIFY_BAD;
> +			}
> +		}
> +		break;

-- 
Regards,
vatsa
