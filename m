Return-Path: <linux-kernel-owner+w=401wt.eu-S1761594AbXHGJyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761594AbXHGJyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 05:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758042AbXHGJyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 05:54:31 -0400
Received: from ns1.suse.de ([195.135.220.2]:50737 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757936AbXHGJyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 05:54:31 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
Date: Tue, 7 Aug 2007 11:54:22 +0200
User-Agent: KMail/1.9.6
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
References: <1185851583.23149.30.camel@caritas-dev.intel.com> <m1r6mnnpj8.fsf@ebiederm.dsl.xmission.com> <1186478984.3769.46.camel@caritas-dev.intel.com>
In-Reply-To: <1186478984.3769.46.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708071154.23150.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 August 2007 11:29:44 Huang, Ying wrote:
 
> > How does EFI handle 32bit/64bit compatibility?  In particular
> > how do I load a 32bit kernel on machine with a 64bit EFI?  Can
> > it be done?
> > 
> Because the EFI memory map is converted to E820 map in bootloader now,
> it is possible to load 32bit kernel on machine with a 64bit EFI.

The 32bit EFI code doesn't know this yet, does it?

> But it 
> is almost impossible to call EFI runtime service in 32bit kernel. But I
> think EFI runtime service is not essential in this situation, because
> the raw hardware can be used too.

That doesn't sound good. Is this really supposed to work this way?

If the raw hardware works why are we using EFI services at all? 
We generally trust hardware more than BIOSes.

Might we end up with machines that only boot with the 64bit kernel?

Will systems have a dual EFI implementation? 

Also long term I would like to use a few useful EFI services,
like the support to put some data into the CMOS area to survive
a reboot. That would be quite useful for panics and oopses.
But we would prefer to have that on 32bit too.



-Andi
