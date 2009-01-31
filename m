Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbZAaF5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbZAaF5S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 00:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZAaF5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 00:57:06 -0500
Received: from movementarian.org ([79.99.65.163]:40655 "EHLO movementarian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZAaF5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 00:57:05 -0500
X-Greylist: delayed 3563 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Jan 2009 00:57:04 EST
Date: Fri, 30 Jan 2009 23:57:33 -0500
From: wli@movementarian.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 3/7] epoll keyed wakeups - introduce key-aware wakeup macros
Message-ID: <20090131045733.GA26410@movementarian.org>
References: <send-serie.davidel@xmailserver.org.16376.1233372317.3> <alpine.LFD.2.00.0901301949110.3150@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901301949110.3150@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 07:49:26PM -0800, Linus Torvalds wrote:
> But even more I dislike the notion of this being a "key". It's not. It's 
> about poll events, nothing more. So renaming it to "_key()" in no way 
> helps.
> Yes, _internally_ we send that "void *key" around, and then leave it to 
> lower levels to agree about how it is used, but at the level _you_ then 
> use it, that is no longer the case. When you do a 
> 	kwake_up_interruptible(&tty->write_wait, POLLOUT);
> that has _nothing_ to do with "keys" any more. So the 'k' prefix is wrong 
> and really odd-looking, but a '_key' postfix wouldn't be much better 
> either. Because when you pass in POLLOUT, you're not using it as a key, 
> you are very much using it as a poll-specific thing.
> So the naming should match that. I suspect a '_poll' postfix (or a 'poll_' 
> prefix would work and make sense.

The filtered wakeup code uses some notion of a key already. There, the
key is to route wakeups to recipients associated with the correct
object. Here, the objects are known in advance. The wakeup is to give
them some particular message in which they may not necessarily be
interested. Names indicative of that (e.g. *_msg/msg_*) would clarify
the distinction between it and the filtered wakeup code used for pages.

-- wli
