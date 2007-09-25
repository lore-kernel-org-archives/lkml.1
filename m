Return-Path: <linux-kernel-owner+w=401wt.eu-S1760761AbXIYRmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761AbXIYRmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbXIYRlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:41:55 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:54671 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbXIYRly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:41:54 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 25 Sep 2007 10:41:47 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Jonathan Corbet <corbet@lwn.net>
cc: Michael Kerrisk <mtk-manpages@gmx.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/4] new timerfd API v2 - new timerfd API 
In-Reply-To: <12492.1190738426@lwn.net>
Message-ID: <Pine.LNX.4.64.0709251035330.9111@alien.or.mcafeemobile.com>
References: <12492.1190738426@lwn.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007, Jonathan Corbet wrote:

> One quick question:
> 
> > Like the previous timerfd API implementation, read(2) and poll(2) are supported
> > (with the same interface).
> 
> Looking at that interface, it appears that a process doing a read() on a
> timerfd with no timer set will block for a very long time.  It's an
> obvious "don't do that" situation, but perhaps we could help an
> occasional developer get a clue by returning something like -EINVAL when
> the timer has not been set?

That is the same as you try to read once more after an expired timer. You 
won't wake up until the next timer event will show up. That is, after at 
most TP time for periodic timers, or after the time  the next 
timerfd_settime() will setup.
I'd like to keep the "timerfd not set yet" and the "timerfd already 
expired and not re-armed" acting the same way. That is, wait till next 
event happen (unless O_NONBLOCK of course).



- Davide


