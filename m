Return-Path: <linux-kernel-owner+w=401wt.eu-S1751155AbZDLPyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155AbZDLPyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 11:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750730AbZDLPyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 11:54:40 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48092 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZDLPyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 11:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Udos/THLCUd0Jdp8qRYdP49khBHPFvAToIDmEadxia9MVR6Tm+DUkNuuipr4waSH9U
         fTkWN3WnJRgNpa/ZeN2qQ06KL8VNtxMdE0IEvtpoqE3NyjME4gHu5KreBXyXZIvB3qTO
         jOYBzZSDPJrc988jfjGRH+jDjMFx7JLVDWq4k=
Message-ID: <49E20EBA.2090708@tuffmail.co.uk>
Date: Sun, 12 Apr 2009 16:54:34 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Alexey Starikovskiy <aystarik@gmail.com>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: [BISECTED] 20 ACPI interrupts per second on EEEPC 4G
References: <49DF6835.9040501@tuffmail.co.uk> <49DFE345.3010109@gmail.com> <49E05F83.2090500@tuffmail.co.uk>
In-Reply-To: <49E05F83.2090500@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Alexey Starikovskiy wrote:
>> Alan Jenkins wrote:
>>> On latest git, powertop shows 20 ACPI interrupts per second. 
>>> Previously, this was closer to 1 per second.  See attached output (a
>>> vs b, "a" is from 2.6.29-rc8).
>>>
>>> This is from a pretty sparse KDE desktop.  Normally I run
>>> gnome-power-manager, but I killed it to make sure that wasn't
>>> causing any problems.
>>>
>
>>> gpe18:   60975  enabled
>>> gpe_all:   60975
>>> sci:   60975
>>>
>>> which I presume means lots of EC interrupts.
>>>
>>> [    0.134068] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66,
>>> data = 0x62
>>>
>
>> This patch looks to be a suspect:
>> 34ff4dbccccce54c83b1234d39b7ad9e548a75dd,
>> Please check if reversing it helps
>
> No, I still get 20 ACPI interrupts per second.
>
> I tried without powertop, just in case that was provoking it, but it
> still happens:
>
> alan@alan-eeepc:/sys/firmware/acpi/interrupts$ cat sci; sleep 5; cat sci
>    2583
>    2680

I did wonder whether this was due to thermal polling.  So look what I
found with bisection :-).


b1569e99c795bf83b4ddf41c4f1c42761ab7f75e is first bad commit
commit b1569e99c795bf83b4ddf41c4f1c42761ab7f75e
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Wed Dec 3 17:55:32 2008 +0000

    ACPI: move thermal trip handling to generic thermal layer

    The ACPI code currently carries its own thermal trip handling,
meaning that
    any other thermal implementation will need to reimplement it. Move
the code
    to the generic thermal layer.


Regards
Alan
