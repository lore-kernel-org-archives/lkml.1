Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013Ab0AEAJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab0AEAJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463Ab0AEAJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:09:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34697 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753374Ab0AEAJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:09:19 -0500
Date: Tue, 5 Jan 2010 00:12:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Breuer <mbreuer@majjas.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tty_io.c  - disassociate_ctty attempted to write to tty = NULL
 question/problem?
Message-ID: <20100105001205.7e8f131b@lxorguk.ukuu.org.uk>
In-Reply-To: <4B42733D.6050704@majjas.com>
References: <4B42733D.6050704@majjas.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> do_exit -> disassocate_ctty(1) (for tty1).
> disassociate->vhangup->do_tty_hangup
> 
> In do_tty_hangup, p->signal->tty is set to NULL, where p==current.

Perfectly reasonable so far - the current process gave up having a
controlling tty.

> On return, the aforementioned error message is generated.

>From where - the backtrace on the write to NULL tty is the important bit
here. User space interfaces cache tty in filp->private_data so its not
going to be coming from there unless there was a memory scribble which
would imply a refcounting bug - and I'd expect people to hit that
reliably.

Some kernel stuff does take a peek at p->signal->tty for direct printk
type stuff and that sounds more likely - the backtraceon the write to
NULL tty is going to provide the needed info.

Alan
