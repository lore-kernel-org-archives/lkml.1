Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbYFPRrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbYFPRrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbYFPRrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:47:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39114 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbYFPRrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:47:02 -0400
Message-ID: <4856A6F9.3090605@zytor.com>
Date: Mon, 16 Jun 2008 10:46:33 -0700
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
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>	<20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>	<1213600062.11185.13.camel@caritas-dev.intel.com>	<20080616032457.718f4d87.pj@sgi.com>	<1213606435.12968.14.camel@caritas-dev.intel.com>	<48568B56.7060307@zytor.com>	<20080616113806.2ff4c1a4.pj@sgi.com>	<48569D62.9050107@zytor.com> <20080616123721.bb9195e6.pj@sgi.com>
In-Reply-To: <20080616123721.bb9195e6.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> 
> The question to me is this.  Are there PCs which (1) need such a safety
> reservation of an ebda area -and- (2) boot with EFI enabled?  I am not
> asking if there -could- be (in the abstract, there certainly is no law
> of government or physics prohibiting such).  Rather I am asking as a
> practical matter if there is, or is likely to be, such PCs "in the wild."
> 
> The safety reservation of this ebda area is a hack.  As hacks go, it is
> a rather gentle hack, but still it is a hack.  As such, it is to be
> avoided unless there is a practical need.  Some non-efi old PCs have that
> need - no debate there.
> 
> Should we perpeturate this (gentle) hack for EFI systems as well?
> 

We *are* going to have similar hacks.  That's not a question.  At this 
point, the live pool of EFI systems is functionally zero, so it's 
pointless to try to draw conclusions from the live pool (the little I 
have heard about the incoming set of EFI machines make me think the 
problems we've had with BIOS will look like child's play compared to the 
EFI braindamages we'll have to suffer.)

Perpetuating this hack will cost a few kilobytes of memory on machines 
which may not care.  *Not* perpetuating may save a few kilobytes on 
machines which may cause odd behaviours that only are noticeable when 
you, say, boot from one OS into another.

Guess which option I think is saner.

	-hpa
