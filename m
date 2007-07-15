Return-Path: <linux-kernel-owner+w=401wt.eu-S1762041AbXGOPhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762041AbXGOPhs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 11:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758635AbXGOPhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 11:37:41 -0400
Received: from mail.screens.ru ([213.234.233.54]:36635 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758711AbXGOPhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 11:37:41 -0400
Date: Sun, 15 Jul 2007 19:39:14 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Q: a bogus task_running() check in try_to_wake_up() ?
Message-ID: <20070715153914.GA441@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

try_to_wake_up:
	
	if (p->se.on_rq)
		goto out_running;

	...

	if (unlikely(task_running(rq, p)))
		goto out_activate;

How it possible that rq->curr has on_rq == 0 ?

AFAICS, this can only happen if this task is rq->idle. But idle threads
should not sleep, we have a special "scheduling from the idle thread!"
check in schedule().

Thanks in advance,

Oleg.

