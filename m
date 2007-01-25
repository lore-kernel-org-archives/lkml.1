Return-Path: <linux-kernel-owner+w=401wt.eu-S1030324AbXAYQe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030324AbXAYQe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030316AbXAYQe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:34:59 -0500
Received: from mail.screens.ru ([213.234.233.54]:43261 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030324AbXAYQe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:34:58 -0500
Date: Thu, 25 Jan 2007 19:34:07 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Sebastien Dugue <sebastien.dugue@bull.net>,
       Laurent Vivier <laurent.vivier@bull.net>
Cc: Zach Brown <zach.brown@oracle.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ulrich Drepper <drepper@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: + aio-completion-signal-notification.patch added to -mm tree
Message-ID: <20070125163407.GA238@tv-sign.ru>
References: <20070125162141.GA226@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070125162141.GA226@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25, Oleg Nesterov wrote:
>
> Sebastien Dugue wrote:
> >
> > +	if (iocb->ki_notify.notify != SIGEV_NONE) {
> > +		ret = aio_send_signal(&iocb->ki_notify);
> > +
> > +		/* If signal generation failed, release the sigqueue */
> > +		if (ret)
> > +			sigqueue_free(iocb->ki_notify.sigq);
> 
> We should not use sigqueue_free() here. It takes current->sighand->siglock
> to remove sigqueue from "struct sigpending". But current is just a "random"
> process here.

... and it is possible that current->sighand == NULL.

Oleg.

