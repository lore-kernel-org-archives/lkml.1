Return-Path: <linux-kernel-owner+w=401wt.eu-S1760850AbXFVSa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850AbXFVSa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbXFVSaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:30:17 -0400
Received: from mail.tpi.com ([198.107.51.143]:4590 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759570AbXFVSaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:30:15 -0400
Message-ID: <467C1569.2010306@canonical.com>
Date: Fri, 22 Jun 2007 12:31:05 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: trenn@suse.de
CC: Thomas Gleixner <tglx@linutronix.de>, Chuck Ebbert <cebbert@redhat.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: ACPI Regression on Dell E1501
References: <467AE7E1.4050805@canonical.com>  <467AF204.3060805@redhat.com>	 <1182462902.3316.105.camel@chaos> <467BC9F8.5000403@canonical.com>	 <467BCC3F.4080405@canonical.com> <1182525150.28514.746.camel@queen.suse.de>
In-Reply-To: <1182525150.28514.746.camel@queen.suse.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger wrote:
> On Fri, 2007-06-22 at 07:18 -0600, Tim Gardner wrote:
>> Tim Gardner wrote:
>>> Thomas Gleixner wrote:
>>>> On Thu, 2007-06-21 at 17:47 -0400, Chuck Ebbert wrote:
>>>>> On 06/21/2007 05:04 PM, Tim Gardner wrote:
>>>>>> Hi,
>>>>>>
>>>>>> Commit e9e2cdb412412326c4827fc78ba27f410d837e6e breaks boot on a Dell
>>>>>> E1501 unless 'acpi=off' is specified (also tried nolapic and nohpet but
>>>>>> it made no substantive difference). This laptop is an 'AMD Turion(tm) 64
>>>>>> X2 Mobile Technology TL-50' CPU, but its booting 32 bit SMP (make
>>>>>> defconfig). No kernel built after this commit works for this platform.
>>>>>>
>>>>>> There is no crash output, it just wedges after 'NET: Registered protocol
>>>>>> family 2'.
>>>>>>
>>>>>> How can I debug this problem?
>>>>> That'll be fun.
>>>>>
>>>>> That's:
>>>>>
>>>>> 	[PATCH] clockevents: i386 drivers
>>>>>
>>>>> [Author cc: added]
>>>> I'm going nuts on this. 
>>>>
>>>> Tim, 
>>>>
>>>> 1.) are you booting a 32bit or a 64 bit kernel ?
>>>>
>>>> 2.) Can you please try 2.6.22-rc5 + 
>>>> http://www.tglx.de/projects/hrtimers/2.6.22-rc5/patch-2.6.22-rc5-hrt1.patch
>>>> 	whether this makes any difference 
>>>>
>>>> Thanks,
>>>>
>>>> 	tglx
>>>>
>>> Thomas,
>>>
>>> Your patch (large though it is) did not make any outward difference. As
>>> usual, adding 'acpi=off' allows it to boot.
>>>
>>> rtg
>> Perhaps I was too hasty. Adding 'acpi=off' did not allow it to boot. The
>> IDE drive was detected, but I did not see any partitions detected.
>> Eventually it dropped to the initrd shell when it could not find a root
>> filesystem. Anyways, this is likely a side issue.
> 
> I am seeing the same with an ACER F5000.
> 
> pci=nomsi let the machine still boot.
> 
> I tried a bit and I think I got it, for me it's this one:
> 
> commit 78b7611c4a1e3ff008abc4751b566cb533d68f3d
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Fri Jun 1 00:46:33 2007 -0700
> 
> My problem: The laptop does not have an serial output device, I try to
> set up a fire wire console, but might have cable/HW problems.
> 
> What else can I do to help?
> What do you need?
> 
> Thanks,
> 
>    Thomas
> 

pci=nomsi has no effect, nor does CONFIG_SMP. Furthermore, I positively
confirmed that this is the offending commit. If I reset HEAD to the
commit just prior, then everything works OK.

rtg
-- 
Tim Gardner tim.gardner@ubuntu.com
