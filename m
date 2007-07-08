Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbXGHLQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbXGHLQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbXGHLQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:16:07 -0400
Received: from mail.screens.ru ([213.234.233.54]:44384 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbXGHLQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:16:06 -0400
Date: Sun, 8 Jul 2007 15:16:25 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: schedule_timeout() called with state TASK_RUNNING from fs/select.c
Message-ID: <20070708111625.GA180@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>
>  as i understand it, schedule_timeout() should always be called with
> a current->state of TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE, no?

No.

Yes, it is pointless to call schedule() if it is known that ->state ==
TASK_RUNNING, but sometimes the task doesn't know its state when it
calls schedule/schedule_timeout, the state could be changed by
try_to_wake_up().

See wait_event_timeout() as an example.

Oleg.

