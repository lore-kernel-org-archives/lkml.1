Return-Path: <linux-kernel-owner+w=401wt.eu-S932716AbXCGEn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716AbXCGEn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 23:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932768AbXCGEn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 23:43:27 -0500
Received: from tag.witbe.net ([81.88.96.48]:47016 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932716AbXCGEn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 23:43:26 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'David Brownell'" <david-b@pacbell.net>
Cc: "'Adrian Bunk'" <bunk@stusta.de>, <linux-kernel@vger.kernel.org>,
       <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>
Subject: RE: 2.6.21-rc2 : Oops in rtc_cmos...
Date: Wed, 7 Mar 2007 05:42:13 +0100
Organization: AS2917.net
Message-ID: <051e01c76072$fcdae290$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <200703061132.29331.david-b@pacbell.net>
Thread-Index: AcdgKnkaLcRhCJGdTXipoZtimkp0ZAAR79fQ
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > Yes, it does, so it's a Good One (tm),
> 
> And points out that $SUBJECT is misleading; the root cause of
> the oops isn't rtc_cmos.  Workaround, don't enable the legacy
> driver for this hardware.

Well, sorry for that, but my point was that without enabling
CONFIG_DRV_RTC_CMOS and only using CONFIG_RTC, my dmesg says :

drivers/rtc/hctosys.c: unable to open rtc device (rtc0)

Having seem that, I got thru all the options, trying to find what I
could have forgot as an option, and added the RTC_CMOS one, that resulted
in an Oops... 

> One of the good things about getting rtc-cmos merged:  it
> exposes this new RTC framework to new mistakes, which helps
> fix some of the remaining rough spots.  

Good ;)
 
> > pnp: Device 00:03 does not support disabling.
> 
> Blame the PNP stack for that particular useless message.
> I'l send a fix for that one too.
OK, ready to test ! 

> > drivers/rtc/hctosys.c: unable to open rtc device (rtc0) 
> Because probing 00:03 failed, was never fully usable.
> So then rtc0 couldn't be found.  You'd get the same
> message if, say, the RTC was loaded as a module.

It seems to me that the DRV_RTC_CMOS and the "standard" CONFIG_RTC
shouldn't be used at the same time... Am I correct on that ? 
Wouldn't it be better to have this dependancy enforced ?

Regards,
Paul

