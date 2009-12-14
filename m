Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbZLNURH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbZLNURH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 15:17:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbZLNURG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 15:17:06 -0500
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:45535
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758169AbZLNURE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:17:04 -0500
X-Trace: 277588593/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/83.67.12.31/None/tvrtko@ursulin.net
X-SBRS: None
X-RemoteIP: 83.67.12.31
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: KMail/1.12.2 (Linux/2.6.32.1; KDE/4.3.1; x86_64; ; )
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkwFAIMsJktTQwwf/2dsb2JhbACBS9cshCsEgWI
X-IronPort-AV: E=Sophos;i="4.47,396,1257120000"; 
   d="scan'208";a="277588593"
X-IP-Direction: IN
From: Tvrtko Ursulin <tvrtko@ursulin.net>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: Are these MTRR settings correct?
Date: Mon, 14 Dec 2009 20:16:53 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.32.1; KDE/4.3.1; x86_64; ; )
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200912130807.44905.tvrtko@ursulin.net> <200912141934.10628.tvrtko@ursulin.net> <4B26965C.6020203@kernel.org>
In-Reply-To: <4B26965C.6020203@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912142016.53160.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 Dec 2009 19:47:40 Yinghai Lu wrote:
> Tvrtko Ursulin wrote:
> > On Monday 14 Dec 2009 11:25:58 Yinghai Lu wrote:
> >>>> something wrong, we should not check that with e820 or acpi resource
> >>>> in that case. please check
> >>>>
> >>>> {PATCH] x86/pci: don't check mmconf again if it is from MSR with amd
> >>>> faml0h
> >>>>
> >>>> for AMD Fam10h, it we read mmconf from MSR early, we should just trust
> >>>> it because we check it and correct it already.
> >>>>
> >>>> so skip the reject check there.
> >>>
> >>> [path snipped]
> >>>
> >>> Do you want me to test with this patch and that pci=.. option active
> >>> and post dmesg? Or without the pci=... option?
> >>
> >> with this patch and pci=... and post dmesg...
> >
> > Here you go:
> 
> ...
> 
> > [    0.250041] node 0 link 0: io port [1000, ffffff]
> > [    0.250043] TOM: 00000000e0000000 aka 3584M
> > [    0.250044] Fam 10h mmconf [e0000000, efffffff]
> > [    0.250046] node 0 link 0: mmio [a0000, bffff]
> > [    0.250048] node 0 link 0: mmio [e0000000, efffffff] ==> none
> > [    0.250050] node 0 link 0: mmio [f0000000, fe7fffff]
> > [    0.250051] node 0 link 0: mmio [fe800000, fe9fffff]
> > [    0.250053] node 0 link 0: mmio [fea00000, ffefffff]
> > [    0.250054] TOM2: 0000000120000000 aka 4608M
> > [    0.250056] bus: [00,07] on node 0 link 0
> > [    0.250057] bus: 00 index 0 io port: [0, ffff]
> > [    0.250058] bus: 00 index 1 mmio: [a0000, bffff]
> > [    0.250060] bus: 00 index 2 mmio: [f0000000, ffffffff]
> > [    0.250061] bus: 00 index 3 mmio: [120000000, fcffffffff]
> > [    0.250068] ACPI: bus type pci registered
> > [    0.250091] PCI: Found AMD Family 10h NB with MMCONFIG support.
> > [    0.254793] PCI: Using MMCONFIG at e0000000 - efffffff
> > [    0.254795] PCI: Using configuration type 1 for base access
> 
> ...
> 
> thanks, mmconf works on your system.

So I should keep using both your patch and pci=check_enable_amd_mmconf option?

Tvrtko


