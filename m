Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbXBJBd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbXBJBd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 20:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbXBJBd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 20:33:27 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:30256 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbXBJBd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 20:33:26 -0500
Date: Fri, 09 Feb 2007 19:33:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv - ADMA issues with 2.6.20
In-reply-to: <fa.uoZWqSFxPjjB7zobQOwk/2zqG5A@ifi.uio.no>
To: David R <david@unsolicited.net>
Cc: linux-kernel@vger.kernel.org
Message-id: <45CD20DB.9030808@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.uoZWqSFxPjjB7zobQOwk/2zqG5A@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David R wrote:
> I've just upgraded my home server to 2.6.20. It's got an Athlon64 on an ASUS
> nForce-4 motherboard running a 32 bit kernel. I've had to fall back to using
> sata_nv.adma=0 on the kernel command line. One of the NCQ capable drives
> repeatedly produced the following errors. There wasn't much disk IO going on
> at the time. It's perfectly happy now with ADMA disabled. Strange thing is the
> other identical drive ata8 showed no problems (they're both part of a software
> raid1)
> 
> Some clues follow.
> 
> Cheers
> David
> 
>>> Feb  9 18:40:27 server kernel: ata7: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x400
>>> Feb  9 18:40:27 server kernel: ata7: CPB 0: ctl_flags 0x1f, resp_flags 0x0
>>> Feb  9 18:40:27 server kernel: ata7: CPB 1: ctl_flags 0x1f, resp_flags 0x1
>>> Feb  9 18:40:27 server kernel: ata7: CPB 2: ctl_flags 0x1f, resp_flags 0x1
>>> Feb  9 18:40:27 server kernel: ata7: CPB 3: ctl_flags 0x1f, resp_flags 0x1
> etc etc..
>>> Feb  9 18:40:29 server kernel: ata7: CPB 27: ctl_flags 0x1f, resp_flags 0x1
>>> Feb  9 18:40:29 server kernel: ata7: CPB 28: ctl_flags 0x1f, resp_flags 0x1
>>> Feb  9 18:40:29 server kernel: ata7: CPB 29: ctl_flags 0x1f, resp_flags 0x1
>>> Feb  9 18:40:29 server kernel: ata7: CPB 30: ctl_flags 0x1f, resp_flags 0x1
>>> Feb  9 18:40:29 server kernel: ata7: Resetting port
>>> Feb  9 18:40:29 server kernel: ata7.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
>>> Feb  9 18:40:29 server kernel: ata7.00: cmd 61/08:00:1f:e4:50/00:00:09:00:00/40 tag 0 cdb 0x0 data 4096 out
>>> Feb  9 18:40:29 server kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)

So it was tag 0 that timed out , and according to the CPBs the 
controller indeed believes the command is still outstanding, i.e. we 
didn't lose an interrupt. I'm suspicious of the fact that only one of 
two identical drives produced this error.. some kind of hardware-related 
problem perhaps? 30 seconds is an awfully long time for a drive to take 
to finish a command.

You can also try disabling NCQ without disabling ADMA and see what that 
does:

echo 1 > /sys/block/sdX/device/queue_depth

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

