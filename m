Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYEPDXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYEPDXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 23:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYEPDXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 23:23:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187AbYEPDXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 23:23:32 -0400
Date: Thu, 15 May 2008 20:23:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Rankin <rankincj@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: 2.6.25.3: serial problem (minicom)
Message-Id: <20080515202300.4d0465ac.akpm@linux-foundation.org>
In-Reply-To: <7723.10156.qm@web52901.mail.re2.yahoo.com>
References: <7723.10156.qm@web52901.mail.re2.yahoo.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 20:06:23 +0100 (BST) Chris Rankin <rankincj@yahoo.com> wrote:

> I have two Linux boxes connected by a null-modem cable between their serial ports; one box exports
> a serial console, which the other reads using the minicom program. However, I have noticed that
> minicom can no longer use the serial console when it is running on a 2.6.25.3 kernel, although it
> works fine running on a 2.6.24.4 kernel.
> 
> Specifically, with minicom running on 2.6.25.3, the console does not accept keystrokes although it
> does receive the boot log from the remote machine.
> 
> The serial console is being exported by a 2.6.25.3 kernel, and appears to be working correctly.

We did make some changes to serial_core.c in that timeframe which might
have caused this, such as:

Author: Russell King <rmk+lkml@arm.linux.org.uk>  2008-02-04 22:27:52
Committer: Linus Torvalds <torvalds@woody.linux-foundation.org>  2008-02-05 09:44:10
Parent: 9d778a69370cc1b643b13648df971c83ff5654ef (serial: avoid waking up closed serial ports on resume)
Child:  6d4d67beb963de8865499781b8523e5b683819c3 (serial: speed setup failure reporting)
Branches: many (89)
Follows: v2.6.24
Precedes: v2.6.25-rc1

    serial: avoid stalling suspend if serial port won't drain


Author: Yinghai Lu <Yinghai.Lu@Sun.COM>  2008-02-04 22:27:46
Committer: Linus Torvalds <torvalds@woody.linux-foundation.org>  2008-02-05 09:44:09
Parent: 149b36eae2ab6aa6056664f4bc461f3d3affc9c1 (serial: stop passing NULL to functions that expect data)
Child:  9d778a69370cc1b643b13648df971c83ff5654ef (serial: avoid waking up closed serial ports on resume)
Branches: many (89)
Follows: v2.6.24
Precedes: v2.6.25-rc1

    serial: keep the DTR setting for serial console.
    

But I don't recall seeing any other reports of this and there's not
really anyone who is actively working on the serial drivers.

All of which builds up to the dreaded....  would you be able to perform
a bisection search to work out which commit caused this?
http://www.kernel.org/doc/local/git-quick.html has instructions.

Thanks.
