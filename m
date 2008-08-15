Return-Path: <linux-kernel-owner+w=401wt.eu-S1760030AbYHOSBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030AbYHOSBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 14:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbYHOSBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 14:01:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46539 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160AbYHOSBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 14:01:09 -0400
Date: Fri, 15 Aug 2008 20:00:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: prarit@redhat.com, jbarnes@virtuousgeek.org, joro@8bytes.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
Message-ID: <20080815180048.GA26844@elte.hu>
References: <4899B611.4070408@redhat.com> <200808071003.47326.jbarnes@virtuousgeek.org> <489B33D4.1080107@redhat.com> <20080809125116H.fujita.tomonori@lab.ntt.co.jp> <20080815161629.GL27955@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815161629.GL27955@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] x86 gart: allocate size-aligned address for alloc_coherent
> > 
> > This fixes GART to return a properly aligned address as
> > DMA-mapping.txt defines.
> 
> applied to tip/x86/gart, thanks! Any v2.6.27-urgency of this patch?

hm, -tip testing has found that this patch causes a hard hang during 
bootup:

 initcall ali_init+0x0/0x1b returned 0 after 3 msecs
 calling  amd_init+0x0/0x1b
 bus: 'pci': add driver pata_amd
 bus: 'pci': driver_probe_device: matched device 0000:00:06.0 with driver pata_amd
 bus: 'pci': really_probe: probing driver pata_amd with device 0000:00:06.0
 pata_amd 0000:00:06.0: version 0.3.10
 pata_amd 0000:00:06.0: setting latency timer to 64
 [hard hang]

should have continued with:

 scsi0 : pata_amd
 device: 'host0': device_add
 device: 'host0': device_add
 scsi1 : pata_amd
 [... etc. ... ]

on an AMD X2 testsystem. (Asus board) Can send more info on request. 
Config is:

  http://redhat.com/~mingo/misc/config-Fri_Aug_15_18_30_56_CEST_2008.bad

Any idea why that is so? Apparently the alignment change wasnt as benign 
as assumed.

	Ingo
