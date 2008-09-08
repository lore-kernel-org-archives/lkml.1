Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYIHXon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYIHXon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 19:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbYIHXof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 19:44:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48731
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753250AbYIHXoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 19:44:34 -0400
Date: Mon, 08 Sep 2008 16:44:27 -0700 (PDT)
Message-Id: <20080908.164427.216880550.davem@davemloft.net>
To: david-b@pacbell.net
Cc: James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, alessandro.zummo@towertech.it
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
From: David Miller <davem@davemloft.net>
In-Reply-To: <200809081629.21125.david-b@pacbell.net>
References: <1220914847.8074.81.camel@localhost.localdomain>
	<20080908.160441.124972717.davem@davemloft.net>
	<200809081629.21125.david-b@pacbell.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>
Date: Mon, 8 Sep 2008 16:29:20 -0700

> That said, there's a bit of unresolved stuff around NTP hooks
> in the kernel.  Some patches are pending to let thtem work with
> the RTC framework -- where writing an RTC may need to sleep,
> for example because the RTC is on an I2C or SPI bus.  And
> then there's the discussion of whether that shouldn't all be
> handled by NTPD anyway, no special kernel support desired.
> Alessandro has opinions there.  ;)

My update_persistent_clock() on sparc64 is:

int update_persistent_clock(struct timespec now)
{
	struct rtc_device *rtc = rtc_class_open("rtc0");

	if (rtc)
		return rtc_set_mmss(rtc, now.tv_sec);

	return -1;
}

and that should handle this NTP shouldn't it?
