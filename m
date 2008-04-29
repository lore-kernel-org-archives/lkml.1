Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbYD2MUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbYD2MUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbYD2MT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:19:59 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:4084 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbYD2MT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:19:57 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-2.tower-164.messagelabs.com!1209471595!12552682!2
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Tue, 29 Apr 2008 14:19:24 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <dbrownell@users.sourceforge.net>
CC: <linux-kernel@vger.kernel.org>
Subject: rtc: how should I handle an invalid state?
Message-ID: <20080429121924.GA2137@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 29 Apr 2008 12:19:24.0331 (UTC) FILETIME=[42D2AFB0:01C8A9F3]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1026-15878.007
X-TM-AS-Result: No--5.379000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm still stuck with my rtc.  My current problem is setting the rtc
using hwclock --systohc.

The problem is that hwclock tries to read the current time before
setting the new one.  And if that fails, it doesn't update the rtc.

If no error occurs the procedure to read the time is:

	fd = open("/dev/rtc", O_RDONLY|O_LARGEFILE)
	ioctl(fd, RTC_UIE_ON, 0);
	select(fd + 1, [fd], NULL, NULL, {5, 0});
	ioctl(fd, RTC_RD_TIME, &rtc_time);

If one of ioctl(fd, RTC_UIE_ON, 0) or select(fd + 1, [fd], NULL, NULL,
{5, 0}) fail, hwclock aborts.

OTOH I don't want to report success in both because then there is no way
to distinguish between a valid and an unvalid date for hwclock.

Looking at some other drivers they don't seem to handle that case.

Maybe returning an invalid date could work?

What do you think?

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
