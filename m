Return-Path: <linux-kernel-owner+w=401wt.eu-S1751280AbXB0Anz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbXB0Anz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbXB0Anz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:43:55 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:59892 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbXB0Any (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:43:54 -0500
Message-ID: <45E37EB5.7070100@vmware.com>
Date: Mon, 26 Feb 2007 16:43:33 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC] Use para_fill instead of vmi_get_function for APIC ops
References: <45E37617.6050107@codemonkey.ws>
In-Reply-To: <45E37617.6050107@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Hi Zach,
>
> It seems to me that the APIC paravirt_ops should be filled by 
> para_fill() instead of vmi_get_function().  vmi_get_function() returns 
> a nop when the relocation type is NONE.  para_fill() leaves the native 
> code in place.
>
> The native version of the apic write ops is more or less *(APIC_BASE + 
> reg) = value.  APIC_BASE is unknown to the ROM so it's impossible to 
> simulate this in the ROM.
>
> This means that a ROM has no choice but to do APIC emulation (or jump 
> through seriously hairy loops to get the APIC mapped in it's address 
> space).  Was this the intention?

No, but certainly the effect.  Actually, it is very easy to get the APIC 
mapped in the ROM address space without jumping through seriously hairy 
loops - we do it today in our hypervisor.

>
> N.B. attached patch is just to illustrate the point.  Has not even 
> been compile tested.


Patch looks good, thanks.   But the whole para_fill / vmi_get_function 
stuff could probably be done even cleaner.  It was just a helper at 
first to work around the awkward syntax, and it is still a bit ugly, but 
I haven't come up with a better solution yet, mostly because with the 
new inlining work Jeremy is doing, we might want to start doing 
selective inlining, in which case I'll have to go back over the code 
anyway to clean everything to get the logic right in all cases.

I assume this patch is signed-off-by you?  If so, I'll add it to my 
patch queue.

Zach
