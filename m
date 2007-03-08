Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbXCHPpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbXCHPpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 10:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbXCHPpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 10:45:38 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:43794 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbXCHPph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 10:45:37 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 8 Mar 2007 07:45:13 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: "David M. Lloyd" <dmlloyd@flurg.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
In-Reply-To: <1173364264.6891.3.camel@localhost>
Message-ID: <Pine.LNX.4.64.0703080742220.7015@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703071712210.3672@alien.or.mcafeemobile.com>
 <1173364264.6891.3.camel@localhost>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007, David M. Lloyd wrote:

> On Wed, 2007-03-07 at 17:21 -0800, Davide Libenzi wrote:
> > int signalfd_dequeue(int fd, siginfo_t *info, long timeo);
> > 
> > The "fd" parameter must ba a signalfd file descriptor. The "info" parameter
> > is a pointer to the siginfo that will receive the dequeued signal, and
> > "timeo" is a timeout in milliseconds, or -1 for infinite.
> > The signalfd_dequeue function returns 0 if successfull.
> 
> Does this support non-blocking mode?  It doesn't seem to at my level of
> understanding anyway.  If I use this with EPOLLET for example, I'd
> expect to get a single EPOLLIN when a signal arrives, which would
> indicate to me that I must call signalfd_dequeue() in a loop until I get
> EAGAIN in order to be sure I've consumed all the outstanding signals so
> that the edge-triggered notification can be "re-armed".

This patch, if you get a POLLIN, you have a signal to read for sure (well, 
unless you another thread/task reads it before you - but that's just 
somthing you have to take care). There is not explicit check for 
O_NONBLOCK now, but a zero timeout would do exactly the same thing.


- Davide


