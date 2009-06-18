Return-Path: <linux-kernel-owner+w=401wt.eu-S1760639AbZFRK7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639AbZFRK7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 06:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbZFRK7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 06:59:06 -0400
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:33830 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbZFRK7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 06:59:05 -0400
References: <20090604211103.4214303f.peter@piie.net> <cone.1245086149.988051.6046.1000@deskpiie> <20090616060107.GA4752@liondog.tnic> <200906160747.04094.edt@aei.ca> <20090616205747.GA6356@rhlx01.hs-esslingen.de> <20090617001435.e2d86780.peter@piie.net> <20090617122022.GA13141@rhlx01.hs-esslingen.de> <cone.1245309039.632882.31537.1000@arca> <9ea470500906180329w7c8975b0ra60fa219221d53f6@mail.gmail.com>
Message-ID: <cone.1245322548.289821.31537.1000@arca>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Andreas Mohr <andi@lisas.de>, Ed Tomlinson <edt@aei.ca>,
       akpm@linux-foundation.org, Len Brown <len.brown@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Request driver inclusion - acer aspire one fan control
Date: Thu, 18 Jun 2009 12:55:48 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov writes:

> Hi,
> 
> On Thu, Jun 18, 2009 at 9:10 AM, Peter Feuerer<peter@piie.net> wrote:
>> Hi Andreas, Hi Boris,
>>
>> Andreas Mohr writes:
>>
>>>> o suspend stops and resume starts the kernelmode in a clean way
>>>
>>> Didn't someone argue that pre_suspend_kernelmode was unnecessary?
>>> It's still in there. (could be submitted together with the
>>> Kconfig ACPI depends ;)
>>
>> Actually I think pre_suspend_kernelmode is needed, so it won't be dropped.
> 
> and it is needed, because...?

It's needed because we do now a clean revert to bios mode before we suspend. 
And after resume we have to switch to kernelmode again, if the driver 
was in kernelmode before suspend. So we need to keep track of in what state 
the driver was before suspending. That's what's this variable is for.

>> I'll add the ACPI dependency to Kconfig and submit the patch to lkml
>> and directly to Linus, as Len doesn't seem to react?! - Boris what do
>> you think? I mean, even if there's a problem with suspend / resume,
>> this can also be fixed after the merge window, while all those release
>> candidates are done.
> 
> Nope, this has to be fixed before submission. The merge window is open,
> I think, until mid next week so there's plenty of time.

I'll be only there until Sunday evening. I'm going to be on business trip 
starting on Monday (and returning probably at Saturday). But I'll do my best 
to figure out the problem.

I wasn't able to reproduce the suspend / resume problem Andreas has 
with acerhdf 0.5.9 yesterday and the day before. Do you also have the 
problem, that acerhdf is reading sometimes an unexpected Fan state after 
resuming?

kind regards,
--peter
