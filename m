Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbZBKQCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbZBKQCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 11:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbZBKQCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 11:02:00 -0500
Received: from mailout.artfiles.de ([80.252.97.80]:59400 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbZBKQCA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:02:00 -0500
Subject: RE: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3 on IBM x3400
Date: Wed, 11 Feb 2009 17:01:54 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-ID: <B4ED8DE8E195E84A872496A085BC07822F2A@exchange01.corp.win-professional.com>
In-Reply-To: <86802c440902102106o54e4ea2fua4d108c8564ff8a@mail.gmail.com>
Content-class: urn:content-classes:message
X-MS-Has-Attach: 
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-MS-TNEF-Correlator: 
Thread-Topic: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3 on IBM x3400
Thread-Index: AcmMBocs3CPkQfldR2a3xwHoZ9ZdIwAWsXfQ
References: <B4ED8DE8E195E84A872496A085BC07822F18@exchange01.corp.win-professional.com> <B4ED8DE8E195E84A872496A085BC07822F1D@exchange01.corp.win-professional.com> <20090209234528.GA862@elte.hu> <4990E90D.30005@kernel.org> <B4ED8DE8E195E84A872496A085BC07822F21@exchange01.corp.win-professional.com> <86802c440902101052m223792ddi43d27423844b1d5b@mail.gmail.com> <B4ED8DE8E195E84A872496A085BC07822F22@exchange01.corp.win-professional.com> <4991E752.8010903@kernel.org> <B4ED8DE8E195E84A872496A085BC07822F23@exchange01.corp.win-professional.com> <86802c440902102106o54e4ea2fua4d108c8564ff8a@mail.gmail.com>
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Feb 2009 16:01:55.0049 (UTC) FILETIME=[0F709590:01C98C62]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> so there is some problem with your BIOS, please ask the vendor to
> provide one to make
> 2.6.24 happy.

I'll report the issue to the IBM support.

on our IBM x3400 servers running RHEL the same output:

2.6.18-92.1.10.el5 #

reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
reg01: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
reg03: base=0xbff80000 (3071MB), size=196608MB: uncachable, count=1

and in dmesg:

mtrr: type mismatch for d0000000,1000000 old: uncachable new:
write-combining


Is this a big problem for direct usage? The performance on these servers
is still fine...?

Thanks for your assistance.

-

Morten

-----Original Message-----
From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
Yinghai Lu
Sent: Wednesday, February 11, 2009 6:07 AM
To: Morten P.D. Stevens
Cc: Ingo Molnar; Thomas Gleixner; H. Peter Anvin; Arjan van de Ven;
linux-kernel@vger.kernel.org
Subject: Re: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with
2.6.29-rc3 on IBM x3400

On Tue, Feb 10, 2009 at 1:19 PM, Morten P.D. Stevens
<mstevens@win-professional.com> wrote:
> Hi,
>
>> can you post /proc/mtrr in 2.6.29-rc3 and old kernel without
> warn_on..?
>
> okay... affected are 2.6.26, 2.6.27, 2.6.28 and 2.6.29-rc3. (previous
> kernels are not tested)
> a small update: debian 2.6.26 lenny default kernel should be also
> affected.
>
> here /proc/mtrr from 2.6.28.4:
>
> ibm-x3400:~# cat /proc/mtrr
> reg00: base=0x0c0000000 ( 3072MB), size= 1024MB, count=1: uncachable
> reg01: base=0x000000000 (    0MB), size= 4096MB, count=1: write-back
> reg02: base=0x100000000 ( 4096MB), size= 1024MB, count=1: write-back
> reg03: base=0x0bff80000 ( 3071MB), size=  512KB, count=1: uncachable
>
> /proc/mtrr linux 2.6.24 (from gentoo 2008.0 amd64 livecd) no errors in
> dmesg
>
> reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
> reg01: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
> reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> reg03: base=0xbff80000 (3071MB), size=196608MB: uncachable, count=1

so there is some problem with your BIOS, please ask the vendor to
provide one to make
2.6.24 happy.

YH
