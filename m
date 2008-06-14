Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbYFNKbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbYFNKbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 06:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYFNKbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 06:31:41 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:57573 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753059AbYFNKbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 06:31:40 -0400
Date: Sat, 14 Jun 2008 12:02:33 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: c4p7n1@capitanio.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [BUG or cosmic ray] WARNING: at net/sched/sch_generic.c:222
	dev_watchdog+0xe8/0x100()
Message-ID: <20080614100233.GA1495@electric-eye.fr.zoreil.com>
References: <200806132308.m5DN8EM2012376@post.webmailer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806132308.m5DN8EM2012376@post.webmailer.de>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

c4p7n1@capitanio.org <c4p7n1@capitanio.org> :
[...]
> > > [  125.682725] r8169: eth0: link up
> > > ...
> > > [ 1337.654531] NETDEV WATCHDOG: eth0: transmit timed out
> > > [ 1338.333962] r8169: eth0: link up
> ...
> 
> Definitely a bug. I've got the same lock-up a second time on a rc5.
> 
> It may be related to a patch:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=21e197f231343201368338603cb0909a13961bac

Short answer: no.

With this patch the device driver can at least try to initialize. Without it,
you are bust.

> Before that patch on this chip [10ec:8136] the r8169 driver crashed with a null pointer exception.
> Strangely, on a .22  kernel came out (at that time always) the same lspci error:
> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E PCI Express Fast Ethernet controller (rev ff) (prog-if ff)
>  !!! Unknown header type 7f
> 
> ... just my observations ;-) 

They are welcome.

If lspci can not read the device registers correctly, chances are high
that the device driver can not either.

If you can reproduce the "!!! Unknown header type 7f" error with lspci
on 2.6.26-rc6 we have a problem which goes beyond the sole r8169 device
driver. linux-kernel or linux-pci will probably be more helpful than
netdev then.

Playing with the pci=nommconf , noapic or nomsi options at boot time
can make a difference with relation to lspci behavior. It is possible
(or almost certain given Murphy's grip) that the r8169 driver will
still not behave correctly. I have not received a lot of success/failure
reports for this chipset ([10ec:8136]) so things can surely improve.

-- 
Ueimor
