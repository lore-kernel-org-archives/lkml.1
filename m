Return-Path: <linux-kernel-owner+w=401wt.eu-S934343AbXC2Vnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934343AbXC2Vnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 17:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934345AbXC2Vnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 17:43:31 -0400
Received: from mail.chilan.com ([82.160.212.9]:42262 "EHLO mail.chilan.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934343AbXC2Vn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 17:43:29 -0400
From: "Grzegorz Chwesewicz" <grzegorz.chwesewicz@chilan.com>
To: Andi Kleen <ak@suse.de>, "Mark Langsdorf" <mark.langsdorf@amd.com>
Cc: "Len Brown" <lenb@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Morrow, William" <William.Morrow@amd.com>,
       "Crouse, Jordan" <jordan.crouse@ldcmail.amd.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Pavel Machek" <pavel@ucw.cz>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Mingming Cao" <cmm@us.ibm.com>, "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       "Oliver Pinter" <oliver.pntr@gmail.com>,
       "Sid Boyce" <g3vbv@blueyonder.co.uk>, "Nick Piggin" <npiggin@suse.de>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Renninger" <trenn@suse.de>
Subject: Re: [PATCH] i386: add command line option "local_apic_timer_c2_ok"
Date: Thu, 29 Mar 2007 23:43:28 +0200
Message-Id: <20070329214316.M53680@chilan.com>
In-Reply-To: <200703292249.37979.ak@suse.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <p73d52s2dvi.fsf@bingen.suse.de> <460C1B5B.4090802@amd.com> <200703292249.37979.ak@suse.de>
X-Mailer: OpenWebMail 2.52 20061019
X-OriginatingIP: 82.160.213.5 (ceho)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007 22:49:37 +0200, Andi Kleen wrote
> > Reviewed but not tested.  Needs to be wrapped in an AMD specific
> > call.
> 
> Here's a patch. I don't have a system with C1E, so i only tested that
> the apic timer still works on a older AMD box.
> 
> Would be good if someone with a Turion laptop, especially the HP nx6325
> could test it with CONFIG_NO_HZ enabled.

I have nx6325 with Turion.

ensima-hp linux-2.6 # cat .config|grep NO_HZ
CONFIG_NO_HZ=y

After patching system works ok on battery and on AC.

On battery:

cat /proc/interrupts

           CPU0       CPU1
  0:     115771          0  local-APIC-edge-fasteoi   timer
  1:        508          1   IO-APIC-edge      i8042
  8:          1          1   IO-APIC-edge      rtc
 12:        147          2   IO-APIC-edge      i8042
 14:         36          1   IO-APIC-edge      ide0
 16:          0          1   IO-APIC-fasteoi   yenta, sdhci:slot0
 17:       4538        116   IO-APIC-fasteoi   eth0
 18:       1697          6   IO-APIC-fasteoi   libata, HDA Intel
 19:         50          1   IO-APIC-fasteoi   ohci_hcd:usb1, ohci_hcd:usb2,
ehci_hcd:usb3
 21:         30          9   IO-APIC-fasteoi   acpi
NMI:          0          0
LOC:          0     115601
ERR:          1
MIS:          0

sleep 10

           CPU0       CPU1
  0:     125777          0  local-APIC-edge-fasteoi   timer
  1:        509          1   IO-APIC-edge      i8042
  8:          1          1   IO-APIC-edge      rtc
 12:        147          2   IO-APIC-edge      i8042
 14:         36          1   IO-APIC-edge      ide0
 16:          0          1   IO-APIC-fasteoi   yenta, sdhci:slot0
 17:       4749        116   IO-APIC-fasteoi   eth0
 18:       1704          6   IO-APIC-fasteoi   libata, HDA Intel
 19:         50          1   IO-APIC-fasteoi   ohci_hcd:usb1, ohci_hcd:usb2,
ehci_hcd:usb3
 21:         30          9   IO-APIC-fasteoi   acpi
NMI:          0          0
LOC:          0     125607
ERR:          1
MIS:          0

#######################################

On AC:

cat /proc/interrupts

           CPU0       CPU1
  0:        261          0  local-APIC-edge-fasteoi   timer
  1:        346          1   IO-APIC-edge      i8042
  8:          1          1   IO-APIC-edge      rtc
 12:        147          2   IO-APIC-edge      i8042
 14:         36          1   IO-APIC-edge      ide0
 16:          0          1   IO-APIC-fasteoi   yenta, sdhci:slot0
 17:       1135        115   IO-APIC-fasteoi   eth0
 18:       1620          6   IO-APIC-fasteoi   libata, HDA Intel
 19:         50          1   IO-APIC-fasteoi   ohci_hcd:usb1, ehci_hcd:usb2,
ohci_hcd:usb3
 21:         24          9   IO-APIC-fasteoi   acpi
NMI:          0          0
LOC:       7562       9007
ERR:          0
MIS:          0

sleep 10

           CPU0       CPU1
  0:        261          0  local-APIC-edge-fasteoi   timer
  1:        347          1   IO-APIC-edge      i8042
  8:          1          1   IO-APIC-edge      rtc
 12:        147          2   IO-APIC-edge      i8042
 14:         36          1   IO-APIC-edge      ide0
 16:          0          1   IO-APIC-fasteoi   yenta, sdhci:slot0
 17:       1411        115   IO-APIC-fasteoi   eth0
 18:       1627          6   IO-APIC-fasteoi   libata, HDA Intel
 19:         50          1   IO-APIC-fasteoi   ohci_hcd:usb1, ehci_hcd:usb2,
ohci_hcd:usb3
 21:         24          9   IO-APIC-fasteoi   acpi
NMI:          0          0
LOC:       7592       9184
ERR:          0
MIS:          0

--
Greetings - CeHo - Grzegorz Chwesewicz
