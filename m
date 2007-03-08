Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbXCHObp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbXCHObp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 09:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbXCHObp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 09:31:45 -0500
Received: from outbound1.mail.tds.net ([216.170.230.91]:32839 "EHLO
	outbound1.mail.tds.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbXCHObo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 09:31:44 -0500
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
From: "David M. Lloyd" <dmlloyd@flurg.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703071712210.3672@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703071712210.3672@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 08:31:04 -0600
Message-Id: <1173364264.6891.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 17:21 -0800, Davide Libenzi wrote:
> int signalfd_dequeue(int fd, siginfo_t *info, long timeo);
> 
> The "fd" parameter must ba a signalfd file descriptor. The "info" parameter
> is a pointer to the siginfo that will receive the dequeued signal, and
> "timeo" is a timeout in milliseconds, or -1 for infinite.
> The signalfd_dequeue function returns 0 if successfull.

Does this support non-blocking mode?  It doesn't seem to at my level of
understanding anyway.  If I use this with EPOLLET for example, I'd
expect to get a single EPOLLIN when a signal arrives, which would
indicate to me that I must call signalfd_dequeue() in a loop until I get
EAGAIN in order to be sure I've consumed all the outstanding signals so
that the edge-triggered notification can be "re-armed".

Make sense?

- DML

