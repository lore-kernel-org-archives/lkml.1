Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZDOOds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZDOOds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbZDOOdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:33:37 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:55974 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbZDOOdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=x/hhlGUL91jX0WA5srYRa5naZx7leceQMsPEt3ruNuNtAz4OGYDOhzUGJkQlQ8cuB8
         QN0183k8eNKEooFxPSZzRUaLPDcPWjF2nlvogrMLZcoLY4xL+KHyDhE8lQ9V4oUmOquO
         yB4RHnI8NrSje4wNXCbr9G2jw/0h2lGkVzF/k=
Message-ID: <49E5F01B.2060201@tuffmail.co.uk>
Date: Wed, 15 Apr 2009 15:32:59 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Arjan van de Ven <arjan@infradead.org>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [FIXED] EEE PC hangs when booting off battery
References: <49E065CF.6040408@tuffmail.co.uk> <200904140859.02188.bjorn.helgaas@hp.com> <20090414081728.10de978a@infradead.org> <200904140948.37633.bjorn.helgaas@hp.com>
In-Reply-To: <200904140948.37633.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Tuesday 14 April 2009 09:17:28 am Arjan van de Ven wrote:
>   
>> On Tue, 14 Apr 2009 08:59:01 -0600
>> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>>
>>     
>>> I can't help with the real problem of why the asynchronous battery
>>> init causes the hang.
>>>       
>> that got fixed already for the module case.
>>     
>
> But apparently still broken for the builtin case?  I think Alan is
> running pretty new bits -- he said "latest git" on April 11.
>   

It's now fixed, in 2.6.30-rc2.  My battery is modular btw.  I suspect

5d38258ec026921a7b266f4047ebeaa75db358e5 "ACPI battery: fix async boot
oops" [removal of __init]

was not sufficient to fix my problem, but it was solved by the "real" fix,

d6de2c80e9d758d2e36c21699117db6178c0f517 "async: Fix module loading
async-work regression" [module loading waits on async work]


I would argue there's still a question over why the asynchronous battery
init (_with_ the oops fix) should cause a hang in the idle routine.  But
since the regression is fixed, it's not exactly an urgent question.

Thanks
Alan
