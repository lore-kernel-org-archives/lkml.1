Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbYAWXRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbYAWXRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 18:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYAWXRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 18:17:14 -0500
Received: from slowhand.arndnet.de ([88.198.19.76]:37686 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751536AbYAWXRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 18:17:13 -0500
Message-ID: <4797CB21.8090605@i4.informatik.rwth-aachen.de>
Date: Thu, 24 Jan 2008 00:17:53 +0100
From: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: Willy Tarreau <w@1wt.eu>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Lars Heete <hel@admin.de>,
       Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86: GEODE fix MFGPT input clock value
References: <4795B14C.7040502@i4.informatik.rwth-aachen.de> <200801221111.21240.hel@admin.de> <4795D120.7070806@i4.informatik.rwth-aachen.de> <20080122192757.GC5241@cosmic.amd.com> <47965806.6080903@i4.informatik.rwth-aachen.de> <20080122211014.GA27870@elte.hu> <20080123211746.GA2969@1wt.eu> <20080123211859.GA3081@1wt.eu> <4797B8C4.9060102@zytor.com> <20080123221129.GA27022@1wt.eu> <20080123223830.GA26219@cosmic.amd.com>
In-Reply-To: <20080123223830.GA26219@cosmic.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jordan Crouse schrieb:
> On 23/01/08 23:11 +0100, Willy Tarreau wrote:
>> Hi Peter,
>>
>> On Wed, Jan 23, 2008 at 01:59:32PM -0800, H. Peter Anvin wrote:
>>> Willy Tarreau wrote:
>>>> The GEODE MFGPT code assumed that 32kHz was 32000 Hz while the boards
>>>> run on a 32.768 kHz digital watch crystal. In practise, it will not
>>>> change the timer's frequency as the skew was only 2.4%, but it
>>>> should provide more accurate intervals.
>>>> - *  Divisor   Hz      Min Delta (S) Max Delta (S)
>>> Seconds are "s", not "S" (S = siemens.)
>> You're quite right. Same as we should write kHz and not Khz. But I'm
>> used to change other people's work and particularly comments the least
>> possible. Do you want an update ?
> 
> Please do - I don't mind if you change the comments - better that they
> are right.

While you are on it, please include this one:

--- a/arch/x86/kernel/mfgpt_32.c        2008-01-24 00:08:20.000000000 +0100
+++ b/arch/x86/kernel/mfgpt_32.c        2008-01-24 00:05:17.000000000 +0100
@@ -361,7 +361,7 @@
                        &mfgpt_clockevent);

        printk(KERN_INFO
-              "mfgpt-timer:  registering the MFGT timer as a clock event.\n");
+              "mfgpt-timer:  registering the MFGPT timer as a clock event.\n");
        clockevents_register_device(&mfgpt_clockevent);

        return 0;


> Jordan
> 

Arnd
