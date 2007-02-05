Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbXBERvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbXBERvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbXBERvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:51:13 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:58298 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbXBERvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:51:12 -0500
Date: Mon, 5 Feb 2007 20:45:52 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: "David M. Lloyd" <dmlloyd@flurg.com>
Cc: David Miller <davem@davemloft.net>, Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@osdl.org>, netdev <netdev@vger.kernel.org>,
       Zach Brown <zach.brown@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Chase Venters <chase.venters@clientec.com>,
       Johann Borck <johann.borck@densedata.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Jamal Hadi Salim <hadi@cyberus.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org
Subject: Re: [take35 0/10] kevent: Generic event handling mechanism.
Message-ID: <20070205174552.GA2726@2ka.mipt.ru>
References: <11703247503374@2ka.mipt.ru> <1170696485.22199.1.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <1170696485.22199.1.camel@localhost>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Mon, 05 Feb 2007 20:45:58 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 11:28:05AM -0600, David M. Lloyd (dmlloyd@flurg.com) wrote:
> On Thu, 2007-02-01 at 13:12 +0300, Evgeniy Polyakov wrote:
> > Generic event handling mechanism.
> 
> The patch applied cleanly to 2.6.20 final, but I got a build error:
> 
>   CC      kernel/kevent/kevent.o
>   CC      kernel/kevent/kevent_user.o
>   CC      kernel/kevent/kevent_timer.o
>   CC      kernel/kevent/kevent_poll.o
> make[2]: *** No rule to make target `kernel/kevent/epoll.o', needed by `kernel/kevent/built-in.o'.  Stop.
> make[1]: *** [kernel/kevent] Error 2
> make: *** [kernel] Error 2

It looks like I generated wrong diff from my tree - it compiles just
fine. This patch should fix it. That hunk is about epoll rewrite over
keent I posted couple of weeks ago.

Thanks for testing.

> - DML

diff --git a/kernel/kevent/Makefile b/kernel/kevent/Makefile
index a179bea..dc7f8b2 100644
--- a/kernel/kevent/Makefile
+++ b/kernel/kevent/Makefile
@@ -1,6 +1,6 @@
 obj-y := kevent.o kevent_user.o
 obj-$(CONFIG_KEVENT_TIMER) += kevent_timer.o
-obj-$(CONFIG_KEVENT_POLL) += kevent_poll.o epoll.o
+obj-$(CONFIG_KEVENT_POLL) += kevent_poll.o
 obj-$(CONFIG_KEVENT_SOCKET) += kevent_socket.o
 obj-$(CONFIG_KEVENT_PIPE) += kevent_pipe.o
 obj-$(CONFIG_KEVENT_SIGNAL) += kevent_signal.o


-- 
	Evgeniy Polyakov
