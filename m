Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbXFNRYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbXFNRYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbXFNRYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:24:44 -0400
Received: from mail.screens.ru ([213.234.233.54]:37454 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbXFNRYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:24:44 -0400
Date: Thu, 14 Jun 2007 21:24:39 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: w1_therm_read_bin: suspicious usage of flush_signals()
Message-ID: <20070614172439.GA2468@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/w1/slaves/w1_therm.c:w1_therm_read_bin()

	while (tm) {
		tm = msleep_interruptible(tm);
		if (signal_pending(current))
			flush_signals(current);
	}

current is user-space task, yes?

this looks just wrong, could you please explain?

Oleg.

