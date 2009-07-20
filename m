Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbZGTVjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbZGTVjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZGTVja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:39:30 -0400
Received: from mail.windriver.com ([147.11.1.11]:49459 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbZGTVj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:39:29 -0400
Message-ID: <4A64E3BA.1020009@windriver.com>
Date: Mon, 20 Jul 2009 16:38:02 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 07/10] ehci-dbgp,ehci: Allow early or late use of the
 dbgp device
References: <Pine.LNX.4.44L0.0907201721340.5320-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907201721340.5320-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jul 2009 21:37:47.0034 (UTC) FILETIME=[52A3B7A0:01CA0982]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Mon, 20 Jul 2009, Jason Wessel wrote:
>> +    /* optional debug port, normally in the first BAR */
>> +    temp = pci_find_capability(pdev, 0x0a);
>
> This isn't going to work very well on systems with non-PCI EHCI
> controllers.  Maybe you should leave debug-port detection in
> ehci-pci.c.  The controller doesn't get reset very much in any case.
>

I'll take a deeper look as to why it didn't work correctly where the
code was originally sitting.  It had something to do with the reset
clearing the debug controller settings.

This chunk got moved prior to creating the reset_prep logic, so in all
likely hood it should go back to where it was, because we do want this
to work with the pci and non-pci case.

>> +            if (!dbgp_reset_prep() || !(temp & DBGP_ENABLED))
>
> This sort of thing is better handled by defining dhbp_reset_prep() as
> an inline routine or macro always returning 1 if
> CONFIG_EARLY_PRINTK_DBGP isn't set.
>
>> +        dbgp_external_startup();
>
> Similarly here, make dgbp_external_startup() an empty inline function
> or an empty macro.
>

Sure, I'll fix these for a round #2 after any other comments come back.

Thanks for the comments,
Jason.
