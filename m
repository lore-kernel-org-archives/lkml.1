Return-Path: <linux-kernel-owner+w=401wt.eu-S1763710AbXIMQi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763710AbXIMQi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbXIMQit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:38:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbXIMQis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:38:48 -0400
Message-ID: <46E96792.5000607@redhat.com>
Date: Thu, 13 Sep 2007 12:38:42 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Prakash Punnoor <prakash@punnoor.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why do so many machines need "noapic"?
References: <46DF3BFF.9000809@redhat.com> <p73veao9gih.fsf@bingen.suse.de> <46E1A7B5.6000104@redhat.com> <200709080717.58271.prakash@punnoor.de> <46E59716.6020404@redhat.com> <20070910194421.GA1819@one.firstfloor.org>
In-Reply-To: <20070910194421.GA1819@one.firstfloor.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2007 03:44 PM, Andi Kleen wrote:
>> Yes, it has an hpet. And I tried every combination of options I could
>> think of.
> 
>> But, even stranger, x86_64 works (only i386 fails.)
> 
> x86-64 has quite different time code (at least until the dyntick patches
> currently in mm) 
> 
> Obvious thing would be to diff the boot messages and see if anything
> jumps out (e.g. in interrupt routing).  
> 
> Or check with mm and if x86-64 is broken there too then it's likely
> the new time code.

I reported too soon that x86_64 works. It does not work, it just takes
a bit longer before it freezes. There are message threads all over the
place discussing this problem with the HP Pavilion tx 1000, and it seems
the best workaround is to use the "nolapic" option instead of "noapic".
Using that, it is totally stable _and_ there are no spurious interrupts
that would otherwise break USB. Interrupt setup is a bit strange, though:

           CPU0       CPU1       
  0:        241          0    XT-PIC-XT        timer
  1:          1        736   IO-APIC-edge      i8042
  2:          0          0    XT-PIC-XT        cascade
  5:         14      10028   IO-APIC-edge      sata_nv
  7:          0         57   IO-APIC-edge      ehci_hcd:usb1
  8:          0          0   IO-APIC-edge      rtc0
  9:          4       2463   IO-APIC-edge      acpi
 10:          2       2795   IO-APIC-edge      HDA Intel
 11:        740     478806   IO-APIC-edge      ohci_hcd:usb2, eth0
 12:         42      19911   IO-APIC-edge      i8042
 14:          5       7958   IO-APIC-edge      libata
 15:          0          0   IO-APIC-edge      libata
NMI:          0          0 
LOC:    4617310    4617213 
ERR:          0
