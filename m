Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab0AOBYI (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566Ab0AOBYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:24:07 -0500
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:51460 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456Ab0AOBYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:24:05 -0500
Message-ID: <4B4FC3B0.9070207@blueyonder.co.uk>
Date: Fri, 15 Jan 2010 01:24:00 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.14 Thunderbird/3.0 ThunderBrowse/3.2.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: HDA Intel Audio hang on boot
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.jbH.QNlSLB@chimera> <4B4A9D8F.9030300@blueyonder.co.uk>
In-Reply-To: <4B4A9D8F.9030300@blueyonder.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renaming this bug as the "only 1 CPU" bug has been fixed, but the hang
at HDA remains.
I shall plug in a SB Audigy and see if it will boot with that.
By disabling the on-board HDA Intel audio in the BIOS, the system boots.
tindog:~ # uname -r
2.6.33-rc4-smp
On 2.6.32-git1 which boots, hwinfo shows:-
  oss.card_id = 'HDA NVidia'
  oss.card_id = 'HDA NVidia'
  oss.card_id = 'HDA NVidia'
  alsa.card_id = 'HDA NVidia'
  alsa.card_id = 'HDA NVidia'
  alsa.card_id = 'HDA NVidia'
  alsa.card_id = 'HDA NVidia'
  info.product = 'HDA NVidia ALSA hardware specific Device'
  alsa.card_id = 'HDA NVidia'
  info.product = 'HDA NVidia ALSA Control Device'
  alsa.card_id = 'HDA NVidia'
  info.product = 'HDA NVidia Sound Card'
  sound.card_id = 'HDA NVidia'
  info.linux.driver = 'HDA Intel'
    22:     489835        578   IO-APIC-fasteoi   sata_nv, HDA Intel
       HDA Intel: /devices/pci0000:00/0000:00:0e.1
       HDA Intel: module = snd_hda_intel
irq:0 22 (   490413) "sata_nv" "HDA Intel"
       HDA Intel: /devices/pci0000:00/0000:00:0e.1
       HDA Intel: module = snd_hda_intel
       HDA Intel: /devices/pci0000:00/0000:00:0e.1
       HDA Intel: module = snd_hda_intel
  E: DRIVER=HDA Intel
  <6>HDA Intel 0000:00:0e.1: PCI INT B -> Link[AAZA] -> GSI 22 (level,
low) -> IRQ 22
  <7>HDA Intel 0000:00:0e.1: setting latency timer to 64
  Driver: "HDA Intel"

Regards
Sid.

On 11/01/10 03:39, Sid Boyce wrote:
> On 10/01/10 22:32, Rafael J. Wysocki wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.32.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14946
>> Subject		: All kernels after 2.6.32-git10  show only 1 CPU
>> Submitter	: Sid Boyce <sboyce@blueyonder.co.uk>
>> Date		: 2009-12-23 16:55 (19 days old)
>> References	: http://marc.info/?l=linux-kernel&m=126158734326801&w=4
>>
>>
>>
>>
> 
> With 2.6.33-rc3-git3 I now see 2 CPU's every on a normal boot, but its
> locking up solid at this part of the boot process as usual.
> ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
> HDA Intel 0000:00:0e.1: PCI INT B -> Link[AAZA] -> GSI 22 (level, low)
> -> IRQ 22.
> With acpi=noirq (2 CPU's)
> ================
> kvm: Nested Virtualization enabled.
> IT8716 Super IO detected
> Parport_PC 00:0a: reported by plug and Play ACPI
> Parport 0: PC-Style at 0x378, irq 7 [PCSPP, TRISTATE,EPP]
> parport: irq 7 in use, resorting to polled operation
> HDA Intel 0000:00:0e.1: PCI -> APIC IRQ transform: INT B -> IRQ 11
> 
> With acpi=ht (1 CPU)
> =============
> Hangs at:-
> Loading drivees, configuring devices do_IRQ: 0.65 No irq handler for
> vector (irq -1)
> 
> With acpi=off (2 CPU's)
> ========================
> Hangs at same point as with acpi=noirq.
> 
> Regards
> Sid.


-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

