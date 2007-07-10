Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbXGJHws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbXGJHws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbXGJHwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:52:39 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:34334 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbXGJHwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:52:38 -0400
X-Originating-Ip: 72.143.66.27
Date: Tue, 10 Jul 2007 03:50:04 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: schedule_timeout() called with state TASK_RUNNING from fs/select.c
In-Reply-To: <20070708111625.GA180@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0707100348090.9368@localhost.localdomain>
References: <20070708111625.GA180@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007, Oleg Nesterov wrote:

> Robert P. J. Day wrote:
> >
> >  as i understand it, schedule_timeout() should always be called with
> > a current->state of TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE, no?
>
> No.
>
> Yes, it is pointless to call schedule() if it is known that ->state ==
> TASK_RUNNING, but sometimes the task doesn't know its state when it
> calls schedule/schedule_timeout, the state could be changed by
> try_to_wake_up().
>
> See wait_event_timeout() as an example.

fair enough.  i already knew that, technically, it wasn't an error to
call schedule_timeout() with state == TASK_RUNNING.  i was just
following up on something out of love's kernel book, and i got curious
as to whether the above ever happened.  now i know.

rday
--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
