Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbXGBPn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbXGBPn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 11:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbXGBPnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 11:43:22 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:54840 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbXGBPnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 11:43:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=jCVc6dora8EHPa47Pyq0p0t1R4S87dlTuQUa15pbsYEMGe+RTn9Bt6sHx9iBTsc0Cl8KnY/8imWR+HcYOSOlmPZ6RaZBKg1WkQYZytBZkwprBptNmRHk0q7+r7mrSHJiNdhiK6EuDcd2cCfyExCFB1Rz/I1vUcYW8qOrqE/DO9Q=
Date: Mon, 2 Jul 2007 18:43:13 +0300
To: Brian Gerst <bgerst@didntduck.org>
Cc: Andreas Schwab <schwab@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [i386] Questions regarding provisional page tables initialization
Message-ID: <20070702154313.GA2619@Ahmed>
References: <20070701203833.GA3498@Ahmed> <46882872.7040005@goop.org> <20070702011332.GA3503@Ahmed> <je8x9zrwof.fsf@sykes.suse.de> <20070702102303.GA17533@Ahmed> <4688E2BC.9060908@didntduck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4688E2BC.9060908@didntduck.org>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2007 at 07:34:20AM -0400, Brian Gerst wrote:
> Ahmed S. Darwish wrote:
> > now back to head.S code:
> >  	leal    0x007(%edi),%ecx	/* Create PDE entry */
> > 
> > Isn't the above line the same condition (bytes, not bits displacement) ?. 
> > Thanks for your patience !.
> 
> The leal instruction (Load Effective Address) is often used as a way to
> add a constant to one register and store the result in another register
> in a single instruction.
> [...]

At last I got it due to all of everybody's very nice explanations :). 
Here's the provisional page tables intialization scenario:

We want to store pg0 pte addresses to high 20bits swapper_pg_dir entries,
we also want the PRESENT,RW,USER flags be set in those entries. This is 
done by  getting the address of each pg0 entry and adding 7 to it (Brian's
note). Since pg0 entires address are page aligned(Andreas, Jeremy notes),
adding 7 will assure that the first 3 bits are set without affecting the
high 20 bits.

Big Thanks!,

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
