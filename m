Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbZLNL1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbZLNL1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbZLNL1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:27:11 -0500
Received: from pmx1.sophos.com ([213.31.172.16]:54817 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756879AbZLNL04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:26:56 -0500
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Dec 2009 06:26:56 EST
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: Are these MTRR settings correct?
Date: Mon, 14 Dec 2009 11:19:54 +0000
User-Agent: KMail/1.9.10
Cc: Tvrtko Ursulin <tvrtko@ursulin.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200912130807.44905.tvrtko@ursulin.net> <200912131719.01388.tvrtko@ursulin.net> <4B257117.40009@kernel.org>
In-Reply-To: <4B257117.40009@kernel.org>
MIME-Version: 1.0
Message-Id: <200912141119.55068.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 14/12/2009 11:19:55,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 14/12/2009 11:19:55,
	Serialize complete at 14/12/2009 11:19:55
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 December 2009 22:56:23 Yinghai Lu wrote:
> Tvrtko Ursulin wrote:
> > On Sunday 13 Dec 2009 09:25:33 Yinghai Lu wrote:
> >> On Sun, Dec 13, 2009 at 12:26 AM, Tvrtko Ursulin <tvrtko@ursulin.net> 
wrote:
> >>> reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> >>> reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
> >>> reg02: base=0x0c0000000 ( 3072MB), size=  256MB, count=1: write-back
> >>> reg03: base=0x0f0000000 ( 3840MB), size=  128MB, count=1:
> >>> write-combining
> >>>
> >>> Still looks like from 3328MB to 3840MB is of status unknown?
> >>>
> >>> dmesg in that case:
> >
> > [    0.250038] node 0 link 0: io port [1000, ffffff]
> > [    0.250040] TOM: 00000000e0000000 aka 3584M
> > [    0.250041] Fam 10h mmconf [e0000000, efffffff]
> > [    0.250043] node 0 link 0: mmio [a0000, bffff]
> > [    0.250045] node 0 link 0: mmio [e0000000, efffffff] ==> none
> > [    0.250047] node 0 link 0: mmio [f0000000, fe7fffff]
> > [    0.250048] node 0 link 0: mmio [fe800000, fe9fffff]
> > [    0.250050] node 0 link 0: mmio [fea00000, ffefffff]
> > [    0.250051] TOM2: 0000000120000000 aka 4608M
> > [    0.250053] bus: [00,07] on node 0 link 0
> > [    0.250054] bus: 00 index 0 io port: [0, ffff]
> > [    0.250055] bus: 00 index 1 mmio: [a0000, bffff]
> > [    0.250057] bus: 00 index 2 mmio: [f0000000, ffffffff]
> > [    0.250058] bus: 00 index 3 mmio: [120000000, fcffffffff]
> > [    0.250065] ACPI: bus type pci registered
> > [    0.250088] PCI: Found AMD Family 10h NB with MMCONFIG support.
> > [    0.250091] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0
> > - 255 [    0.250092] PCI: Not using MMCONFIG.
> > [    0.250094] PCI: Using configuration type 1 for base access
> > [    0.250095] PCI: Using configuration type 1 for extended access
>
> something wrong, we should not check that with e820 or acpi resource in
> that case. please check
>
> {PATCH] x86/pci: don't check mmconf again if it is from MSR with amd faml0h
>
> for AMD Fam10h, it we read mmconf from MSR early, we should just trust it
> because we check it and correct it already.
>
> so skip the reject check there.

[path snipped]

Do you want me to test with this patch and that pci=.. option active and post 
dmesg? Or without the pci=... option?

Tvrtko

