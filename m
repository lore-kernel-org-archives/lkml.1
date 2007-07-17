Return-Path: <linux-kernel-owner+w=401wt.eu-S1764814AbXGQHCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764814AbXGQHCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764198AbXGQHBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:01:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764101AbXGQHBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:01:46 -0400
Date: Tue, 17 Jul 2007 00:01:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jerry Cooperstein <jerry.cooperstein@charter.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mutex_unlock() in interrupt context
Message-Id: <20070717000138.0d255ed5.akpm@linux-foundation.org>
In-Reply-To: <46981580.5000008@charter.net>
References: <20070713160117.0db9d36d.akpm@linux-foundation.org>
	<0C7297FA1D2D244A9C7F6959C0BF1E5202234496@azsmsx413.amr.corp.intel.com>
	<20070713170147.6129fc3b.akpm@linux-foundation.org>
	<46981580.5000008@charter.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 19:14:56 -0500 Jerry Cooperstein <jerry.cooperstein@charter.net> wrote:

> kernel/mutex.c says about mutex_unlock():
> 
>   * This function must not be used in interrupt context.
> 
> However I have done some simple test cases that show
> it works without complaint.  Now I understand that one
> shouldn't do this for good reasons.  So is this a
> good coding practice rule, but something that
> could appear in sloppy or poorly designed code?
> 

mutex_unlock() must be called by the process which did the mutex_lock(). 
Doing the mutex_unlock() from an interrupt will cause warnings when run
with debugging enabled.  You should run with debugging enabled when doing
any development.  

Also, mutex_unlock() takes a mutex-internal spinlock in a non-irq-safe
fashion - if the timing is right, your mutex_unlock() in IRQ context will
deadlock.

