Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbYIBJXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbYIBJXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 05:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYIBJW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 05:22:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47070 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbYIBJWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 05:22:54 -0400
Date: Tue, 2 Sep 2008 10:07:28 +0200
From: Pavel Machek <pavel@suse.cz>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Tyan S2923-E suspend to ram fails to resume
Message-ID: <20080902080728.GD15399@elf.ucw.cz>
References: <48977AF7.2070300@simon.arlott.org.uk> <20080808071430.GA10370@ucw.cz> <21f16315cade48d9ecdc87a25b769b9f310fa112@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid> <489DACCE.7050000@simon.arlott.org.uk> <20080812103143.GD2641@elf.ucw.cz> <48B03F0E.9060605@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B03F0E.9060605@simon.arlott.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-08-23 17:47:10, Simon Arlott wrote:
> On 12/08/08 11:31, Pavel Machek wrote:
>> On Sat 2008-08-09 15:42:22, Simon Arlott wrote:
>>> On 08/08/08 12:20, Simon Arlott wrote:
>>>> On Fri, August 8, 2008 08:14, Pavel Machek wrote:
>>>>> On Mon 2008-08-04 22:56:07, Simon Arlott wrote:
>>>>>> My system (Tyan S2923-E, dmesg attached) suspends ok in
>>>>>> all pm_test modes, but it won't resume with pm_test
>>>>>> "none".
>>>>>>
>>>>>> [    6.423515] mem full: hash matches
>>>>>>
>>>>>> When I press the power button, the port 80 display shows:
>>>>>> FF D0 23 01 D0 ... DE
>>>>>> (and again each time I press it)
>>>>>>
>>>>>> If I force it to turn off, then on again:
>>>>>> FF D0 23 01 D0 ... FF D0 23 01 D0 ... (D2?) D3 00 01 D5
>>>>>> D6 <normal boot>
>>>>>>
>>>>>> Any ideas? (onboard SAS is disabled, watchdog is
>>>>>> disabled, everything else is enabled, PCI-E graphics
>>>>>> card)
>>>>>
>>>>> Try verifying if it reaches assembly code under realmode/ ...
>>>
>>> I've tried acpi_sleep=s3_beep, and this:
>>> diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/kernel/acpi/realmode/wakeup.S
>>> Which doesn't work either.
>>
>> Yep, that should work. When it does not, it means BIOS is not
>> returning to our real mode code :-(. You may want to try disabling
>> APIC and similar stuff, in hope of working around BIOS bug you are
>> hitting, but ...
>
> I've tried the simplest possible 32-bit UP kernel I could come up with 
> (.config attached) and it still doesn't work.
>
> (I modified post_init() to call pm_suspend(PM_SUSPEND_MEM).)
>
> Disassembly of the BIOS shows that DE is indeed part of 0xDEAD, but I 
> haven't been able to tell what it's doing between D0 and there... not all 
> of the port 80 codes that are displayed are easily visible.
>
> I've tried disabling all the CPU options in the BIOS, e.g. microcode 
> update, VM, NMI but it doesn't help. I'm wondering if D0 is the right start 
> point for the system - there's a DC code for S3 resume:

...you did a lot of work, but these issues are hard.

Do Windows suspend/resume on same hardware? BSD?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
