Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbYFPRG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbYFPRG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbYFPRGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:06:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35322 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbYFPRGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:06:49 -0400
Message-ID: <48569D62.9050107@zytor.com>
Date: Mon, 16 Jun 2008 10:05:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       yhlu.kernel@gmail.com, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap memory
 ranges
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>	<20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>	<1213600062.11185.13.camel@caritas-dev.intel.com>	<20080616032457.718f4d87.pj@sgi.com>	<1213606435.12968.14.camel@caritas-dev.intel.com>	<48568B56.7060307@zytor.com> <20080616113806.2ff4c1a4.pj@sgi.com>
In-Reply-To: <20080616113806.2ff4c1a4.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> hpa wrote:
>> Realistically, we need the infrastructure to be able to make paranoia 
>> reservations, and you need to be able to deal with later finding they 
>> are actually in use.
> 
> While the tone of your reply sounds like something I would naturally
> agree with, I can't actually figure out what you mean in this case ;).
> 
> In particular, Peter, would you agree/disagree/other with the direction
> that Huang and I agreed to last night:
> 
>> Would you recommend doing this with code in arch/x86/kernel/head.c,
>> that did not invoke reserve_ebda_region() if efi_enabled was set?

I disagree with it, I do not consider it safe.  I think you have to 
consider the difference between a "safety reservation" and a "actual 
reservation", with the latter being allowed to overlap the former.

	-hpa
