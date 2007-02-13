Return-Path: <linux-kernel-owner+w=401wt.eu-S1751047AbXBMUdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751047AbXBMUdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 15:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbXBMUdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 15:33:38 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:41391 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbXBMUdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 15:33:37 -0500
Date: Tue, 13 Feb 2007 21:30:47 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Eric Lacombe <tuxiko@free.fr>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.19.2: maybe a bug inside the r8169 network driver (was Re: Linux 2.6.19.2: Freeze with CIFS mount)
Message-ID: <20070213203047.GA4158@electric-eye.fr.zoreil.com>
References: <OFC7B98576.0C582E30-ON87257274.0014583D-86257274.00153815@us.ibm.com> <200702131452.05473.tuxiko@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702131452.05473.tuxiko@free.fr>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Lacombe <tuxiko@free.fr> :
[...]
> That problem also remind me that when I compiled this driver without 
> the "CONFIG_NET_ETHERNET" (in the section "Ethernet (10 or 100Mbit)"), I have 
> really poor performance with the net device. Maybe it is related, or not ;)
> 
> If it gives you more ideas ?
> Maybe it could be interesting to know about the r8169 maintainer, but I dont 
> know who he is.

1. $ ls
   arch     crypto         include  kernel       mm              scripts
   block    Documentation  init     lib          net             security
   COPYING  drivers        ipc      MAINTAINERS  README          sound
   CREDITS  fs             Kbuild   Makefile     REPORTING-BUGS  usr

   The maintainer of the r8169 driver is listed in the MAINTAINERS file.

2. Disabling CONFIG_NET_ETHERNET is a bad idea. Don't do that.

3. See tethereal -w or tcpdump on the adequate interface to save a
   traffic dump.

4. Are you using a binary module for your video adapter ?

5. How does the 2.6.20 version of the r8169 driver behave ?

6. You may setup a cron to monitor an ethtool dump of the register of
   the 8169 at regular interval. ifconfig and /proc/interrupts could
   exhibit some unusual drift as time passes on too.

7. A dmesg would be welcome.

8. Please open a PR at bugzilla.kernel.org.

|...]
> > There are various ways to analyze system hangs including (at least in some
> > cases) getting a system dump which
> > can be used to isolate the failing location - hopefully
> 
> I would like to have more detailed help, if possible.

CONFIG_MAGIC_SYSRQ is set. Check that the magic sysrq is not disabled at
runtime through /etc/sysctl.conf. See Documentation/sysrq.txt for details.

Please keep Steve French in the loop.

-- 
Ueimor
