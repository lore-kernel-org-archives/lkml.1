Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbYGVKUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbYGVKUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYGVKUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:20:18 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49814 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbYGVKUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:20:17 -0400
Date: Tue, 22 Jul 2008 14:23:54 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: + workqueue-proper-error-unwinding-in-cpu-hotplug-error-path.patch added to -mm tree
Message-ID: <20080722102354.GA1068@tv-sign.ru>
References: <200807220826.m6M8Q4I6018588@imap1.linux-foundation.org> <20080722084526.GA165@tv-sign.ru> <20080722085938.GA5857@localhost.localdomain> <20080722091636.GA241@tv-sign.ru> <20080722095539.GA6188@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722095539.GA6188@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Akinobu Mita wrote:
>
> On Tue, Jul 22, 2008 at 01:16:36PM +0400, Oleg Nesterov wrote:
> 
> > Can't we simplify the fix? I don't like the fact that the CPU_UP_CANCELED
> > logic is duplicated.
> > 
> > What do you think about the patch below?
> 
> Yes, it is no duplication. But the goto usage in this patch looks bit
> tricky to me.

Well, the kernel is full of "goto again" / "goto retry". Not that I
claim this patch improves the readability ;)

But the duplication is really bad, imho.

> Maybe it is better to factor out the list_for_each() block.

Not sure I understand... do you mean add another function which
starts with list_for_each_entry ? This is not necessary, instead
of goto we can just do

		workqueue_cpu_callback(CPU_UP_CANCELED);
		return NOTIFY_BAD;

, in that case the patch will be one-liner.

Akinobu, Andrew, I'd suggest to drop

	workqueue-proper-error-unwinding-in-cpu-hotplug-error-path.patch

, I'll send the new patch. If nothing else, it is simpler.

Oleg.

