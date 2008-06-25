Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbYFYOMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbYFYOMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYFYOMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:12:45 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:2487 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751130AbYFYOMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:12:44 -0400
Date: Wed, 25 Jun 2008 18:12:42 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH -rt] ide: fix interrupts processing issue with
	preempt-able hardirqs
Message-ID: <20080625141242.GA27389@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080623234037.GA6793@polina.dev.rtsoft.ru> <20080623235141.GB17297@elte.hu> <20080624000016.GA12547@polina.dev.rtsoft.ru> <20080625123431.GA25452@polina.dev.rtsoft.ru> <20080625133257.7677258d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080625133257.7677258d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 01:32:57PM +0100, Alan Cox wrote:
> > The bug, as I see it, in the alim15x3 (ULi M5228) hardware: for some
> > reason it does not hold IRQ line, but rises it for some short period
> > of time (while the drive itself rises and holds it correctly -- I'm
> > seeing it via oscilloscope).
> 
> Are you sure the kernel isn't touching the status register and so
> clearing the IRQ condition at the controller ?

There are lots of places that reads status register, and looking into
the code flow I don't see any problem with the code.

But to be sure I inserted a printk into INB, and I don't see any status
reads when/after the drive asserts its IRQ.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
