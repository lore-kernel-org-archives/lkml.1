Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbYFWXxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbYFWXxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYFWXw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:52:56 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:32532 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751495AbYFWXwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:52:55 -0400
Date: Tue, 24 Jun 2008 03:52:54 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] ide: fix interrupts processing issue with
	preempt-able hardirqs
Message-ID: <20080623235254.GA10728@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080623234037.GA6793@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080623234037.GA6793@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 03:40:37AM +0400, Anton Vorontsov wrote:
> IDE interrupt handler relies on the fact that, if necessary, hardirqs
> will re-trigger on ISR exit. With fully preemtable IRQs this seems to be
> not true, since if hardirq thread is currently running, and the same IRQ
> raised again, then this IRQ will be simply lost.

Btw, I don't actually understand why interrupt "simply lost", IMO it
should not.. :-/ But this what I'm observing via bunch of printks in
the code flow. Maybe there is not so obvious race, which I can't see.

So, help needed. Either it is a proper fix, or it is a workaround for
another bug somewhere else.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
