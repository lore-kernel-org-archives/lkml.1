Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbYIIBYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbYIIBYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 21:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYIIBXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 21:23:54 -0400
Received: from ozlabs.org ([203.10.76.45]:38268 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbYIIBXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 21:23:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18629.53224.103107.523514@drongo.ozlabs.ibm.com>
Date: Tue, 9 Sep 2008 11:22:48 +1000
From: Paul Mackerras <paulus@samba.org>
To: David Miller <davem@davemloft.net>
Cc: david-b@pacbell.net, James.Bottomley@hansenpartnership.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
       alessandro.zummo@towertech.it
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
In-Reply-To: <20080908.164427.216880550.davem@davemloft.net>
References: <1220914847.8074.81.camel@localhost.localdomain>
	<20080908.160441.124972717.davem@davemloft.net>
	<200809081629.21125.david-b@pacbell.net>
	<20080908.164427.216880550.davem@davemloft.net>
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:

> int update_persistent_clock(struct timespec now)
> {
> 	struct rtc_device *rtc = rtc_class_open("rtc0");
> 
> 	if (rtc)
> 		return rtc_set_mmss(rtc, now.tv_sec);
> 
> 	return -1;
> }
> 
> and that should handle this NTP shouldn't it?

Yes as long as your rtc set functions don't need to sleep, since
update_persistent_clock is called at interrupt level.  Some powerpc
systems have their RTC at the far end of an I2C bus, and the I2C
access routines can sleep.

Paul.
