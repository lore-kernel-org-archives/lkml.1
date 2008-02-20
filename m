Return-Path: <linux-kernel-owner+w=401wt.eu-S1765564AbYBTU7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765564AbYBTU7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765605AbYBTU6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:58:38 -0500
Received: from ottmail.xandros.com ([142.46.212.35]:51606 "EHLO
	ottmail.xandros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765755AbYBTU6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:58:36 -0500
X-Greylist: delayed 1060 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2008 15:58:36 EST
Date: Wed, 20 Feb 2008 15:37:28 -0500
From: woodys <woodys@xandros.com>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
cc: rtc-linux@googlegroups.com, galak@kernel.crashing.org,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>, rz@linux-m68k.org
Message-ID: <47BC8F88.80502@xandros.com>
In-Reply-To: <20080220180325.46446675@i1501.lan.towertech.it>
References: <47B18612-66A3-476C-B81C-F2FD11CE9A64@kernel.crashing.org>
References: <20080220180325.46446675@i1501.lan.towertech.it>
Subject: Re: [rtc-linux] state of GEN_RTC vs rtc subsystem
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessandro Zummo wrote:
> On Wed, 20 Feb 2008 10:11:23 -0600
> Kumar Gala <galak@kernel.crashing.org> wrote:
>
>   
>> Is the functionality provided by drivers/char/gen_rtc.c completely  
>> handled by the rtc subsystem in drivers/rtc?
>>
>> I ask for two reasons:
>> 1. should we make it mutually exclusive in Kconfig
>> 2. I've enabled both and get (we'll my defconfig did):
>>     
>
>  They shouldn't be enabled at once. I think a patch 
>  for Kconfig has been recently submitted to give a warning
>  in such a case.
>
>  rtc-cmos should be able to handle the vast majority of x86
>  rtcs out there. 
>
>  The only real open issue is related to the ntp synchronization
>  mode and will be solved only when we can get rid of it :)
>
>   
On ARM genrtc has been arbitrary disabled in Kconfig circa 2.6.19 and 
the change to rtc_cmos it is not 100% transparent (ARM Netwinder, Debian).
If I want to use a current (Etch) hwclock binary - I need genrtc with 
/dev/rtc at 10,135, however new rtc_cmos creates /dev/rtc0 at 254,0.
As a result on new kernels hwclock claims that it is not able to access 
hardware.

However upgrading the util-linux package will (sometime in the 
"unstable" future) solve it, so it is not completely broken... Still, at 
the moment - genrtc seems to be a better solution...

Just my $.02...

Woody Suwalski




