Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbYKUNRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbYKUNRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 08:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbYKUNRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 08:17:40 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:19218 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbYKUNRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 08:17:39 -0500
X-BigFish: VPS-32(zz146fK1432R98dR1805M936fOzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KAOQ8Z-02-HPX-01
Date: Fri, 21 Nov 2008 14:16:09 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>, cpufreq@vger.kernel.org,
       stable@kernel.org, "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] x86: powernow-k8: ignore out-of-range PstateStatus
	value
Message-ID: <20081121131609.GA10975@alberich.amd.com>
References: <20081107150811.GI15390@alberich.amd.com> <20081121080841.GD10940@alberich.amd.com> <20081121082346.GK16242@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081121082346.GK16242@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 21 Nov 2008 13:17:26.0755 (UTC) FILETIME=[7F9AEB30:01C94BDB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 09:23:46AM +0100, Ingo Molnar wrote:
> 
> nice fix! A few minor nits:
> 
> > +			/* a workaround for family 11h erratum 311 might cause
> > +			   an "out-of-range Pstate if the core is in Pstate-0 */

> Please use the customary comment style:
>   /*
>    * Comment .....
>    * ...... goes here:
>    */

I don't prefer that style -- but if you do.

> and since it's multi-line anyway, keep to the 80-col limit too please.

2nd line should be exactly 80 columns.

> > diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
> > index ab48cfe..4078f5d 100644
> > --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
> > +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
> > @@ -23,7 +23,9 @@ struct powernow_k8_data {
> >          u32 exttype; /* extended interface = 1 */
> >  
> >  	/* keep track of the current fid / vid or pstate */
> > -	u32 currvid, currfid, currpstate;
> > +	u32 currvid, currfid;
> > +	u32 currpstate;
> 
> Any reason why it has been moved to a separate line?

Sure, it's to emphasize that the following define is just for this field.


Andreas


