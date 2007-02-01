Return-Path: <linux-kernel-owner+w=401wt.eu-S1422789AbXBAXPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422789AbXBAXPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 18:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422775AbXBAXPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 18:15:09 -0500
Received: from ns0.hunreg.com ([195.228.75.18]:43725 "EHLO
	mail.conceptonline.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422735AbXBAXPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 18:15:08 -0500
X-Greylist: delayed 1531 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Feb 2007 18:15:07 EST
Message-ID: <42007.80.98.159.250.1170369983.squirrel@www.hunhost.com>
Date: Thu, 1 Feb 2007 23:46:23 +0100 (CET)
Subject: Re: sky2 hangs
From: "Fagyal Csongor" <concept@conceptonline.hu>
To: <thomas@glanzmann.de>
In-Reply-To: <20070201185532.GL13130@cip.informatik.uni-erlangen.de>
References: <20070201185532.GL13130@cip.informatik.uni-erlangen.de>
X-Priority: 3
Importance: Normal
X-MSMail-Priority: Normal
Cc: <linux-kernel@vger.kernel.org>, <shemminger@linux-foundation.org>,
       <netdev@vger.kernel.org>
X-Mailer: SquirrelMail (version 1.2.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello,
> I have a sky2 network card in my intel mac mini. It stops working when I
> do havy network load like watching a divx over http/sshfs. However if I
> remove the driver module and load it again it works and even the tcp
> connection doesn't get shutdown. I automated the above procedure using a
> userland watchdog which basically does the same thing and is written
> entirely by me, because the traditional watchdog wasn't that reliable
> and did a lot of false positives:
>
>         * Look every ten seconds if my default router is pingable (3
>           pings, one has to get back).
>                 If it isn't the case I call network_fix script (it calls
> the script only once after a ping gets lost. To run the
> script again at least one ping has to arrive again)
>
>                 (mini) [~] cat /usr/local/sbin/fix_network
>                 #!/bin/bash
>
>                 export PATH=/bin:/usr/bin:/usr/sbin:/sbin
>
>                 rmmod sky2
>                 modprobe sky2
>                 ifdown eth0
>                 ifup eth0
>
>                 If after that no ping is received from the default
> router for another 90 seconds I tell init to reboot and
> stop feeding the kernel software watchdog.
>
>         * My watchdog also checks if sshd process is running. If it is
>           down for more than 100 seconds it reboots the machine, too.
>
> Jan 27 22:35:35 mini watchdog-tg[4146]: No PONG received from
> 192.168.0.3 (failure 1 of 10) Jan 27 22:35:35 mini watchdog-tg[4146]:
> Running fix_network script. Jan 27 22:38:46 mini watchdog-tg[4146]: No
> PONG received from 192.168.0.3 (failure 1 of 10) Jan 27 22:38:46 mini
> watchdog-tg[4146]: Running fix_network script. Jan 27 22:44:17 mini
> watchdog-tg[4146]: No PONG received from 192.168.0.3 (failure 1 of 10)
> Jan 27 22:44:17 mini watchdog-tg[4146]: Running fix_network script. Jan
> 29 12:00:13 mini watchdog-tg[4146]: No PONG received from 192.168.0.3
> (failure 1 of 10) Jan 29 12:00:13 mini watchdog-tg[4146]: Running
> fix_network script. Jan 29 19:18:59 mini watchdog-tg[4146]: No PONG
> received from 192.168.0.3 (failure 1 of 10) Jan 29 19:18:59 mini
> watchdog-tg[4146]: Running fix_network script. Jan 31 15:56:29 mini
> watchdog-tg[4146]: No PONG received from 192.168.0.3 (failure 1 of 10)
> Jan 31 15:56:29 mini watchdog-tg[4146]: Running fix_network script. Feb
> 1 08:56:57 mini watchdog-tg[4146]: No PONG received from 192.168.0.3
> (failure 1 of 10) Feb  1 08:56:57 mini watchdog-tg[4146]: Running
> fix_network script.
[...]

I would like to add a few things:

- a previously suggested fix - passing idle=poll to the kernel - did not
work for me at the end
- the locks I have happen very periodically (somewhere around every 22-28
hours), as if the chip would die after a given amount of data transferred;
I know this looks stupid but I thought I might mention it
- I have about 1Mbit/s of (incoming) traffic on this interface: with
short, very high peaks, as there is a MySQL server on the other end,
receiving about 100 queries per second
- unloading the sky2 module totally freezes the computer for me



- Fagzal


