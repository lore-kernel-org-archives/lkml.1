Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbXFLF44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbXFLF44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 01:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbXFLF4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 01:56:48 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:23587 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbXFLF4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 01:56:48 -0400
Date: Mon, 11 Jun 2007 23:55:47 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv adma issues
In-reply-to: <fa.FTA/czKnA9MrTZ9ueGrcQfRm9qs@ifi.uio.no>
To: Charles Shannon Hendrix <shannon@widomaker.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <466E3563.1030900@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.FTA/czKnA9MrTZ9ueGrcQfRm9qs@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Charles Shannon Hendrix wrote:
> 
> My system has issues running adma mode with sata_nv.  I have an nforce4 
> motherboard.
> 
> What is the current status of this problem?

You'll have to be a bit more specific than that. A few problems have 
arisen in the past, but currently I don't think there is anything known 
outstanding other than one hotplug issue which currently is lacking in 
information to debug.

> 
> Is there any information I can provide to help debug it?
> 
> I gave up trying various fixes about 6 months ago, and put 
> "sata_nv.adma=0" on the kernel command line in LILO, and that fixed the 
> problem.
> 
> However, recently I changed distributions and went back to 2.6.20 
> (kubuntu 7.04).
> 
> This kernel says that sata_nv.adma=0 is an invalid kernel option.
> 
> I'm pretty puzzled by that, because it is supposed to disable adma mode 
> in the sata_nv driver.
> 
> /proc/cmdline says:
> 
> root=<hash> ro sata_nv.adma=0 quiet splash
> 
> ..so it seems I did give the parameter properly.
> 
> Any ideas appreciated.

If sata_nv is built modular, then you may need to put:

options sata_nv adma=0

in /etc/modprobe.conf instead.

However I should point out that adma=0 is a poor workaround, it would be 
better to find the real cause of the problem.

> 
> Is there a better way to deal with this?
> 
> Also, one more: does it hurt to wait until the sata_nv driver fails a 
> few times (at which point it stops bitching) and use the machine?  Once it
> fails about 6 times, I no longer have any issues, and speed is still 
> good enough to use until a real fix can be had.

Please post the dmesg output from when this happens. If it starts 
working after the kernel disables NCQ, then it might mean that your 
drive has some problems with NCQ..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

