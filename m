Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbXGAQQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbXGAQQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 12:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbXGAQQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 12:16:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51654 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753900AbXGAQQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 12:16:47 -0400
Date: Sun, 1 Jul 2007 17:22:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Jarek Poplawski <jarkao2@o2.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] tty_io.c: don't use flush_scheduled_work()
Message-ID: <20070701172222.22812744@the-village.bc.nu>
In-Reply-To: <20070701153749.GA111@tv-sign.ru>
References: <20070701153749.GA111@tv-sign.ru>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jul 2007 19:37:49 +0400
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> I don't know how to test this patch, the ack/nack from maintainer is wanted.
> 
> flush_scheduled_work() is evil and should be avoided. Change tty_set_ldisc()
> and release_dev() to use cancel_delayed_work_sync/cancel_work_sync.
> 
> I am not sure we really need to call do_tty_hangup() when cancel_work_sync()
> returns true, but this matches the current behaviour.
> 
> Also, some whitespace fixes.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

I'm sorry but the tty layer hangup code is not in a shape to do these
changes. Please leave it alone until the revoke() code in 2.6.2x-mm is
ready for mainstream then we will switch to that and all the mess goes
away.

Its just *too* fragile to touch otherwise, and we've had repeated
breakages from tiny changes in this area.

Alan
