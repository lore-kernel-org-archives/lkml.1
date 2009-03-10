Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbZCJJVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbZCJJVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 05:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZCJJVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 05:21:20 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:60796 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752592AbZCJJVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 05:21:19 -0400
Date: Tue, 10 Mar 2009 10:21:14 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Geoff Levand <geoffrey.levand@am.sony.com>
cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       Kyle McMartin <kyle@mcmartin.ca>, rtc-linux@googlegroups.com,
       linux-parisc@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>, Dann Frazier <dannf@dannf.org>
Subject: Re: [PATCH 7/7] powerpc/ps3: Add rtc-ps3
In-Reply-To: <49B5618E.9050501@am.sony.com>
Message-ID: <alpine.LRH.2.00.0903101015470.24318@vixen.sonytel.be>
References: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1236605183-22718-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1236605183-22718-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1236605183-22718-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1236605183-22718-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1236605183-22718-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <1236605183-22718-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <1236605183-22718-8-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <49B5618E.9050501@am.sony.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, Geoff Levand wrote:
> On 03/09/2009 06:26 AM, Geert Uytterhoeven wrote:
> > Create a real RTC driver for PS3, and unhook the deprecated
> > ppc_md.[gs]et_rtc_time.
> 
> >  8 files changed, 132 insertions(+), 18 deletions(-)
> 
> Sorry, I hadn't been following the discussion closely, but
> could you explain why we are going from a generic framework
> where we hook in our platform specific part to a totally
> independent driver that has such an increase in code size.

Alessandro prefers not to have generic RTC drivers on top of some other
abstraction, but wants platform/chip-specific drivers under drivers/rtc/
instead. The goal is to convert all RTC drivers buried in platform code
to separate RTC drivers.

(Alessandro, please correct me if I'm wrong)

> Why couldn't you fix the generic part so that udev could
> load it automatically?

BTW, I also fixed the generic part, which is now called rtc-generic and
autoloaded (patch 4).

> I much prefer to have this code in the platform support
> code as it was.  It is much more effort (a pain) to maintain
> a separate driver were I have to cater to a subsystem's
> maintainer, and with this rtc it seems everyone who was
> using the generic PPC driver will need to do the same.

They can keep on using rtc-generic for now (patch 6).

If you do not want rtc-ps3, you can nak it, and keep on using rtc-generic :-)
But please consider before doing that...

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
