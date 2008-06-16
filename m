Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbYFPPtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbYFPPtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 11:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbYFPPtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 11:49:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45153 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbYFPPtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 11:49:41 -0400
Message-ID: <48568B56.7060307@zytor.com>
Date: Mon, 16 Jun 2008 08:48:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Paul Jackson <pj@sgi.com>, mingo@elte.hu, tglx@linutronix.de,
       yhlu.kernel@gmail.com, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap	memory
 ranges
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>	 <20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>	 <1213600062.11185.13.camel@caritas-dev.intel.com>	 <20080616032457.718f4d87.pj@sgi.com> <1213606435.12968.14.camel@caritas-dev.intel.com>
In-Reply-To: <1213606435.12968.14.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
>>> Or do not reserve EBDA on EFI system.
>> I suppose.  This would have been a bigger change than I could
>> suggest.  For all I know, there are existing systems using EBDA
>> and EFI together.  Would this change break them?
>>
>> If you have good reason to know that's essentially impossible then
>> I have no objections, so far as my needs go, to not reserving EBDA
>> on EFI systems.
> 
> I think if EBDA area is used in EFI system, it should be reserved in EFI
> memory map.

Realistically, we need the infrastructure to be able to make paranoia 
reservations, and you need to be able to deal with later finding they 
are actually in use.  That's part of why we *make* paranoia 
reservations.  It's not acceptable to say "oh, it's EFI, we don't need 
it" -- that's equivalent to saying "oh, EFI firmware won't have any 
bugs."  Although I know there are plenty of EFI fanboys who seem to have 
that idea, I consider it about as likely as the tooth fairy.

	-hpa
