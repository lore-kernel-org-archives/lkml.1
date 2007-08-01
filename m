Return-Path: <linux-kernel-owner+w=401wt.eu-S1764909AbXHASPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764909AbXHASPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbXHASPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:15:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbXHASPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:15:35 -0400
Message-ID: <46B0CDB3.8060505@redhat.com>
Date: Wed, 01 Aug 2007 14:15:15 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pm_trace displays the wrong time from the RTC
References: <46AFA78A.9010904@redhat.com> <200708011747.37932.rjw@sisk.pl>
In-Reply-To: <200708011747.37932.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2007 11:47 AM, Rafael J. Wysocki wrote:
> Sorry for slow response, I've just noticed this thread.
> 
> On Tuesday, 31 July 2007 23:20, Chuck Ebbert wrote:
>> When resuming, systems print this when booted on 07/31/07:
>>
>> Date: 06/31/107
>>
>> /drivers/base/power/trace.c::read_magic_time():
>> 114	get_rtc_time(&time);
>> 115	printk("Time: %2d:%02d:%02d Date: %02d/%02d/%02d\n",
>> 116		time.tm_hour, time.tm_min, time.tm_sec,
>> 117		time.tm_mon, time.tm_mday, time.tm_year);
>>
>> include/asm-generic/rtc.h:
>> 102         /*
>> 103          * Account for differences between how the RTC uses the values
>> 104          * and how they are defined in a struct rtc_time;
>> 105          */
>> 106         if (time->tm_year <= 69)
>> 107                 time->tm_year += 100;
>> 108 
>> 109         time->tm_mon--;
> 
> Do you mean that systems display bad date after resuming if PM_TRACE is set,
> even if /sys/power/pm_trace contains 1 ?
> 
> If that's the case, are they i386 or x86_64?
> 

i386:

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=250238
