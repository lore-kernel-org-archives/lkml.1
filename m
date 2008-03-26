Return-Path: <linux-kernel-owner+w=401wt.eu-S1760586AbYCZADS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586AbYCZADS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 20:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbYCZADK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 20:03:10 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:48121 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbYCZADJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:03:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JD/B9d6gN69F2ZtjH5JANIwsElP9y045EE/CQ/guOlKKK6nlGrAo3BdnIPelN4v5+zD7d+HWEmPPxGLSiZ2MYjbor8ZPe1vKDHMRaiCJ7206rZHTB5XOr4ugs6ulpzXRBLABqvxKM6iJwZ+cNxoUQnyw7743BtEi34F2cgRxWrg=
Message-ID: <86802c440803251703o3f46e6dct754c81eecb82dae1@mail.gmail.com>
Date: Tue, 25 Mar 2008 17:03:06 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Benjamin Herrenschmidt" <benh@ozlabs.org>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported regressions from 2.6.24)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       "Thomas Meyer" <thomas@m3y3r.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>,
       "Myles Watson" <mylesgw@gmail.com>
In-Reply-To: <1206488005.10573.8.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de>
	 <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de>
	 <47E557D5.9020604@s5r6.in-berlin.de>
	 <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org>
	 <1206488005.10573.8.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 4:33 PM, Benjamin Herrenschmidt <benh@ozlabs.org> wrote:
> On Sat, 2008-03-22 at 14:33 -0700, Linus Torvalds wrote:
>  >
>  > On Sat, 22 Mar 2008, Stefan Richter wrote:
>  > >
>  > > Can an MMIO region reside above 0x1'0000'0000 on x86-32? ... Apparently yes,
>  > > if CONFIG_RESOURCES_64BIT=y.
>  >
>  > Hmm. It would only work if PAE (HIGHMEM64G) is enabled too.
>  >
>  > And obviously the hardware has to have working 64-bit BAR's.
>
>  On other platforms however, you can have mmio above 32 bits without
>  support for 64 bits BARs: the entire PCI bus mmio region can be mapped
>  up there.
>
>  That happens for example with 4xx embedded PowerPC. We deal with it just
>  fine, provided that nothing tries to stick a resource value into an
>  unsigned long but uses resource_size_t instead. Unfortunately, it's a
>  common bug, I've fixing drivers regulary.
>
>  It also appears that the iomap code on various archs is buggy too,
>  including the generic lib/iomap.c, thus pci_iomap is broken for archs
>  that can have 64 bits resources and use the version in lib/.
>
>  The good news is that I have done a patch to fix it, which has been
>  in -mm for about a month: iomap-fix-64-bits-resources-on-32-bits.patch

does it support if size is 4G above, like 256G?

YH
