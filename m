Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbYAPCuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbYAPCuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbYAPCub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:50:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:60577 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138AbYAPCua convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:50:30 -0500
X-ExtLoop1: 1
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -mm 0/3] i386 boot: replace boot_ioremap with enhancedbt_ioremap
Date: Tue, 15 Jan 2008 18:51:25 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE5E88DF@orsmsx423.amr.corp.intel.com>
In-Reply-To: <1200390535.3505.62.camel@caritas-dev.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -mm 0/3] i386 boot: replace boot_ioremap with enhancedbt_ioremap
Thread-Index: AchXW9Fk6B8eO2VlSKyfTlfMLyR8lwAjsdrg
References: <1200375902.3505.29.camel@caritas-dev.intel.com> <20080115084417.GA16449@elte.hu> <1200390535.3505.62.camel@caritas-dev.intel.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Huang, Ying" <ying.huang@intel.com>, "Ingo Molnar" <mingo@elte.hu>
Cc: <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, "Andi Kleen" <ak@suse.de>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Jan 2008 02:50:29.0612 (UTC) FILETIME=[8DFBEAC0:01C857EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Huang, Ying 
>Sent: Tuesday, January 15, 2008 1:49 AM
>To: Ingo Molnar; Pallipadi, Venkatesh
>Cc: akpm@linux-foundation.org; H. Peter Anvin; Thomas 
>Gleixner; Ingo Molnar; Andi Kleen; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH -mm 0/3] i386 boot: replace boot_ioremap 
>with enhancedbt_ioremap
>
>On Tue, 2008-01-15 at 09:44 +0100, Ingo Molnar wrote:
>> * Huang, Ying <ying.huang@intel.com> wrote:
>> 
>> > This patchset replaces boot_ioremap with a enhanced version of 
>> > bt_ioremap and renames the bt_ioremap to early_ioremap. 
>This reduces 
>> > 12k from .init.data segment and increases the size of 
>memory that can 
>> > be re-mapped before paging_init to 64k.
>> 
>> in latest x86.git#mm there's an early_ioremap() introduced 
>as part of 
>> the PAT series - available on both 32-bit and 64-bit. Could 
>you take a 
>> look at it and use that if it's OK for your purposes?
>
>After checking the early_ioremap() implementation in
>arch/x86/kernel/setup_32.c, I found that it is a duplication of
>bt_ioremap() implementation in arch/x86/mm/ioremap_32.c. Both
>implementations use set_fixmap(), so they can be used only after
>paging_init().
>
>The early_ioremap implementation provided in this patchset works as
>follow:
>
>- Enhances bt_ioremap, make it usable before paging_init() via a
>dedicated PTE page.
>- Rename bt_ioremap to early_ioremap
>
>So I think maybe we should replace the early_ioremap() 
>implementation in
>PAT series with that of this series.
>

Agreed. PAT can use this for early mappings. Thanks for the patches :)

-Venki
