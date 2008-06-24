Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYFXAA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYFXAA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYFXAAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:00:18 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:32559 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752341AbYFXAAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:00:17 -0400
Date: Tue, 24 Jun 2008 04:00:16 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -rt] ide: fix interrupts processing issue with
	preempt-able hardirqs
Message-ID: <20080624000016.GA12547@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080623234037.GA6793@polina.dev.rtsoft.ru> <20080623235141.GB17297@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080623235141.GB17297@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 01:51:41AM +0200, Ingo Molnar wrote:
> 
> * Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > IDE interrupt handler relies on the fact that, if necessary, hardirqs 
> > will re-trigger on ISR exit. With fully preemtable IRQs this seems to 
> > be not true, since if hardirq thread is currently running, and the 
> > same IRQ raised again, then this IRQ will be simply lost.
> 
> actually no, that should not happen - if -rt loses an IRQ then something 
> broke in the threaded IRQ code. It's supposed to be a drop-in, 
> compatible IRQ flow with no driver changes needed.

..just as I thought, the bug somewhere deeper... heh.

> ( also, please do not Cc: mainline maintainers to RFC -rt patches, let
>   the -rt maintainers sort out the need for any patch propagation - once 
>   the patches are sufficiently cooked. Thanks. )

Ok, thanks.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
