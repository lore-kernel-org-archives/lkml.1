Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbXG2BtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbXG2BtP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 21:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbXG2BtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 21:49:01 -0400
Received: from max.aladin.ro ([80.96.155.2]:58419 "EHLO aladin.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbXG2BtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 21:49:00 -0400
X-Greylist: delayed 3478 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jul 2007 21:49:00 EDT
Message-ID: <46ABE473.2030507@aladin.ro>
Date: Sun, 29 Jul 2007 03:50:59 +0300
From: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UML - Console should handle spurious IRQS
References: <20070727152344.GA6776@c2.user-mode-linux.org>
In-Reply-To: <20070727152344.GA6776@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

*This message was transferred with a trial version of CommuniGate(r) Pro*
Jeff Dike wrote:
> The previous DEBUG_SHIRQ patch missed one case.  The console doesn't
> set its host descriptors non-blocking.

Sorry, things looked okay when I tested on my UML environment (Puppy 
Linux). Some xterms popped around (because I was using "con=xterm") and 
the system was usable, so it gave me no indication something was wrong.

I thought of adding an extra debugging option to warn us when a blocking 
  I/O operation is issued for a socket/fd, but UML-specific code is not 
consistent regarding glibc functions. That is, most of the time it calls 
os_*(), but sometimes it calls functions like recvfrom() directly. I'll 
grep the source code for such calls and send a patch to clean it up a bit.

There might still be such cases, I haven't tested all channel types yet.
