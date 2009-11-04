Return-Path: <linux-kernel-owner+w=401wt.eu-S1751132AbZKDFSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132AbZKDFSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 00:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbZKDFSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 00:18:46 -0500
Received: from mail.infogain.com ([65.223.106.147]:22843 "EHLO
	mail.infogain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZKDFSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 00:18:45 -0500
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Nov 2009 00:18:45 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: why kernel implement "udelay" by cpu instructions?
Date: Wed, 4 Nov 2009 10:31:17 +0530
Message-ID: <C86899CCB10A6C4E93D5978DCB232D4B0D754B62@GDCMX01.igglobal.com>
In-Reply-To: <3a665c760911031819t2fef1720q3e2f542a2e56a3d0@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: why kernel implement "udelay" by cpu instructions?
Thread-Index: Acpc9qBQ54Ivw4uKROO0ii5kbS9pEQAFDXmA
References: <3a665c760911011913q268b010cqb5da4f79df995b9b@mail.gmail.com> <4AEE63E2.9010003@redhat.com> <3a665c760911031819t2fef1720q3e2f542a2e56a3d0@mail.gmail.com>
From: "Rajat Jain" <Rajat.Jain@infogain.com>
To: "loody" <miloody@gmail.com>, "Rik van Riel" <riel@redhat.com>
Cc: <linux-kernel@vger.kernel.org>,
       "Kernel Newbies" <kernelnewbies@nl.linux.org>
X-OriginalArrivalTime: 04 Nov 2009 05:01:55.0462 (UTC) FILETIME=[EE20A260:01CA5D0B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I find something interesting; kernel has msleep, but it
> doesn't have usleep.
> Does that mean the minimum time kernel can react is msecond
> instead of usecond?
> so if  users want to count useconds, they have to do the busy waiting,
> execute some looping assembly instructions?

You are roughly right. If you don't want to busy loop (udelay / mdelay), then you will have to sleep. The granularity of this sleep depends on how frequently the timer interrupt ticks (HZ). Thus if HZ is 1000, then you cannot sleep for a period less than 1 msec.

> 
> If my consumption is correct, where I can find the evidence?
> BTW, does Hz has anything related to kernel timing?
> From the comment in the kernel, it says
> Hz: clock ticks generated per second
> Does that mean the kernel will get #Hz timer interrupts per second?

Yes.

> Whz the value of Hz is 100? if the minimum reaction time of kernel is
> msecond, the value of Hz should be 1000, right? 

Default value of HZ depends on the architecture - and you can change it as well. If HZ is 100, then minimum sleep is 10 ms. If you call msleep(1), you will still sleep for 10 msec atleast - msleep() only guarantees that you will sleep for ATLEAST the time you specified - you may obviously sleep for longer.

>> 
>> At bootup the kernel measures the delay loop speed of
>> each CPU.  CPU frequency scaling might make the loop
> 
> would you please let me know where the source code is?
> (measuring loop speed of cpu and scale cpu frequency)

calibrate_delay()


Thanks,

Rajat
