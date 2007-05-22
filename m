Return-Path: <linux-kernel-owner+w=401wt.eu-S965654AbXEVRme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965654AbXEVRme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbXEVRm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:42:27 -0400
Received: from mail.tmr.com ([64.65.253.246]:43784 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757579AbXEVRm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:42:26 -0400
Message-ID: <46532BC1.6010808@tmr.com>
Date: Tue, 22 May 2007 13:43:29 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, mingo@elte.hu,
       yi.zhu@intel.com, linux-kernel@vger.kernel.org, arjan@infradead.org,
       venkatesh.pallipadi@intel.com, trenn@suse.de
Subject: Re: Increased ipw2200 power usage with dynticks
References: <20070518154629.GA27105@atjola.homenet> <20070519171011.GA1995@atjola.homenet> <p733b1re34o.fsf@bingen.suse.de> <20070521074938.GA15678@atjola.homenet>
In-Reply-To: <20070521074938.GA15678@atjola.homenet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Björn Steinbrink wrote:
> On 2007.05.20 20:55:35 +0200, Andi Kleen wrote:
>> Björn Steinbrink <B.Steinbrink@gmx.de> writes:
>>> Ok, it seems that ipw2200 is just a trigger for the problem here. AFAICT
>>> the cause of the worse C state usage is that after ipw2200 has woken the
>>> cpu, acpi_processor_idle() chooses C2 (due to dma? bm? I have no
>>> idea...) as the prefered sleep state. Now without NO_HZ or when I hold
>>> down a key, there are interrupts that wake up the CPU and when
>>> acpi_processor_idle() is called again the promotion to C3/C4 happens.
>>> But with NO_HZ, there are no such interrupts, most wakeups are caused by
>>> ipw2200 and so the processor doesn't go any deeper than C2 most of the
>>> time and thus wastes lots of power.
>> The cpuidle governour code Venki is working on is supposed to address this.
>> There have been also earlier prototype patches by Adam Belay and
>> Thomas Renninger.
> 
> Venki (at least I think it was him) also told me about cpuidle and the
> menu governor on #powertop. Unfortunately, cpuidle seems to be gone from
> acpi-test (or I'm simply still too stupid for git/gitweb). I manually
> added the cpuidle and menu governor patches on top of my 2.6.22-rc1-hrt8
> kernel, but that broke C-state duration accounting.
> 
> On the bright side of things is power usage though, which is down to an
> incredible 13.9W in idle+ipw2200 :)
> 
Very encouraging, hopefully that can get into mainline soon, as power 
usage is an issue with laptops. Until then, it sounds as if dynticks is 
a negative power save for ipw2200 (and probably many other things).

Dare we hope that this will allow use of USB on laptops without draining 
the battery?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

