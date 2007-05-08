Return-Path: <linux-kernel-owner+w=401wt.eu-S934758AbXEHWVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934758AbXEHWVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934658AbXEHWVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:21:51 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:51836
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934620AbXEHWVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:21:50 -0400
Message-ID: <46410577.2070202@microgate.com>
Date: Tue, 08 May 2007 17:19:19 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] synclink_gt add compat_ioctl
References: <1178215277.4369.6.camel@amdx2.microgate.com> <200705060227.29450.arnd@arndb.de> <1178658843.4152.12.camel@x2.microgate.com> <200705090007.53613.arnd@arndb.de>
In-Reply-To: <200705090007.53613.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> To solve this, you can to change include/linux/Kbuild to list
> synclink.h as unifdef-y instead of header-y, and put the parts
> that you don't want to be in user space inside of #ifdef __KERNEL__.
> 
> Alternatively, you can put these kernel-internal definitions into
> a private header file in drivers/char that does not get installed
> in the first place. That would be particularly useful if you can
> also move other parts of linux/synclink.h into the private header,
> when they are not part of the external ABI.

Understood. That is the last piece to the puzzle.

I think the first approach would be better as
synclink.h is all interface definitions. The kernel
specific parts are in the individual synclink drivers
(such as register definitions, etc). The only exception
to this is now the ioctl32 structures and I would hate
to break out a whole new header just for that.

Thanks again for your targeted and informative help.
(Thanks to Andrew for your patience in dealing
with a patch that never should have been submitted.)

--
Paul






