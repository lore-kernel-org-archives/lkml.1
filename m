Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbZEBTIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbZEBTIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 15:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbZEBTIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 15:08:09 -0400
Received: from www.tglx.de ([62.245.132.106]:33806 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbZEBTIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 15:08:07 -0400
Message-Id: <20090502190500.513452861@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 02 May 2009 19:06:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 0/3] move calc_load to softirq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

calc_load() calculates the load average, which is a rough estimate at
best. Right now calc_load() is called from do_timer() under the xtime
lock write locked and with interrupts disabled. Dimitri Sivanich
noticed 55us xtime lock hold times on a 64 cpu system. He suggested to
split calc_load() out of do_timer() and move it out of the xtime
locked section of each caller of do_timer():
http://lkml.org/lkml/2009/4/10/318

The following patch series moves the load average calculation to the
timer softirq and removes the xtime lock dependency in the generic
code. This reduces also the interrupt off section of the timer
interrupt.

Thanks,

	tglx



