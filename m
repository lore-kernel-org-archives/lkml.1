Return-Path: <linux-kernel-owner+w=401wt.eu-S1761069AbXI0Xyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761069AbXI0Xyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 19:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760857AbXI0Xyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 19:54:31 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:10416 "EHLO
	outbound3-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760803AbXI0Xy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 19:54:29 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Thu, 27 Sep 2007 17:54:27 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: jkeating@redhat.com, "Joerg Pommnitz" <pommnitz@yahoo.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <ak@suse.de>
Subject: Re: More E820 brokenness
Message-ID: <20070927235427.GA18900@cosmic.amd.com>
References: <46FC2BFD.6070200@zytor.com>
 <20070927223336.GB4755@cosmic.amd.com> <46FC32FE.9070302@zytor.com>
 <20070927231552.GC4755@cosmic.amd.com> <46FC3C5A.2010902@zytor.com>
 <20070927233408.GD4755@cosmic.amd.com> <46FC3E7C.7060600@zytor.com>
MIME-Version: 1.0
In-Reply-To: <46FC3E7C.7060600@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 27 Sep 2007 23:53:56.0637 (UTC)
 FILETIME=[AAA3B4D0:01C80161]
X-WSS-ID: 6AE29D142ZC505111-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/09/07 16:36 -0700, H. Peter Anvin wrote:
> Jordan Crouse wrote:
> >>>
> >> Oh bugger, looks like this one might be genuinely my fault after all.
> >> The ID check in the new code is buggy.
> >>
> >> Can you please test this revised patch out (against current -git)?
> > 
> > 
> > That looks the same as the previous patch you sent?
> > 
> 
> Sorry, this is the right one...
> 
> 	-hpa

> diff --git a/arch/i386/boot/memory.c b/arch/i386/boot/memory.c
> index bccaa1c..2f37568 100644
> --- a/arch/i386/boot/memory.c
> +++ b/arch/i386/boot/memory.c
> @@ -28,11 +28,10 @@ static int detect_memory_e820(void)
>  
>  	do {
>  		size = sizeof(struct e820entry);
> -		id = SMAP;
>  		asm("int $0x15; setc %0"
> -		    : "=am" (err), "+b" (next), "+d" (id), "+c" (size),
> +		    : "=dm" (err), "+b" (next), "=a" (id), "+c" (size),
>  		      "=m" (*desc)
> -		    : "D" (desc), "a" (0xe820));
> +		    : "D" (desc), "d" (SMAP), "a" (0xe820));
>  
>  		/* Some BIOSes stop returning SMAP in the middle of
>  		   the search loop.  We don't know exactly how the BIOS

Worked, but that just raises more questions.  Why didn't more x86 boxes
break or, alternatively, why did a new version of the BIOS fix the problem? 
I guess we shouldn't look a gift horse in the mouth. Or something.

Thanks very much for your help.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


