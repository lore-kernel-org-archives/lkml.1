Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbZF2MEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbZF2MEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 08:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbZF2MEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 08:04:16 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:21836 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbZF2MEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:04:16 -0400
X-IronPort-AV: E=Sophos;i="4.42,309,1243828800"; 
   d="scan'208";a="3183330"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: module version magic and arches with symbol prefixes
Date: Mon, 29 Jun 2009 08:07:35 -0400
User-Agent: KMail/1.9.5
CC: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <8bd0f97a0906180824y17a00110i57565aee16207e5@mail.gmail.com> <200906191307.45135.rgetz@blackfin.uclinux.org> <200906231637.38819.rusty@rustcorp.com.au>
In-Reply-To: <200906231637.38819.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200906290807.35473.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 29 Jun 2009 12:04:18.0308 (UTC) FILETIME=[BAC40C40:01C9F8B1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 23 Jun 2009 03:07, Rusty Russell pondered:
> On Sat, 20 Jun 2009 02:37:45 am Robin Getz wrote:
> > On Fri 19 Jun 2009 09:14, Mike Frysinger pondered:
> > > On Fri, Jun 19, 2009 at 08:54, Robin Getz wrote:
> > > > On Fri 19 Jun 2009 01:38, Rusty Russell pondered:
> > > >> No, it means the kernel didn't build properly.
> > > >
> > > > Or a module didn't build properly.
> > >
> > > nah, when i talked to you earlier i was wrong -- this find_symbol() is
> > > looking up the symbol in the kernel, not in the module.  the lookup of
> > > the symbol in the requested module actually works.
> >
> > OK - Yeah, I see it now in the kernel proper. (sorry for the noise)
> >
> > Wouldn't it make sense to move this somewhere else then? and add a
> > __initcall() for it? We should only need to check for it once - it would
> > make things insignificantly faster, and smaller :)
> 
> Patch welcome.

I looked at this:

> static inline int check_modstruct_version(Elf_Shdr *sechdrs,
>                                           unsigned int versindex,
>                                           struct module *mod)
> {
>         const unsigned long *crc;
>
>         if (!find_symbol(MODULE_SYMBOL_PREFIX "module_layout", NULL,
>                          &crc, true, false))
>                 BUG();
>         return check_version(sechdrs, versindex, "module_layout", mod, crc); }

and then decided that since you need to call find_symbol() to populate 
the crc, before it is used in check_version(), you might as well leave
alone (it wouldn't result in any smaller/faster code)...

So, I didn't send anything...
