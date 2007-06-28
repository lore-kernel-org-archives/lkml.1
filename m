Return-Path: <linux-kernel-owner+w=401wt.eu-S1763864AbXF1SKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763864AbXF1SKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764864AbXF1SK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:10:29 -0400
Received: from mail.screens.ru ([213.234.233.54]:37885 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764777AbXF1SK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:10:28 -0400
Date: Thu, 28 Jun 2007 22:10:44 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Thomas Sattler <tsattler@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.22-rc6 spurious hangs
Message-ID: <20070628181044.GA613@tv-sign.ru>
References: <4683BF16.40905@gmx.de> <20070628144741.GA437@tv-sign.ru> <4683CC89.80406@gmx.de> <20070628150826.GA487@tv-sign.ru> <4683F145.2060705@gmx.de> <4683F48F.9010603@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4683F48F.9010603@gmx.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28, Thomas Sattler wrote:
>
> Here is the logfile.

> Jun 28 18:26:03 pearl ERR!! events/0 flush hang: f573759c f573759c 5782 5782 0 1
> Jun 28 18:26:03 pearl CURR: 5557 5557 dvbd 0 129024
> Jun 28 18:26:03 pearl wq_barrier_func+0x0/0xd
> Jun 28 18:26:03 pearl cache_reap+0x0/0xe3
> Jun 28 18:26:03 pearl ----
> Jun 28 18:26:03 pearl cinergyt2_query_rc+0x0/0x2e9 [cinergyT2]
> ...
> Jun 28 19:23:03 pearl ERR!! events/0 flush hang: f573759c f573759c 5782 5782 1 1
> Jun 28 19:23:03 pearl CURR: 5557 5557 dvbd 0 129138
> Jun 28 19:23:03 pearl wq_barrier_func+0x0/0xd
> Jun 28 19:23:03 pearl cache_reap+0x0/0xe3
> Jun 28 19:23:03 pearl console_callback+0x0/0xca
> Jun 28 19:23:03 pearl flush_to_ldisc+0x0/0xf7
> Jun 28 19:23:03 pearl rekey_seq_generator+0x0/0x4e
> Jun 28 19:23:03 pearl ----
> Jun 28 19:23:03 pearl cinergyt2_query_rc+0x0/0x2e9 [cinergyT2]

cinergyt2_query_rc() hangs. I'll try to look tomorrov, but I know nothing
about drivers/media/dvb/.

This log is strange, flush_work() should report every 30 seconds, but it
looks like wait_for_completion_timeout(HZ * 30) returns a lot earlier.

Could you also show the result of sysrq-T ?

Thanks!

Oleg.

