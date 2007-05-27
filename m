Return-Path: <linux-kernel-owner+w=401wt.eu-S1759052AbXE0VQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052AbXE0VQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757170AbXE0VQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:16:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48011
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756840AbXE0VQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:16:16 -0400
Date: Sun, 27 May 2007 14:16:22 -0700 (PDT)
Message-Id: <20070527.141622.30184020.davem@davemloft.net>
To: jengelh@linux01.gwdg.de
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Linux always started with 9600 8N1
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.61.0705271816310.7344@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705261649590.7344@yvahk01.tjqt.qr>
	<20070526.154745.30164056.davem@davemloft.net>
	<Pine.LNX.4.61.0705271816310.7344@yvahk01.tjqt.qr>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Date: Sun, 27 May 2007 18:44:18 +0200 (MEST)

> 
> On May 26 2007 15:47, David Miller wrote:
> >> I have set the OBP to run at 115200, also set agetty on ttyS0 to do the 
> >> same, and also added console=ttyS0,115200 to silo.conf (and also tried 
> >> console=ttyS0,115200n8). But! Linux still gives me 9600 8N1. The ominous 
> >> double screen blanking (why is that done anyway?) already takes place 
> >> with 9600. I smell a bug. What do you think?
> >
> >The code in drivers/serial/suncore.c:sunserial_console_termios()
> >should be parsing your OBP settings, add some tracing and see why it
> >isn't working.
> >
> >Please track the bug down for us, thanks :-)
> 
> Just why did no one get a kernel oops? After all, the code tried to
> write to constant memory.
> 
> This is the first patch of two. There is yet another section of Linux 
> code that runs in 9600-only, and I need to figure out which.

There should not be an OOPS, we don't map any section of the
kernel as read-only or execute-only or anything like that.

The kernel image is mapped with full read/write/execute permission.

So even writes to so-called 'read-only' sections of the kernel image
will work and therefore I don't understand what the bug could be other
than the compiler "optimizing" away the write to the constant string
in which case the compiler should have warned about it.
