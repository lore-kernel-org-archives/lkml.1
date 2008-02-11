Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYBKNoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYBKNoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 08:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYBKNo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 08:44:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbYBKNo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 08:44:29 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [5/8] Fix logic error in 64bit memory hotadd
Date: Mon, 11 Feb 2008 14:44:24 +0100
User-Agent: KMail/1.9.6
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <200802111034.764275766@suse.de> <200802111405.04423.ak@suse.de> <20080211133333.GA5842@elte.hu>
In-Reply-To: <20080211133333.GA5842@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111444.24496.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008 14:33:33 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > > Also, your fix, while it solves a real bug we want to fix, is not quite 
> > > right for upstream integration yet. I can see 3 immediate problems with 
> > > it:
> > > 
> > > > +			if (!pud_present(*pud)) {
> > > > +				pud = (pud_t *)get_zeroed_page(GFP_ATOMIC);
> > > 
> > > the GFP_ATOMIC here can fail.
> > 
> > The memory hotplug code already uses GFP_ATOMIC elsewhere 
> > (spp_getpage)
> 
> wrong. The _x86_ memory hotplug code uses GFP_ATOMIC elsewhere.
> The generic memory hotplug code does not.

To be honest I'm a little tired now how you attempt to misinterpret every
word I write. Was it not clear from the context which code
was meant?

> 
> and the x86 memory hotplug code uses GFP_ATOMIC and panic() elsewhere 
> because:

I see it's all my fault. 

> 
> > The existing code already panics elsewhere (spp_getpage); i just 
> > copied that.
> 
> and you had nothing to do with that "existing code"? git-log reveals 
> that the GFP_ATOMIC and panic()-ing patch was added 2 years ago and was 
> signed off by you:

Should I point out all unclean and buggy code you ever signed
off?  @) Just alone in .25-rc1 there is enough of that.

> 
>   commit 44df75e629106efcada087cead6c3f33ed6bcc60
>   Author: Matt Tolentino <metolent@cs.vt.edu>
>   Date:   Tue Jan 17 07:03:41 2006 +0100
> 
>     [PATCH] x86_64: add x86-64 support for memory hot-add
> 
>   [...]
>   Signed-off-by: Andi Kleen <ak@suse.de>
> 
> We (like most upstream kernel subsystems) generally do not accept 
> patches into arch/x86 that spreads a buggy implementation detail 
> further. Please submit a patch that cleans up the mess. Thanks,

Ok I withdraw the patch under these circumstances. I'm not your coding
slave and I don't feel strongly enough about the hotplug case to 
put much more work into this.

-Andi
