Return-Path: <linux-kernel-owner+w=401wt.eu-S965737AbXCPUX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965737AbXCPUX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965882AbXCPUX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:23:56 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:2095 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965737AbXCPUXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:23:55 -0400
Message-ID: <45FAFCD9.5060207@rtr.ca>
Date: Fri, 16 Mar 2007 16:23:53 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: John Coppens <john@jcoppens.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Conflict between ide and usb?
References: <20070316154735.6de11eca.john@jcoppens.com>
In-Reply-To: <20070316154735.6de11eca.john@jcoppens.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Coppens wrote:
> Hi all.
> 
> I installed ueagle-atm, which, by itself, is working fine with an 
> MT-810 modem.
> 
> The problem I have, is that when I copy a file from a DVD to harddisk,
> the internet connection almost dies (it slows down terribly, so much so
> that established connections actually disconnect, ping looses packets,
> DNS lookup fails, etc). After copy ends, all returns to normal.
> 
> The machine is an AMD64, still in x86 mode though. CPU activity is very
> low during the copy, so it's not a CPU problem. Kernel is 2.6.20.2. APIC
> is enabled. No error message found in either /var/log/messages or syslog.
> DVD and HD are on different IDE interfaces.
> 
> Can anyone suggest where to start looking for a solution?
..
>  16:       2591    1737056   IO-APIC-fasteoi   libata, HDA Intel
>  17:         41          1   IO-APIC-fasteoi   libata, ehci_hcd:usb2
..

It pretty much has to be an IRQ sharing issue,
most likely in the USB driver side of the house.

I don't know enough about the USB drivers really,
but the interrupt routine inside the ueagle-atm.c file
doesn't seem too "sharing friendly".  But perhaps that
part is handled by the layers above (?).

That's where I'd start looking if I were you.

-ml
