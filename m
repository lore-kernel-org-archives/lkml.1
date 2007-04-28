Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbXD1GXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbXD1GXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 02:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbXD1GXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 02:23:19 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753520AbXD1GXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 02:23:18 -0400
Date: Fri, 27 Apr 2007 23:22:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ego@in.ibm.com
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] Allow selective freezing of the system for
 different events
Message-Id: <20070427232222.1ea7797d.akpm@linux-foundation.org>
In-Reply-To: <20070428013446.GA20242@in.ibm.com>
References: <200704271737.31192.rjw@sisk.pl>
	<200704271740.17972.rjw@sisk.pl>
	<20070428013446.GA20242@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 07:04:46 +0530 Gautham R Shenoy <ego@in.ibm.com> wrote:

> This patch
> * Provides an interface to selectively freeze the system for different events.
> * Allows tasks to exempt themselves or other tasks from specific freeze
>   events.
> * Allow nesting of freezer calls. For eg:
> 
> 	freeze_processes(EVENT_A);
> 	/* Do something with respect to event A */
> 	.
> 	.
> 	.
> 	freeze_processes(EVENT_B);
> 	/* Do something with respect to event B */
> 	.
> 	.
> 	.
> 	thaw_processes(EVENT_B);
> 	.
> 	.
> 	.
> 	thaw_processes(EVENT_B);
> 
> This type of behaviour would be required when cpu hotplug would start
> using the process freezer, where EVENT_A would be SUSPEND and EVENT_B
> would be HOTPLUG_CPU.
> 
> This patch applies on the top of 2.6.21-rc7-mm2 + Rafael's freezer
> changes from http://lkml.org/lkml/2007/4/27/302.

I think I'll duck this.  We have more than enough kthread/freezer/etc work
queued for 2.6.22.  Let's please for now concentrate on reviewing and
testing the existing changes.  Once that has all landed and settled in,
let's start thinking about the next round.


