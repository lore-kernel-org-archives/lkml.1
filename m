Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbXCPUmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbXCPUmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbXCPUmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:42:50 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:3757 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbXCPUmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:42:50 -0400
Message-ID: <45FB0148.6050700@rtr.ca>
Date: Fri, 16 Mar 2007 16:42:48 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: John Coppens <john@jcoppens.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Conflict between ide and usb?
References: <20070316154735.6de11eca.john@jcoppens.com> <45FAFCD9.5060207@rtr.ca>
In-Reply-To: <45FAFCD9.5060207@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> John Coppens wrote:
>
>> I installed ueagle-atm, which, by itself, is working fine with an 
>> MT-810 modem.
>>
>> The problem I have, is that when I copy a file from a DVD to harddisk,
>> the internet connection almost dies (it slows down terribly, so much so
>> that established connections actually disconnect, ping looses packets,
>> DNS lookup fails, etc). After copy ends, all returns to normal.
>>
>> The machine is an AMD64, still in x86 mode though. CPU activity is very
>> low during the copy, so it's not a CPU problem. Kernel is 2.6.20.2. APIC
>> is enabled. No error message found in either /var/log/messages or syslog.
>> DVD and HD are on different IDE interfaces.
>>
>> Can anyone suggest where to start looking for a solution?
> ..
>>  16:       2591    1737056   IO-APIC-fasteoi   libata, HDA Intel
>>  17:         41          1   IO-APIC-fasteoi   libata, ehci_hcd:usb2
> ..
> 
> It pretty much has to be an IRQ sharing issue,
> most likely in the USB driver side of the house.

Oh, wait a minute.. that's not the correct IRQ, is it?

Your ueagle-atm must be on this one:

 20:   90833792    3057782   IO-APIC-fasteoi   ohci_hcd:usb1

In which case, it's not likely to be an interrupt sharing issue.
Can you confirm this?

Also, try moving your ueagle-atm to one of the ehci usb ports
and see how that affects things.
