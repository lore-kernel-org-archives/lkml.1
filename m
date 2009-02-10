Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbZBJVT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbZBJVT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbZBJVTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:19:18 -0500
Received: from mailout.artfiles.de ([80.252.97.80]:60984 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbZBJVTR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:19:17 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3 on IBM x3400
Content-class: urn:content-classes:message
Date: Tue, 10 Feb 2009 22:19:13 +0100
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <B4ED8DE8E195E84A872496A085BC07822F23@exchange01.corp.win-professional.com>
In-Reply-To: <4991E752.8010903@kernel.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3 on IBM x3400
Thread-Index: AcmLwJPD1N3tAzeZTBKDelNzQtnBTwABDMGg
References: <B4ED8DE8E195E84A872496A085BC07822F18@exchange01.corp.win-professional.com> <B4ED8DE8E195E84A872496A085BC07822F1D@exchange01.corp.win-professional.com> <20090209234528.GA862@elte.hu> <4990E90D.30005@kernel.org> <B4ED8DE8E195E84A872496A085BC07822F21@exchange01.corp.win-professional.com> <86802c440902101052m223792ddi43d27423844b1d5b@mail.gmail.com> <B4ED8DE8E195E84A872496A085BC07822F22@exchange01.corp.win-professional.com> <4991E752.8010903@kernel.org>
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Feb 2009 21:19:14.0186 (UTC) FILETIME=[393C96A0:01C98BC5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> can you post /proc/mtrr in 2.6.29-rc3 and old kernel without
warn_on..?

okay... affected are 2.6.26, 2.6.27, 2.6.28 and 2.6.29-rc3. (previous
kernels are not tested)
a small update: debian 2.6.26 lenny default kernel should be also
affected.

here /proc/mtrr from 2.6.28.4:

ibm-x3400:~# cat /proc/mtrr
reg00: base=0x0c0000000 ( 3072MB), size= 1024MB, count=1: uncachable
reg01: base=0x000000000 (    0MB), size= 4096MB, count=1: write-back
reg02: base=0x100000000 ( 4096MB), size= 1024MB, count=1: write-back
reg03: base=0x0bff80000 ( 3071MB), size=  512KB, count=1: uncachable

/proc/mtrr linux 2.6.24 (from gentoo 2008.0 amd64 livecd) no errors in
dmesg

reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
reg01: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
reg03: base=0xbff80000 (3071MB), size=196608MB: uncachable, count=1

-

Morten

-----Original Message-----
From: Yinghai Lu [mailto:yinghai@kernel.org] 
Sent: Tuesday, February 10, 2009 9:45 PM
To: Morten P.D. Stevens
Cc: Ingo Molnar; Thomas Gleixner; H. Peter Anvin; Arjan van de Ven;
linux-kernel@vger.kernel.org
Subject: Re: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with
2.6.29-rc3 on IBM x3400

Morten P.D. Stevens wrote:
> Hi,
> 
>> the line before this? it should tell why BIOS set the mask wrong.
> 
> [    0.000000] mtrr: BIOS set mask_lo: fcffff80 should be ffffff80,
> fixing it up

so BIOS miss two bits in var mtrr regs

can you post /proc/mtrr in 2.6.29-rc3 and old kernel without warn_on..?

YH
