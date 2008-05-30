Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbYE3Wp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbYE3Wp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbYE3Wps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:45:48 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:30734 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752333AbYE3Wpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:45:47 -0400
X-BigFish: VPS-32(zz1432R98dR7efV1805M873fnzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <48408394.8000406@am.sony.com>
Date: Fri, 30 May 2008 15:45:40 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alessandro Zummo <alessandro.zummo@towertech.it>
CC: rtc-linux@googlegroups.com, linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       rz@linux-m68k.org, LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [rtc-linux] state of GEN_RTC vs rtc subsystem
References: <47B18612-66A3-476C-B81C-F2FD11CE9A64@kernel.crashing.org> <20080220180325.46446675@i1501.lan.towertech.it>
In-Reply-To: <20080220180325.46446675@i1501.lan.towertech.it>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 May 2008 22:45:41.0148 (UTC) FILETIME=[E3282DC0:01C8C2A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessandro Zummo wrote:
> On Wed, 20 Feb 2008 10:11:23 -0600
> Kumar Gala <galak@kernel.crashing.org> wrote:
> 
>> 
>> Is the functionality provided by drivers/char/gen_rtc.c completely  
>> handled by the rtc subsystem in drivers/rtc?
>> 
>> I ask for two reasons:
>> 1. should we make it mutually exclusive in Kconfig
>> 2. I've enabled both and get (we'll my defconfig did):
> 
>  They shouldn't be enabled at once. I think a patch 
>  for Kconfig has been recently submitted to give a warning
>  in such a case.
> 
>  rtc-cmos should be able to handle the vast majority of x86
>  rtcs out there. 

gen_rtc was hooked up to the powerpc platform
ppc_md.set_rtc_time and ppc_md.get_rtc_time via the arch
specific get_rtc_time() and  set_rtc_time() routines.

>From what I can tell, those generic rtc routines the powerpc
arch provides are not properly hooked into the new rtc subsystem.
This causes problems for multi-platform builds where some platforms
must use gen_rtc, and some must the new rtc subsytem.

-Geoff


