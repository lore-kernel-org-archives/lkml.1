Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbZDVMRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbZDVMRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 08:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZDVMRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 08:17:11 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:64219 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZDVMRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 08:17:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Faj/0/49cIGyZ+eqY1pLv/qefRjP+y/ghJ7XAcnGOy5FI8OkqBIxjdUP5oQjKO+xAQ
         tHSVgZwceuejxqN1S6WU2uCAc8GHfVK9nPy9LNMOjdbG63Lr3nzTRKMW/yEluPIK7S0E
         MqVQd9OycWgtYd4UkQRjfRDpEAwSKTKshjtcs=
Message-ID: <49EF0ABD.2080801@tuffmail.co.uk>
Date: Wed, 22 Apr 2009 13:17:01 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [FIXED] EEE PC hangs when booting off battery
References: <49E065CF.6040408@tuffmail.co.uk> <200904140859.02188.bjorn.helgaas@hp.com> <20090414081728.10de978a@infradead.org> <200904140948.37633.bjorn.helgaas@hp.com> <49E5F01B.2060201@tuffmail.co.uk>
In-Reply-To: <49E5F01B.2060201@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Bjorn Helgaas wrote:
>   
>> On Tuesday 14 April 2009 09:17:28 am Arjan van de Ven wrote:
>>   
>>     
>>> On Tue, 14 Apr 2009 08:59:01 -0600
>>> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>>>
>>>     
>>>       
>>>> I can't help with the real problem of why the asynchronous battery
>>>> init causes the hang.
>>>>       
>>>>         
>>> that got fixed already for the module case.
>>>     
>>>       
>> But apparently still broken for the builtin case?  I think Alan is
>> running pretty new bits -- he said "latest git" on April 11.
>>   
>>     
>
> It's now fixed, in 2.6.30-rc2.  My battery is modular btw.  I suspect
>
> 5d38258ec026921a7b266f4047ebeaa75db358e5 "ACPI battery: fix async boot
> oops" [removal of __init]
>
> was not sufficient to fix my problem, but it was solved by the "real" fix,
>
> d6de2c80e9d758d2e36c21699117db6178c0f517 "async: Fix module loading
> async-work regression" [module loading waits on async work]
>
>
> I would argue there's still a question over why the asynchronous battery
> init (_with_ the oops fix) should cause a hang in the idle routine.  But
> since the regression is fixed, it's not exactly an urgent question.
>   

Ugh.  Recently I tried building the battery driver into the kernel, to
benefit from the async work.  Later, I tried booting from the battery
and it hung again.

This time, the kernel did not even respond to SysRq.  I tried
nmi_watchdog=1 and waiting 2 minutes, but the watchdog didn't trigger
either.  As before, it doesn't happen with acpi=off.

I checked that this still happened in todays rc3, and it doesn't happen
if I revert

0f66af530116e9f4dd97f328d91718b56a6fc5a4 "ACPI: battery: asynchronous init"

Regards
Alan
