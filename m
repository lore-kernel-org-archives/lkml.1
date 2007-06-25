Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbXFYP1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbXFYP1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 11:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbXFYP1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 11:27:01 -0400
Received: from mail.screens.ru ([213.234.233.54]:48469 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbXFYP1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 11:27:00 -0400
Date: Mon, 25 Jun 2007 19:27:36 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pavel Machek <pavel@ucw.cz>, Uli Luckas <u.luckas@road.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] PM: Prevent frozen user mode helpers from failing the freezing of tasks
Message-ID: <20070625152736.GB160@tv-sign.ru>
References: <20070625104332.GA147@tv-sign.ru> <200706251703.42979.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706251703.42979.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Rafael J. Wysocki wrote:
>
> On Monday, 25 June 2007 12:43, Oleg Nesterov wrote:
> 
> > Second, call_usermodehelper's path should first increment the counter, and only
> > then check usermodehelper_disabled,
> 
> It does this already.

Ah, sorry, I looked at this patch without seeing the underlying code.

BTW, isn't it better to rename new_helper/helper_finished to
helper_lock/helper_unlock ?

> If I understand that correctly, it should suffice to place smp_mb() after
> usermodehelper_disabled = 1; in usermodehelper_pm_callback() and another
> smp_mb() after atomic_inc(&running_helpers); in new_helper().
> 
> Is that correct?

Afaics, yes.

Oleg.

