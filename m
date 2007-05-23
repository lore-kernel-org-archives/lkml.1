Return-Path: <linux-kernel-owner+w=401wt.eu-S935692AbXEWRPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935692AbXEWRPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759019AbXEWRPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:15:01 -0400
Received: from mail.screens.ru ([213.234.233.54]:56432 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758459AbXEWRPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:15:00 -0400
Date: Wed, 23 May 2007 20:21:25 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc2-mm1
Message-ID: <20070523162125.GA321@tv-sign.ru>
References: <20070523085424.2aa27c57.akpm@linux-foundation.org> <Pine.LNX.4.44L0.0705231249570.3673-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0705231249570.3673-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23, Alan Stern wrote:
>
> Okay, it's clear that the two threads are in deadlock.  It's not clear 
> how the deadlock arose to begin with -- apparently there was a remote 
> wakeup request for a root hub at the same time as a device below that 
> root hub was disconnected, which doesn't make much sense.

Please note that this flush_workqueue() was not safe anyway. We are freezing
tasks, and ksuspend_usb_wq is freezeable. So, it could be frozen before
"khubd" task, and we have another deadlock.

> Anyway, this looks like a good place to use cancel_work_sync().  The

Could you use cancel_rearming_delayed_work() ? (It should be renamed to
cancel_delayed_work_sync()).

Oleg.

