Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbYEOIpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbYEOIpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 04:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYEOIpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 04:45:00 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53847 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbYEOIo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 04:44:58 -0400
Date: Thu, 15 May 2008 10:44:57 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jonathan Corbet <corbet@lwn.net>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree 
In-Reply-To: <6457.1210801515@vena.lwn.net>
Message-ID: <alpine.LNX.1.10.0805151041380.16151@fbirervta.pbzchgretzou.qr>
References: <6457.1210801515@vena.lwn.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-05-14 23:45, Jonathan Corbet wrote:
>Sez Ingo:
>1: We could add an unlocked_open() to the file_operations structure;
>   drivers could be converted over as they are verified not to need the
>   BKL on open.  Disadvantages are that it grows this structure for a
>   relatively rare case - most open() calls already don't need the BKL.
>   But it's a relatively easy path without flag days.

1b: add a .locked_open and move all BKL-requiring code to use that.
When time comes and BKL is gone, .locked_open can be removed again,
and no rename was ever done for BKL-free code.

>2: Create a char_dev_ops structure for char devs and use it instead of
>   file_operations.  I vaguely remember seeing Al mutter about that a
>   while back.  Quite a while back.  This mirrors what was done with
>   block devices, and makes some sense - there's a lot of stuff in
>   struct file_operations which is not really applicable to char devs.
>   Then struct char_dev_ops could have open() and locked_open(), with
>   the latter destined for removal sometime around 2015 or so.

Iff you create a new char_dev_ops, don't clutter it with the old stuff.
BKL-using code could continue using file_operations, would not it?

>3: Provide a new form of cdev_add() which lets the driver indicate
>   that the BKL is not needed on open (or anything else?).  At a

This is the BSD/Solaris tactic, heh :)

