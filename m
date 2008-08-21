Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbYHUSnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbYHUSnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbYHUSmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:42:52 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:60101 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbYHUSmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:42:52 -0400
Date: Thu, 21 Aug 2008 20:42:50 +0200
To: adobriyan@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: hwclock problems still present in 2.6.27-rc4
Message-ID: <20080821184250.GG3108@gamma.logic.tuwien.ac.at>
References: <20080821163920.GA19140@gamma.logic.tuwien.ac.at> <20080821165648.GA2732@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821165648.GA2732@x200.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Do, 21 Aug 2008, adobriyan@gmail.com wrote:
> > CONFIG_HPET_TIMER=y
> > CONFIG_HPET_EMULATE_RTC=y
> > CONFIG_HPET=y
> > CONFIG_HPET_MMAP=y
> > CONFIG_RTC_LIB=y
> > CONFIG_RTC_CLASS=y
> > CONFIG_RTC_HCTOSYS=y
> > CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> > CONFIG_RTC_INTF_SYSFS=y
> > CONFIG_RTC_INTF_PROC=y
> > CONFIG_RTC_INTF_DEV=y
> > CONFIG_RTC_DRV_CMOS=y
> > (all rtc and hpet related config vars).
> 
> > What is the recommended way to fix that, or do you need some more
> > information?
> 
> Remove CONFIG_RTC_* options for start. Unless you knowingly selected
> them, of course.

Removing all of them also removes CONFIG_HPET_EMULATE_RTC which makes me
a bit nervous. The reason is:
config HPET_EMULATE_RTC
	def_bool y
	depends on HPET_TIMER && (RTC=y || RTC=m || RTC_DRV_CMOS=m || RTC_DRV_CMOS=y)
so I have to have RTC and RTC_DRV_CMOS turned on.

Is turning of CONFIG_HPET_EMULATE_RTC a good idea? Then I will not have
a rtc at all, right?

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
RAMSGATE (n.)
All institutional buildings must, by law, contain at least twenty
ramsgates. These are doors which open the opposite way to the one you
expect.
			--- Douglas Adams, The Meaning of Liff
