Return-Path: <linux-kernel-owner+w=401wt.eu-S932562AbXBNUWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbXBNUWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932563AbXBNUWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:22:32 -0500
Received: from mail.screens.ru ([213.234.233.54]:54470 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562AbXBNUWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:22:31 -0500
Date: Wed, 14 Feb 2007 23:22:09 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 1/4] freezer-cpu-hotplug core
Message-ID: <20070214202209.GC301@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214144229.GA19789@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Gautham R Shenoy wrote:
>
> o Splits CPU_DEAD into two events namely
>   - CPU_DEAD: which will be handled while the processes are still
>               frozen.
> 
>   - CPU_DEAD_KILL_THREADS: To be handled after we thaw_processes.


Imho, this is not right. This change the meaning of CPU_DEAD, and so
we should fix all users of CPU_DEAD as well.

How about

	CPU_DEAD_WHATEVER
		the processes are still frozen

	CPU_DEAD
		after we thaw_processes

This way we can add processing of the new CPU_DEAD_WHATEVER event where
it may help. We don't need to change (for example) workqueue.c with this
patch, we can do it in a separate patch.


CPU_UP_PREPARE is called after freeze_processes()... Probably this works,
but imho this is no good. Suppose for a moment that khelper will be frozen
(yes, yes it can't be), then we can't do kthread_create().

Oleg.

