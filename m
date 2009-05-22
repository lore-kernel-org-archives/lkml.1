Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbZEVNa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbZEVNa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 09:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbZEVNaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 09:30:20 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:56241 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbZEVNaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 09:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bscgl8BDp6ssEgdCzJmZbn4FaxlBrlv/odmh4P6EuQyjsm0q0/8yOM5OXC4psdEZl/
         WxdR9PXV/3MSnMcSdsGK7OgQ5t1/XOBSYftKUw4PwPPG72y0zoLhXVnT929cgGjW5ogM
         XUSDSlNrGM91/55f4iOCS9BrE/gMalff1tx0Q=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0905211724050.3914-100000@iolanthe.rowland.org>
References: <ac3eb2510905211407l3aec14acx2572a2ad4e675b9@mail.gmail.com>
	 <Pine.LNX.4.44L0.0905211724050.3914-100000@iolanthe.rowland.org>
Date: Fri, 22 May 2009 16:30:20 +0300
Message-ID: <1295ed070905220630q67c62569o9753425abf529742@mail.gmail.com>
Subject: Re: How to tell whether a struct file is held by a process?
From: Pantelis Koukousoulas <pktoss@gmail.com>
To: Kernel development list <linux-kernel@vger.kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only problem I find with leaving mutual exclusion 100% to userspace and
burdening the kernel only with the decision of whether a port should be
handled by kernel or userspace is this:

Suppose a device needs a reset as part of its init sequence (a whole lot
of them do, this is not purely hypothetical). Then a different process may
get to operate the device before and after the reset and hilarity may result
from that.

There is also the issue of a Program (as in Vmware, Qemu etc, not as in pid)
thinking it has claimed a port and then finding the device just connected
there is actually unavailable to operate, but this doesn't sound that bad.
(After all, the device itself might have been broken, having claimed a port
in no way guarantees success in operating devices connected there).

So, if there is a clean / acceptable way to handle the reset issue in userspace
I 'm happy to dispose with kernel-level checks for 'allowed processes'
altogether.

Does that sound reasonable?

Thanks a lot for the discussion,
Pantelis
