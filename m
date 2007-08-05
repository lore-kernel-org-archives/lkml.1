Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbXHEVJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbXHEVJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 17:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbXHEVJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 17:09:04 -0400
Received: from mail.screens.ru ([213.234.233.54]:58943 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbXHEVJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 17:09:03 -0400
Date: Mon, 6 Aug 2007 01:09:21 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] wait_task_zombie: remove unneeded child->signal check
Message-ID: <20070805210921.GA270@tv-sign.ru>
References: <20070805150041.GA2016@tv-sign.ru> <20070805205144.314B04D04C4@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070805205144.314B04D04C4@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05, Roland McGrath wrote:
>
> > A zombie must have a valid ->signal, we are going to release it and
> > __exit_signal() starts with BUG_ON(!sig).
> 
> Yes, this is safe because it's after the EXIT_DEAD check under tasklist_lock.

Yes thanks, the changelog could be better.

We "own" this child (it was us sho set EXIT_DEAD), nobody can release it
including the child itself (it already passed exit_notify()). We could even
drop tasklist, but we need ->parent->sighand->siglock.

Oleg.

