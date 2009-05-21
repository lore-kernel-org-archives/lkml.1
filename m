Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbZEUWN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbZEUWN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 18:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbZEUWNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 18:13:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58972 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754960AbZEUWNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 18:13:49 -0400
Date: Thu, 21 May 2009 23:14:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How to tell whether a struct file is held by a process?
Message-ID: <20090521231452.676d4898@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510905211407l3aec14acx2572a2ad4e675b9@mail.gmail.com>
References: <20090521095217.GU8633@ZenIV.linux.org.uk>
	<Pine.LNX.4.44L0.0905210945290.2886-100000@iolanthe.rowland.org>
	<ac3eb2510905211407l3aec14acx2572a2ad4e675b9@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not sure, if we already discussed that with a conclusion: this
> "prevent access to a future device" interface needs to work at the pid
> level, or would a uid/gid check be sufficient?

As I said before neither pid or uid make any sense at all for a kernel
level check beyond what already exists at user space level (ie chown),
and what the usual user space gunk provides for device creation policy
(udev)

> Root can do all that stuff anyway, even with the locking in place.
> Uid/gid file permissions need to be applied to the "lock file", so
> specified non-root users can use that interface.

It's actually sometimes important that root can ignore the lock
files - eg to send a reset to a channel of a jammed device that is owned
by a user and wedged.
 
> Maybe it would be good enough, to check that the one that opened the
> "lock file" has the same uid/gid as the on that tries to open the
> device when it has shown up?

My feeling too - there simply isn't any need for kernel infrastructure
here. The only case the kernel must be involved is when you need
exclusivity including telling the kernel to leave things alone, and even
that usually only needs to be by specific handle and we normally borrow
O_EXCL for it as it has no "traditional" meaning on device nodes.

We do tty devices with lock files no reason it won't work for USB stuff
too.

Alan
