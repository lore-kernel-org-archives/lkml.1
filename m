Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbXGAQsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbXGAQsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 12:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757396AbXGAQry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 12:47:54 -0400
Received: from mail.screens.ru ([213.234.233.54]:55240 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757231AbXGAQrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 12:47:52 -0400
Date: Sun, 1 Jul 2007 20:47:54 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Jarek Poplawski <jarkao2@o2.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] tty_io.c: don't use flush_scheduled_work()
Message-ID: <20070701164754.GA172@tv-sign.ru>
References: <20070701153749.GA111@tv-sign.ru> <20070701172222.22812744@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070701172222.22812744@the-village.bc.nu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01, Alan Cox wrote:
>
> On Sun, 1 Jul 2007 19:37:49 +0400
> Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > I don't know how to test this patch, the ack/nack from maintainer is wanted.
> > 
> > flush_scheduled_work() is evil and should be avoided. Change tty_set_ldisc()
> > and release_dev() to use cancel_delayed_work_sync/cancel_work_sync.
> > 
> > I am not sure we really need to call do_tty_hangup() when cancel_work_sync()
> > returns true, but this matches the current behaviour.
> > 
> > Also, some whitespace fixes.
> > 
> > Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> I'm sorry but the tty layer hangup code is not in a shape to do these
> changes. Please leave it alone until the revoke() code in 2.6.2x-mm is
> ready for mainstream then we will switch to that and all the mess goes
> away.
> 
> Its just *too* fragile to touch otherwise, and we've had repeated
> breakages from tiny changes in this area.

OK, thanks, please ignore this patch then. I did it just as example how
to avoid flush_workqueue() when we can't just kill the work.

Oleg.

