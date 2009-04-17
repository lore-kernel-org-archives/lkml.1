Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbZDQJWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbZDQJWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 05:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbZDQJV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 05:21:58 -0400
Received: from smtp.nokia.com ([192.100.122.233]:39998 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160AbZDQJV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 05:21:57 -0400
Subject: Re: [PATCH] mtd: fix timeout in M25P80 driver
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Peter Horton <phorton@bitbox.co.uk>
Cc: Peter Horton <zero@colonel-panic.org>, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <49E83C3D.8020404@bitbox.co.uk>
References: <20090413142633.GA1560@sloth.localnet>
	 <1239953060.3390.239.camel@localhost.localdomain>
	 <49E83C3D.8020404@bitbox.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Apr 2009 12:21:28 +0300
Message-Id: <1239960088.3390.297.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Apr 2009 09:21:29.0902 (UTC) FILETIME=[E42FD4E0:01C9BF3D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 09:22 +0100, Peter Horton wrote:
> Artem Bityutskiy wrote:
> > On Mon, 2009-04-13 at 15:26 +0100, Peter Horton wrote:
> >> Extend erase timeout in M25P80 SPI Flash driver.
> >>
> >> The M25P80 drivers fails erasing sectors on a M25P128 because the ready
> >> wait timeout is too short. Change the timeout from a simple loop count to a
> >> suitable number of seconds.
> >>
> >> Signed-off-by: Peter Horton <zero@colonel-panic.org>
> >> ---
> >> Index: linux-2.6.29-git12/drivers/mtd/devices/m25p80.c
> >> ===================================================================
> >> --- linux-2.6.29-git12.orig/drivers/mtd/devices/m25p80.c	2009-04-12 21:41:16.000000000 +0000
> >> +++ linux-2.6.29-git12/drivers/mtd/devices/m25p80.c	2009-04-12 21:43:01.000000000 +0000
> >> @@ -54,7 +54,7 @@
> >>  #define	SR_SRWD			0x80	/* SR write protect */
> >>  
> >>  /* Define max times to check status register before we give up. */
> >> -#define	MAX_READY_WAIT_COUNT	100000
> >> +#define	MAX_READY_WAIT_JIFFIES	(10 * HZ)	/* eg. M25P128 specs 6s max sector erase */
> >>  #define	CMD_SIZE		4
> >>  
> >>  #ifdef CONFIG_M25PXX_USE_FAST_READ
> >> @@ -145,20 +145,20 @@
> >>   */
> >>  static int wait_till_ready(struct m25p *flash)
> >>  {
> >> -	int count;
> >> +	unsigned long deadline;
> >>  	int sr;
> >>  
> >> -	/* one chip guarantees max 5 msec wait here after page writes,
> >> -	 * but potentially three seconds (!) after page erase.
> >> -	 */
> > Why did you remove the comment? Is it wrong or useless?
> > 
> 
> I moved the comment up to the definition of MAX_READY_WAIT_JIFFIES. 
> Looking through the code I missed the fact the driver can generate "chip 
> erase", on the M25P128 the maximum ready timeout for this is 250s !!!

So I assume you are going to send another patch? Also, how about
Andrew's suggestion not to hog CPU?

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

