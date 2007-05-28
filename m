Return-Path: <linux-kernel-owner+w=401wt.eu-S1762898AbXE1Sfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762898AbXE1Sfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 14:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbXE1Sf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 14:35:26 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:37503 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbXE1SfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 14:35:25 -0400
Date: Mon, 28 May 2007 19:35:14 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Message-ID: <20070528183513.GA2815@srcf.ucam.org>
References: <200701051001.58472.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701051001.58472.david-b@pacbell.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [patch 2.6.20-rc3 1/3] rtc-cmos driver
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 05, 2007 at 10:01:57AM -0800, David Brownell wrote:
> This is an "RTC framework" driver for the "CMOS" RTCs which are standard
> on PCs and some other platforms.  That's MC146818 compatible silicon.
> Advantages of this vs. drivers/char/rtc.c (use one _or_ the other, only
> one will be able to claim the RTC irq) include:

Sorry for getting to this so late - I've only just started playing with 
this driver.

> +static int cmos_read_alarm(struct device *dev, struct rtc_wkalrm *t)

This is awkward. At the very least, year will be set to -1. This then 
gets passed through to rtc_tm_to_time, which results in reading 
wakealarm providing very odd feedback. I guess the "right" fix is for 
rtc_tm_to_time to use the current values for anything that's -1?

> +	rtc_control = CMOS_READ(RTC_CONTROL);
> +	rtc_control &= ~(RTC_PIE | RTC_AIE | RTC_UIE);

Do you really want to clobber RTC_AIE on probe? If an alarm has been set 
by the BIOS, it seems a little unfair to disable it on boot.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
