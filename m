Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbZBYJhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbZBYJhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZBYJhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:37:43 -0500
Received: from smtp06.msg.oleane.net ([62.161.4.6]:51846 "EHLO
	smtp06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZBYJhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:37:42 -0500
X-Oleane-Rep: REPA
From: "Thomas Jourdan" <tjourdan@interfaceconcept.com>
To: "'H. Peter Anvin'" <hpa@zytor.com>,
       "'Thomas Jourdan'" <tjourdan@interfaceconcept.com>
Cc: <linux-kernel@vger.kernel.org>, "'Huang Ying'" <ying.huang@intel.com>,
       "'Peter Jones'" <pjones@redhat.com>,
       "'Yinghai Lu'" <yinghai@kernel.org>
Subject: RE: [BUG] dmi_scan_machine uses uninitialized address on x86 / EFI
Date: Wed, 25 Feb 2009 13:28:04 +0100
Message-ID: <ADD10563C03642F7BEE3C19170ADC11E@thje6600v>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook CWS, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
In-Reply-To: <49A462BD.7010205@zytor.com>
Importance: Normal
X-Spam-Flag: NO
X-PMX-Spam: Probability=15%
X-PFSI-Info: PMX 5.5.2.365749, Antispam-Engine: 2.6.1.350677, Antispam-Data: 2009.2.25.91936 (no antivirus check)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys

The bug is not critical. Vanilla kernel works fine without the patch, except for the DMI sysfs stuffs.

Without the patch, if CONFIG_DMI is enabled, I got the "DMI not present or invalid." error message on boot. Then later, if CONFIG_DMIID is enabled, DMI system identification informations won't be exported via sysfs to userspace. The /sys/class/dmi/id entry is not present.

Regards,
Thomas

-----Message d'origine-----
De : H. Peter Anvin [mailto:hpa@zytor.com]
Envoyé : mar. 24 février 2009 22:12
À : Thomas Jourdan
Cc : linux-kernel@vger.kernel.org; Huang Ying; Peter Jones; Yinghai Lu
Objet : Re: [BUG] dmi_scan_machine uses uninitialized address on x86 /
EFI


Thomas Jourdan wrote:
> 
> On x86/EFI platforms, if efi_enabled is true, the dmi_scan_machine function
> fails, even if valid DMI table is present. In the setup_arch function,
> efi_init is called after dmi_scan_machine. But this is efi_init which will
> initialize the smbios address, needed by dmi_scan_machine.
> 
> This leads to dmi_scan_machine ioremapping physical address 0, instead of
> the address provided by the EFI system table. The following patch fixes the
> problem.
> 

Hi Thomas,

What is the concrete manifestation of the bug (i.e. how critical is it?)
 We are late in the 2.6.29-rc cycle, and this patch seems to have some
risk associated with it.

Huang, Peter, Yinghai: any opinions?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


__________ Information NOD32 3887 (20090224) __________

Ce message a ete verifie par NOD32 Antivirus System.
http://www.nod32.com


