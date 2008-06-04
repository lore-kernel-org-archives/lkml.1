Return-Path: <linux-kernel-owner+w=401wt.eu-S1761751AbYFDSUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761751AbYFDSUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYFDSUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:20:44 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44256 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618AbYFDSUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:20:43 -0400
Date: Wed, 4 Jun 2008 21:20:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 4 -
	firmware/keyspan/mpr.fw.gen.S
Message-ID: <20080604182011.GD4189@cs181133002.pp.htv.fi>
References: <20080604180025.3ecd03ff.sfr@canb.auug.org.au> <48468091.5000102@linux.vnet.ibm.com> <1212580245.32207.51.camel@pmac.infradead.org> <54a3f4cc48b03f9fe63be0bcd7c2ab20@kernel.crashing.org> <1212601930.32207.134.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1212601930.32207.134.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 06:52:10PM +0100, David Woodhouse wrote:
> On Wed, 2008-06-04 at 19:19 +0200, Segher Boessenkool wrote:
> > It is a new feature in GNU make 3.81, which was released slightly
> > over two years ago.
> 
> Hm, Ok. I'll stick in a workaround. Thanks.
> 
> diff --git a/firmware/Makefile b/firmware/Makefile
> index b4f758a..166a9b0 100644
> --- a/firmware/Makefile
> +++ b/firmware/Makefile
> @@ -83,6 +83,13 @@ wordsize_deps := $(wildcard include/config/64bit.h include/config/32bit.h \
>  		include/config/superh32.h include/config/superh64.h \
>  		include/config/x86_32.h include/config/x86_64.h)
>  
> +# Workaround for ancient versions of make, where .SECONDEXPANSION doesn't work.

Can you write make < 3.81 instead?

We do know the version and this will make it easier in a few years to 
determine when the workaround will no longer be required.

> +# It'll end up depending on these targets, so make them a PHONY rule which
> +# depends on _all_ the directories in $(firmware-dirs), and it'll work out OK.
> +PHONY += $(objtree)/$$(%) $(objtree)/$(obj)/$$(%)
> +$(objtree)/$$(%) $(objtree)/$(obj)/$$(%): $(firmware-dirs)
> +	@true
> +
>  # For the $$(dir %) trick, where we need % to be expanded first.
>  .SECONDEXPANSION:
>  
> dwmw2

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

