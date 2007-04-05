Return-Path: <linux-kernel-owner+w=401wt.eu-S965927AbXDEJxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965927AbXDEJxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 05:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbXDEJxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 05:53:10 -0400
Received: from mail.screens.ru ([213.234.233.54]:43467 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbXDEJxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 05:53:09 -0400
Date: Thu, 5 Apr 2007 13:53:01 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@elte.hu,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 2/8] Make process freezer reentrant
Message-ID: <20070405095301.GB609@tv-sign.ru>
References: <20070402053457.GA9076@in.ibm.com> <20070402053741.GB12962@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402053741.GB12962@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, Gautham R Shenoy wrote:
>
>  int freeze_processes(unsigned long freeze_event)
>  {
>  	unsigned int nr_unfrozen;
> -
> +	int ret = 0;
> +	mutex_lock(&freezer_mutex);
> +	if (system_freeze_event_mask & freeze_event)
> +		goto done;

I am not sure this is correct. Suppose that system_freeze_event_mask == FE_SUSPEND,
now freeze_processes(FE_ALL) returns success. Shouldn't we return an error?

Oleg.

