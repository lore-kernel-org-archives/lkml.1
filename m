Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbXIGTeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbXIGTeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 15:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbXIGTeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 15:34:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758161AbXIGTeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 15:34:17 -0400
Message-ID: <46E1A7B5.6000104@redhat.com>
Date: Fri, 07 Sep 2007 15:34:13 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why do so many machines need "noapic"?
References: <46DF3BFF.9000809@redhat.com> <p73veao9gih.fsf@bingen.suse.de>
In-Reply-To: <p73veao9gih.fsf@bingen.suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2007 07:31 AM, Andi Kleen wrote:
> Chuck Ebbert <cebbert@redhat.com> writes:
> 
>> Some systems lock up without the noapic option.
> 
> Please find patterns: cpu type, chipsets, mainboard vendors etc.
> 

This is the first one I've actually had in front of me:

  HP TX1000 notebook
  Nvidia C51/MCP51 mobile chipset

Booting with "noapic" gives some very strange results. This is two
snapshots of /proc/interrupts taken one second apart. It almost looks
like timer interrupts are occurring on IRQ 0 and IRQ7 on different
CPUs:

           CPU0       CPU1       
  0:     446096       6224    XT-PIC-XT        timer
  1:        342          6    XT-PIC-XT        i8042
  2:          0          0    XT-PIC-XT        cascade
  5:       3099        865    XT-PIC-XT        sata_nv
  7:       8145     494718    XT-PIC-XT        ehci_hcd:usb2
  8:          0          0    XT-PIC-XT        rtc0
  9:        323          9    XT-PIC-XT        acpi
 10:        136         36    XT-PIC-XT        HDA Intel
 11:      43884       1091    XT-PIC-XT        ohci_hcd:usb1, eth0
 12:        104         19    XT-PIC-XT        i8042
 14:       1011         25    XT-PIC-XT        libata
 15:          0          0    XT-PIC-XT        libata
NMI:          0          0 
LOC:       6212     445951 
ERR:     403241
MIS:          0

           CPU0       CPU1       
  0:     447098       6233    XT-PIC-XT        timer
  1:        343          6    XT-PIC-XT        i8042
  2:          0          0    XT-PIC-XT        cascade
  5:       3100        865    XT-PIC-XT        sata_nv
  7:       8158     495847    XT-PIC-XT        ehci_hcd:usb2
  8:          0          0    XT-PIC-XT        rtc0
  9:        323          9    XT-PIC-XT        acpi
 10:        136         36    XT-PIC-XT        HDA Intel
 11:      43988       1094    XT-PIC-XT        ohci_hcd:usb1, eth0
 12:        104         19    XT-PIC-XT        i8042
 14:       1032         26    XT-PIC-XT        libata
 15:          0          0    XT-PIC-XT        libata
NMI:          0          0 
LOC:       6221     446953 
ERR:     404383
MIS:          0


>> I found one
>> that will freeze while trying to set up the timer interrupt.
>> Passing 'nolapic' makes it freeze just after:
>>
>>    Setting up timer through ExtINT... works
> 
> Always boot with apic=debug
> 

I can't capture the messages. Even when it boots it doesn't last
long enough to get them.

