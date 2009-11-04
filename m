Return-Path: <linux-kernel-owner+w=401wt.eu-S1757651AbZKDST2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbZKDST2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbZKDST1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:19:27 -0500
Received: from smtp3.epfl.ch ([128.178.224.226]:50554 "HELO smtp3.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753150AbZKDST0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:19:26 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Nov 2009 13:19:26 EST
Message-ID: <4AF1C423.3010407@epfl.ch>
Date: Wed, 04 Nov 2009 19:12:51 +0100
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [PATCH] [RTC] Add Freescale MC13783 RTC driver
References: <1256330323-13300-1-git-send-email-u.kleine-koenig@pengutronix.de> <1256373342-5294-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091101203443.GB18116@pengutronix.de>
In-Reply-To: <20091101203443.GB18116@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

Uwe Kleine-König wrote:
> Hello,
> 
> On Sat, Oct 24, 2009 at 10:35:42AM +0200, Uwe Kleine-König wrote:
>> This driver provides support for the RTC part integrated into the
>> Freescale MC13783 PMIC and bases on patch created earlier by Sascha
>> Hauer.
>>
>> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
>> Signed-off-by: Uwe Kleine-König <u.kleine-könig@pengutronix.de>
>> Cc: Valentin Longchamp <valentin.longchamp@epfl.ch>
>> Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
>> Cc: Alessandro Zummo <a.zummo@towertech.it>
>> Cc: rtc-linux@googlegroups.com
>> ---
>> Hello,
>>
>> this patch depends on
>>
>> 	mfd/mc13783: near complete rewrite
>>
>> sent earlier on lkml[1].  Compared to the earlier version of rtc support
>> on mc13783 as sent by Sascha, this driver got reset detection and
>> therefore depends on the patch above.
>>
>> A tree runnable on Phytec's PCM038 is available in my git tree
>>
>> 	git://git.pengutronix.de/git/ukl/linux-2.6.git mc13783
>>
>> .  (Maybe I will rewrite these commits, so please expect it might change
>> in a non-fast-forward manner.)
> 
> Valentin, could you already test this?  Any comments by the others?
> 

I have tested your patches (taken your mc13783 branch today, and merged 
it into my patches rebased on 2.6.32-rc6).

Your mfd/mc13783 rewrite seems to work for me (but since there is no 
real usage for now, I don't use ADC yet and regulator don't do a lot). 
But it runs fine on my hardware.

However, I get the hctosys: unable to read the hardware clock error 
message at boot (from drivers/rtc/hctosys.c:62). Is it normal ?

Furthermore, the date and time are saved during system off, but the time 
is not updated: if I shut down the system during 10 minutes, my time 
will get a 10 minute delay. Is this a normal behavior with you current 
implementation or is there something we have wrong in our design/code 
(we have battery for the mc13783) ? I will have a further look at this 
later, didn't have time now.

Val

-- 
Valentin Longchamp, PhD Student, EPFL-STI-LSRO1
valentin.longchamp@epfl.ch, Phone: +41216937827
http://people.epfl.ch/valentin.longchamp
MEA3485, Station 9, CH-1015 Lausanne
