Return-Path: <linux-kernel-owner+w=401wt.eu-S1766955AbXDEL5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766955AbXDEL5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 07:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766961AbXDEL5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 07:57:35 -0400
Received: from mail.screens.ru ([213.234.233.54]:37074 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766955AbXDEL5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 07:57:34 -0400
Date: Thu, 5 Apr 2007 15:57:14 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@elte.hu,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 6/8] Make non-singlethreaded workqueues freezeable by default
Message-ID: <20070405115714.GA755@tv-sign.ru>
References: <20070402053457.GA9076@in.ibm.com> <20070402054107.GF12962@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402054107.GF12962@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, Gautham R Shenoy wrote:
>
> +extern struct workqueue_struct *create_freeze_exempted_workqueue(const char *name, int freeze_exempt_events);
> +
> +extern struct workqueue_struct *create_singlethread_workqueue(const char *name);

I bet akpm will say something about 110-column declaration...

> +struct workqueue_struct *create_workqueue(const char *name)
> +{
> +	return __create_workqueue(name, 0, FE_NONE);
> +}
> +EXPORT_SYMBOL_GPL(create_workqueue);
> +
> +struct workqueue_struct *create_freeze_exempted_workqueue(const char *name,
> +							int freeze_exempt_events)
> +{
> +	return __create_workqueue(name, 0, freeze_exempt_events);
> +}
> +EXPORT_SYMBOL_GPL(create_freeze_exempted_workqueue);
> +
> +struct workqueue_struct *create_singlethread_workqueue(const char *name)
> +{
> +	return __create_workqueue(name, 1, FE_ALL);
> +}
> +EXPORT_SYMBOL_GPL(create_singlethread_workqueue);

EXPORT_SYMBOL() has a cost, and these functions are simple wrappers. How about
static inline?

Oleg.

