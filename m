Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbYCZTWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbYCZTWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 15:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYCZTVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 15:21:51 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:23782 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbYCZTVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 15:21:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=CV/otroItcodFnO4faD4Fdzqsq36c+LNpYhblDrPiuu3JHsACP8M9wJ9dwgYBTH7DaTcRuO+U+/RoLXaVXF87Q7HFutZtaovk03eXtcUQe5azRgdK3xJzTvqBDF0W3kjX8eUZ7+yQUBe27SXdhzEntSRpDO/LPbJ6oT8Iq/7IZE=
Message-ID: <47EAA246.3050707@gmail.com>
Date: Wed, 26 Mar 2008 22:21:42 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Corentin CHARY <corentincj@iksaif.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: ISA -> ISA_ (Re: [GIT PATCH] ACPI patches for 2.6.25-rc6)
References: <200803180510.47670.lenb@kernel.org> <200803260956.55804.bjorn.helgaas@hp.com> <47EA86D9.7040404@gmail.com> <200803261247.31531.bjorn.helgaas@hp.com>
In-Reply-To: <200803261247.31531.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Wednesday 26 March 2008 11:24:41 am Alexey Starikovskiy wrote:
>   
>> Bjorn Helgaas wrote:
>>     
>>> I'm curious about how this works.  I disassembled the DSDT from
>>> http://bugzilla.kernel.org/show_bug.cgi?id=4773 (I attached the disassembly
>>> at http://bugzilla.kernel.org/attachment.cgi?id=15448&action=view), and
>>> the _PRT contains "_SB" and "ISA" (no trailing underscores):
>>>
>>>                 Package (0x04)
>>>                 {
>>>                     0x000DFFFF, 
>>>                     0x00, 
>>>                     \_SB.PCI0.ISA.LNKA, 
>>>                     0x00
>>>                 }
>>>
>>> But by the time we get to acpi_pci_irq_add_entry(), we've added the
>>> underscores somewhere (see
>>> http://bugzilla.kernel.org/attachment.cgi?id=15423&action=view):
>>>
>>>   0000:00:0d[A] -> \_SB_.PCI0.ISA_.LNKA
>>>
>>> I don't know where this happens, but it certainly confused me, and
>>> it seems like it could lead to other bugs.
>>>   
>>>       
>> ACPI is supposed to add trailing underscore for pad all names to 4 bytes.
>> So ISA will be padded to ISA_.
>>     
>
> The questions are "where does this happen?" and "why does it not
> apply to other things like asus_acpi.c?"
>   
1. drivers/acpi/namespace/nsutils.c:419
