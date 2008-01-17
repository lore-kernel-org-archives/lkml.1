Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbYAQOcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbYAQOcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 09:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbYAQOcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 09:32:33 -0500
Received: from gate.crashing.org ([63.228.1.57]:49611 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbYAQOcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 09:32:31 -0500
Cc: wim@iguana.be, Scott Wood <scottwood@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-Id: <A00FB5AE-903B-461A-B234-4BA817B3C5CB@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Jochen Friedrich <jochen@scram.de>
In-Reply-To: <478F4E4A.4060907@scram.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH/RFCv2] wdt: Add support for PowerQUICC watchdog
Date: Thu, 17 Jan 2008 08:31:26 -0600
References: <478F4E4A.4060907@scram.de>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 17, 2008, at 6:47 AM, Jochen Friedrich wrote:

> The PowerQUICC series has a watchdog which can be activated by the  
> boot
> loader and then needs to be reset in regular intervals. Once the
> watchdog is enabled, it can't be disabled anymore. This patch adds
> support for this kind of watchdog. An early init function is  
> provided to
> manually reset the watchdog in early board setup. Later, a kernel  
> timer
> is used to reset the watchdog until the watchdog driver is opened from
> user space. This replaces mpc8xx_wdt.c (only usable for ARCH=ppc) and
> mpc83xx_wdt.c (untested on this platform).

Why are you commenting on mpc83xx_wdt with respect to pq1_wdt?

Also, is this driver just for PQ1 platforms or PQ1 & PQ2?  If its just  
pq1 we should probably call it pq1_wdt*

> Signed-off-by: Jochen Friedrich <jochen@scram.de>
> ---
> arch/powerpc/platforms/8xx/mpc86xads_setup.c |    5 +
> arch/powerpc/platforms/8xx/mpc885ads_setup.c |    5 +
> arch/powerpc/sysdev/Makefile                 |    3 +
> arch/powerpc/sysdev/pq_wdt.c                 |  203 +++++++++++++++++ 
> ++++++
> arch/powerpc/sysdev/pq_wdt.h                 |   28 ++++
> drivers/watchdog/Kconfig                     |   13 ++-
> drivers/watchdog/Makefile                    |    1 +
> drivers/watchdog/pq_wdt.c                    |  225 +++++++++++++++++ 
> +++++++++
> 8 files changed, 482 insertions(+), 1 deletions(-)
> create mode 100644 arch/powerpc/sysdev/pq_wdt.c
> create mode 100644 arch/powerpc/sysdev/pq_wdt.h
> create mode 100644 drivers/watchdog/pq_wdt.c

What are the bits in sysdev/pq_wdt.{c,h}.  Why aren't these just in  
drivers/watchdog?

- k
