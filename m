Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbYD3Jjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbYD3Jjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbYD3Jjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:39:39 -0400
Received: from mx0.towertech.it ([213.215.222.73]:50717 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751332AbYD3Jji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:39:38 -0400
Date: Wed, 30 Apr 2008 11:39:33 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: David Woodhouse <dwmw2@infradead.org>
Cc: rtc-linux@googlegroups.com, paulus@samba.org,
       <linux-kernel@vger.kernel.org>
Subject: Re: [rtc-linux] Re: [PATCH] RTC class driver for ppc_md RTC
 functions
Message-ID: <20080430113933.14651edc@i1501.lan.towertech.it>
In-Reply-To: <1209380882.25560.127.camel@pmac.infradead.org>
References: <18449.48370.434716.293552@cargo.ozlabs.ibm.com>
	<20080428102629.6e702137@i1501.lan.towertech.it>
	<1209371478.25560.114.camel@pmac.infradead.org>
	<20080428105245.5c9fff85@i1501.lan.towertech.it>
	<1209378191.25560.121.camel@pmac.infradead.org>
	<20080428124033.70e78dcf@i1501.lan.towertech.it>
	<1209380882.25560.127.camel@pmac.infradead.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 12:08:02 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> 
> I suspect that actually covers quite a lot of devices, but the RTC class
> could happily cope with other types of devices too -- just giving an

 If we are talking about milliseconds I think a suspect is not enough.


> infrastructure for them to be notified when NTP comes into sync
> (cf. notify_cmos_timer()) should be sufficient, and after that we can
> leave them to their own devices. We should probably provide the
> common-case 'call me at half past the second' functionality too, though,
> rather than expecting each driver to implement it for itself.

 A common thing is something that can be used on a lot of devices. Given that
 the rtc class support more than 20 drivers and probably more than 30 devices
 and that this "half second" functionality is eventually useful only on one
 I won't call it common.


> >  And I suspect that the RTC of most PCs is pretty useless for
> >  any serious NTP related use.
> 
> RTCs in computers are notoriously unreliable. All the more reason to
> want them updated, when the computer is deriving its time sync from
> elsewhere.


 The hardware RTC does not need to be updated every time the system
 clock is. In fact, as long as the system is running, it's pretty useless.

 Most distributions update the RTC from the system timer on shutdown.

 This kind of update will also be unreliable on any not-memory-mapped
 RTC (think of SPI and I2C) .

 My opinion is that such NTP mode could be removed from the kernel/not
 implemented in rtc class without loosing anything.

 However, there should still be a way to tell the kernel/userspace
 that it is being kept in sync with a reliable time source, but that's
 not related to RTC.


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

