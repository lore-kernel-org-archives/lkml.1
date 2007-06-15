Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbXFOE31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbXFOE31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 00:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbXFOE3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 00:29:20 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:41115 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbXFOE3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 00:29:19 -0400
Date: Fri, 15 Jun 2007 08:28:57 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: w1_therm_read_bin: suspicious usage of flush_signals()
Message-ID: <20070615042856.GA22786@2ka.mipt.ru>
References: <20070614172439.GA2468@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070614172439.GA2468@tv-sign.ru>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Fri, 15 Jun 2007 08:29:04 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 09:24:39PM +0400, Oleg Nesterov (oleg@tv-sign.ru) wrote:
> drivers/w1/slaves/w1_therm.c:w1_therm_read_bin()
> 
> 	while (tm) {
> 		tm = msleep_interruptible(tm);
> 		if (signal_pending(current))
> 			flush_signals(current);
> 	}
> 
> current is user-space task, yes?
> 
> this looks just wrong, could you please explain?

Hi Oleg.

Well, it can be uninterruptible sleep, but why?
It is not allowed to return to userspace until transaction is completed,
so having uninterruptible sleep will result in exactly same lost of
signals.

> Oleg.

-- 
	Evgeniy Polyakov
