Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYIINP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYIINP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 09:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbYIINPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 09:15:15 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:46865 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbYIINPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:15:14 -0400
Message-ID: <48C676E0.1080600@skyrush.com>
Date: Tue, 09 Sep 2008 07:15:12 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: Fix loss of echoed characters (2nd follow-on PATCH
 attached)
References: <200807252257.m6PMvieO003213@imap1.linux-foundation.org>	<48AC3A16.4080209@skyrush.com>	<48B3F9F7.2050503@skyrush.com>	<48C54EC2.4060901@skyrush.com>	<20080908173250.2452c5b8.akpm@linux-foundation.org>	<48C67374.1000108@skyrush.com> <20080909141210.4fd546a1@lxorguk.ukuu.org.uk>
In-Reply-To: <20080909141210.4fd546a1@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> If you have the column handling isolated and locked that is a big step
> towards exterminating the BKL in the n_tty code. It also illustrates why
> locking people always say "lock data not code".

Well, it's isolated, but still locked with the BKL, which would be great
to get rid of.  A few questions for you, since you've worked with this
code (and kernel locking stuff) a lot longer than I:

1) Now that column state is confined to the process_out/echo funcs in
n_tty, would using tty_write_lock() (the defined atomic write lock
mutex) be a good replacement for lock_kernel(), even though interruptible?

2) To protect echo buffer operations, I would lean toward using a
separate echo lock mutex so it does not lock against non-echo-buffer
output.  Would nesting this with #1 be advisable?  Should it be
interruptable?

3) tty_write() mentions refers to ldisc use of the BKL.  If we change
this, are there any considerations for the tty_io or driver code?

					Thanks, Joe
