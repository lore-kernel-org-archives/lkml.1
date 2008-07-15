Return-Path: <linux-kernel-owner+w=401wt.eu-S1755784AbYGOKnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbYGOKnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 06:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbYGOKnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 06:43:16 -0400
Received: from kuber.nabble.com ([216.139.236.158]:36747 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbYGOKnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 06:43:16 -0400
Message-ID: <18462244.post@talk.nabble.com>
Date: Tue, 15 Jul 2008 03:43:14 -0700 (PDT)
From: Hebbar <gururajakr@sanyo.co.in>
To: linux-kernel@vger.kernel.org
Subject: need help to enable ARM AMBA PL031 RTC
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: gururajakr@sanyo.co.in
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I all,

I am working on customized arm versatile board and i am trying to use ARM
AMBA PL031 RTC.

 i enabled CONFIG_RTC_DRV_PL031=y

But the date never changes or updates. 

/ # cat /sys/class/rtc/rtc0/time
00:00:00

When i went through the Ref Manual of ARM AMBA PL031 RTC i found that we
need to enable or set high to RTC START bit (bit 0) in RTC Control Register
( 0x0C ).

but in  rtc-pl031.c, RTC_START is no where set in RTC CONTROL Register.

I think we need to enable it in rtc_probe func after rtc_device_register
returns success.

#define RTC_CR_MIE	(1 << 0)

__raw_writel(RTC_CR_MIE, ldata->base + RTC_CR);

Kindly Comment.

Regards
Gururaja


-- 
View this message in context: http://www.nabble.com/need-help-to-enable-ARM-AMBA-PL031-RTC-tp18462244p18462244.html
Sent from the linux-kernel mailing list archive at Nabble.com.

