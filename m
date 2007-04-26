Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbXDZVm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbXDZVm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbXDZVm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:42:57 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:34669
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbXDZVmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:42:55 -0400
Message-ID: <46312AEE.1000302@microgate.com>
Date: Thu, 26 Apr 2007 16:42:54 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: compat_ioctl question
References: <1177620717.5060.11.camel@amdx2.microgate.com> <200704262337.56240.arnd@arndb.de>
In-Reply-To: <200704262337.56240.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> It depends a lot on what your specific driver does in the ioctl
> handler, but normally you should define a compat_ioctl() function.
> What driver are you talking about?

drivers/char/synclink.c
drivers/char/synclinkmp.c
drivers/char/synclink_gt.c
drivers/char/pcmcia/synclink_cs.c

All use the same set of ioctl() codes that
are peculiar to the synclink drivers.

Defining compat_ioctl() seems to be the best way, but
that will require modifying the base tty code to allow
the individual tty drivers to register compat_ioctl().

Currently the tty file ops do not include that and
tty_io.c does not register a compat_ioctl(), instead
relying on compat_ioctl.h and compat_ioctl.c

--
Paul

