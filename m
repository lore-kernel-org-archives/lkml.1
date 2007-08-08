Return-Path: <linux-kernel-owner+w=401wt.eu-S1760764AbXHHIS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbXHHIS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 04:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbXHHISQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 04:18:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:51634 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbXHHISN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 04:18:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,233,1183359600"; 
   d="scan'208";a="260379186"
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200708071154.23150.ak@suse.de>
References: <1185851583.23149.30.camel@caritas-dev.intel.com>
	 <m1r6mnnpj8.fsf@ebiederm.dsl.xmission.com>
	 <1186478984.3769.46.camel@caritas-dev.intel.com>
	 <200708071154.23150.ak@suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 08 Aug 2007 16:18:02 +0800
Message-Id: <1186561082.4430.63.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 08 Aug 2007 08:17:52.0166 (UTC) FILETIME=[9D5A0C60:01C7D994]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-07 at 11:54 +0200, Andi Kleen wrote:
> On Tuesday 07 August 2007 11:29:44 Huang, Ying wrote:
>  
> > > How does EFI handle 32bit/64bit compatibility?  In particular
> > > how do I load a 32bit kernel on machine with a 64bit EFI?  Can
> > > it be done?
> > > 
> > Because the EFI memory map is converted to E820 map in bootloader now,
> > it is possible to load 32bit kernel on machine with a 64bit EFI.
> 
> The 32bit EFI code doesn't know this yet, does it?

The needed code changing is minimal. In fact, I can boot 32bit Linux
kernel on my x86_64 EFI machine. With setup as follow:

1. Apply the efi-fb.patch
2. make efi fb driver not depend on EFI
3. configure kernel as follow:
   a. CONFIG_EFI is turned off
   b. CONFIG_FB_EFI is turned on

> > But it 
> > is almost impossible to call EFI runtime service in 32bit kernel. But I
> > think EFI runtime service is not essential in this situation, because
> > the raw hardware can be used too.
> 
> That doesn't sound good. Is this really supposed to work this way?
> 
> If the raw hardware works why are we using EFI services at all? 
> We generally trust hardware more than BIOSes.
> 
> Might we end up with machines that only boot with the 64bit kernel?
> 
> Will systems have a dual EFI implementation? 

I don't know. But I can ask some EFI guys about this.

> Also long term I would like to use a few useful EFI services,
> like the support to put some data into the CMOS area to survive
> a reboot. That would be quite useful for panics and oopses.
> But we would prefer to have that on 32bit too.

Yes, although oopses and panics information can be saved though kdump
too, it is more convenient to use EFI variable services to store
information like that especially for ordinary user.

Best Regards,
Huang Ying
