Return-Path: <linux-kernel-owner+w=401wt.eu-S1763246AbYCZRZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763246AbYCZRZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761169AbYCZRYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:24:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:47294 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760914AbYCZRYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:24:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=iCy0hBKrFM1+4yHLDUydoUTICHA1uDtUl7NfmA7uYrnefyZv6ou1GAuZa4fqycfEMzZKJMO1/ORlpnPDalvqZxJh2pLOg59kMuCSWpgsnCjIGruWBJjDSRoWxOcxR+SGULEsI8R3S7MrUkx36lchccijZk952BXgR6KiWiwwr04=
Message-ID: <47EA86D9.7040404@gmail.com>
Date: Wed, 26 Mar 2008 20:24:41 +0300
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
References: <200803180510.47670.lenb@kernel.org> <20080326081653.GA8247@elte.hu> <200803261132.21448.lenb@kernel.org> <200803260956.55804.bjorn.helgaas@hp.com>
In-Reply-To: <200803260956.55804.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> I'm curious about how this works.  I disassembled the DSDT from
> http://bugzilla.kernel.org/show_bug.cgi?id=4773 (I attached the disassembly
> at http://bugzilla.kernel.org/attachment.cgi?id=15448&action=view), and
> the _PRT contains "_SB" and "ISA" (no trailing underscores):
>
>                 Package (0x04)
>                 {
>                     0x000DFFFF, 
>                     0x00, 
>                     \_SB.PCI0.ISA.LNKA, 
>                     0x00
>                 }
>
> But by the time we get to acpi_pci_irq_add_entry(), we've added the
> underscores somewhere (see
> http://bugzilla.kernel.org/attachment.cgi?id=15423&action=view):
>
>   0000:00:0d[A] -> \_SB_.PCI0.ISA_.LNKA
>
> I don't know where this happens, but it certainly confused me, and
> it seems like it could lead to other bugs.
>   
ACPI is supposed to add trailing underscore for pad all names to 4 bytes.
So ISA will be padded to ISA_.

Regards,
Alex.
