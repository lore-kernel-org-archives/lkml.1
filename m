Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbXH1Iau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbXH1Iau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 04:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbXH1Ial
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 04:30:41 -0400
Received: from webmailfront02.ispgateway.de ([80.67.16.112]:51803 "EHLO
	webmailfront02.ispgateway.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754658AbXH1Iaj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 04:30:39 -0400
Message-ID: <20070828102709.sybsmvvdw0o8swo4@webmail.df.eu>
Date: Tue, 28 Aug 2007 10:27:09 +0200
From: Clemens Ladisch <clemens@ladisch.de>
To: Paolo Ornati <ornati@fastwebnet.it>
Cc: "Luck, Tony" <tony.luck@intel.com>, Bob Picco <bob.picco@hp.com>,
       john stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "double" hpet clocksource && hard freeze [bisected]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: domainFACTORY
X-Originating-IP: 213.238.46.206
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luck, Tony wrote:
> [...] Given that the hang went away when you applied the earlier patch, I
> conclude that the drivers/char/hpet.c code is the one that got selected when
> you had two "hpet" entries ... and that there is something wrong with that
> code that doesn't work right on x86_64.

Apparently, the 'generic' code was just copied from ia64 and assumes that the
timer is 64 bits.  This is not true with hardware from VIA (even on x86_64).

This patch should make it work (although I'd prefer to set the mask  
dynamically
according to the hardware caps).

--- a/drivers/char/hpet.c	Tue Aug 28 09:42:22 2007
+++ b/drivers/char/hpet.c	Tue Aug 28 10:16:54 2007
@@ -73,7 +73,7 @@
          .name           = "hpet",
          .rating         = 250,
          .read           = read_hpet,
-        .mask           = CLOCKSOURCE_MASK(64),
+        .mask           = CLOCKSOURCE_MASK(32),
          .mult           = 0, /*to be caluclated*/
          .shift          = 10,
          .flags          = CLOCK_SOURCE_IS_CONTINUOUS,


