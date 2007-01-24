Return-Path: <linux-kernel-owner+w=401wt.eu-S1752058AbXAXRr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbXAXRr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 12:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbXAXRr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 12:47:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:35126 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbXAXRr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 12:47:27 -0500
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@osdl.org>
Subject: Re: 2.6.19.2 sky2/acpi crashes
Date: Wed, 24 Jan 2007 09:44:08 -0800
Organization: OSDL
Message-ID: <20070124094408.600fd4e0@freekitty>
References: <1169542768.5537.11.camel@cocoduo>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Trace: build.pdx.osdl.net 1169660770 11218 10.8.0.54 (24 Jan 2007 17:46:10 GMT)
X-Complaints-To: abuse@osdl.org
NNTP-Posting-Date: Wed, 24 Jan 2007 17:46:10 +0000 (UTC)
X-Newsreader: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007 09:59:28 +0100
Lionel Landwerlin <landwer@free.fr> wrote:

> Hi,
> 
> I'm running a macbook with a Marvell ethernet controller, and I have a
> lots of freezes when using the ethernet controller under a load of
> ~100K/s. Since I'm running a 2.6.19.2 kernel, I'm able to get some
> report from the kernel. Here they are :

Please send sky2 bugs to me <shemminger@linux-foundation.org> and 
netdev@vger.kernel.org.

> I hope some fix could be released soon.

I get problem reports all the time, unfortunately, so far these have
not been reproducible on the configurations and hardware I have. I am
not denying there is a problem, but if I can't reproduce it, it takes
a long time to fix.

Your problem seems to be missed/lost interrupts. If you display
the contents of /proc/interrupts (ie cat /proc/interrupts), it
will show whether level (good), edge (bad) or MSI (good if hw works)
are being used.

Some workaround related things to try are:

1) Adding the module parameter "idle_timeout=10" will cause
the driver to poll for status every 10ms. This is obviously a performance
overhead but it can allow system to function.

2) Disabling MSI with either "pci=nomsi" on boot cmdline or by using
module parameter "disable_msi=1".  Message Signaled Interrupts are good,
but it seems some chipsets don't work right.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
