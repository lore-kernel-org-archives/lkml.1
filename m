Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbYFWXwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbYFWXwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYFWXwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:52:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58542 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYFWXwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:52:01 -0400
Date: Tue, 24 Jun 2008 01:51:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -rt] ide: fix interrupts processing issue with
	preempt-able hardirqs
Message-ID: <20080623235141.GB17297@elte.hu>
References: <20080623234037.GA6793@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623234037.GA6793@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> IDE interrupt handler relies on the fact that, if necessary, hardirqs 
> will re-trigger on ISR exit. With fully preemtable IRQs this seems to 
> be not true, since if hardirq thread is currently running, and the 
> same IRQ raised again, then this IRQ will be simply lost.

actually no, that should not happen - if -rt loses an IRQ then something 
broke in the threaded IRQ code. It's supposed to be a drop-in, 
compatible IRQ flow with no driver changes needed.

( also, please do not Cc: mainline maintainers to RFC -rt patches, let
  the -rt maintainers sort out the need for any patch propagation - once 
  the patches are sufficiently cooked. Thanks. )

	Ingo
