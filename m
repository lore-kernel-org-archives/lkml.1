Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYAQOyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYAQOyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 09:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbYAQOya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 09:54:30 -0500
Received: from mail0.scram.de ([78.47.204.202]:34833 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbYAQOya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 09:54:30 -0500
X-Spam-Score: -4.046
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.4 AWL AWL: From: address is in the auto white-list
Message-ID: <478F6C5F.4010505@scram.de>
Date: Thu, 17 Jan 2008 15:55:27 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: wim@iguana.be, Scott Wood <scottwood@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFCv2] wdt: Add support for PowerQUICC watchdog
References: <478F4E4A.4060907@scram.de> <A00FB5AE-903B-461A-B234-4BA817B3C5CB@kernel.crashing.org>
In-Reply-To: <A00FB5AE-903B-461A-B234-4BA817B3C5CB@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

> Why are you commenting on mpc83xx_wdt with respect to pq1_wdt?
> 
> Also, is this driver just for PQ1 platforms or PQ1 & PQ2?  If its just 
> pq1 we should probably call it pq1_wdt*

It should be for pq1, pq2 and pq2pro. However, i only have the possibility
to test this on pq1.

>> arch/powerpc/platforms/8xx/mpc86xads_setup.c |    5 +
>> arch/powerpc/platforms/8xx/mpc885ads_setup.c |    5 +
>> arch/powerpc/sysdev/Makefile                 |    3 +
>> arch/powerpc/sysdev/pq_wdt.c                 |  203 
>> +++++++++++++++++++++++
>> arch/powerpc/sysdev/pq_wdt.h                 |   28 ++++
>> drivers/watchdog/Kconfig                     |   13 ++-
>> drivers/watchdog/Makefile                    |    1 +
>> drivers/watchdog/pq_wdt.c                    |  225 
>> ++++++++++++++++++++++++++
>> 8 files changed, 482 insertions(+), 1 deletions(-)
>> create mode 100644 arch/powerpc/sysdev/pq_wdt.c
>> create mode 100644 arch/powerpc/sysdev/pq_wdt.h
>> create mode 100644 drivers/watchdog/pq_wdt.c
> 
> What are the bits in sysdev/pq_wdt.{c,h}.  Why aren't these just in 
> drivers/watchdog?

These are the parts needed to boot a device with activated watchdog. If a 
bootloader like u-boot activates the watchdog, it can't be deactivated again
and needs to be reset at regular intervals. This is done using a kernel timer.
The driver in drivers/watchdog disables the timer as soon as the wdt device
is opened.

Thanks,
Jochen
