Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbZFSMvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbZFSMvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 08:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZFSMvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 08:51:03 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:19937 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbZFSMvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 08:51:02 -0400
X-IronPort-AV: E=Sophos;i="4.42,252,1243828800"; 
   d="scan'208";a="371329"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: module version magic and arches with symbol prefixes
Date: Fri, 19 Jun 2009 08:54:12 -0400
User-Agent: KMail/1.9.5
CC: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <8bd0f97a0906180824y17a00110i57565aee16207e5@mail.gmail.com> <200906191508.06537.rusty@rustcorp.com.au>
In-Reply-To: <200906191508.06537.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200906190854.13052.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 19 Jun 2009 12:51:03.0525 (UTC) FILETIME=[9AACB150:01C9F0DC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 19 Jun 2009 01:38, Rusty Russell pondered:
> On Fri, 19 Jun 2009 12:54:44 am Mike Frysinger wrote:
> > the current check_modstruct_version() does this:
> > {
> >     const unsigned long *crc;
> >
> >     if (!find_symbol("module_layout", NULL, &crc, true, false))
> >         BUG();
> >     return check_version(sechdrs, versindex, "module_layout", mod, crc);
> > }
> > the trouble here is that it looks for a literal "module_layout" symbol
> > and for ports that have symbol prefixes (a quick check shows Blackfin
> > & h8300), this aint going to work.
> 
> MODULE_SYMBOL_PREFIX is the fix for this, ie:
> 
> 	if (!find_symbol(MODULE_SYMBOL_PREFIX "module_layout), ...
> 
> > also, using BUG() here seems pretty damn harsh.  wouldnt it make more
> > sense to do something like:
> >     if (WARN_ON(!find_symbol("module_layout", NULL, &crc, true, false)))
> >         return 0;
> > this way the module is simply not loaded rather than killing the kernel
> 
> No, it means the kernel didn't build properly.

Or a module didn't build properly.

> Better to fail spectacularly:  
> ideally we'd do this find in an init routine and guarantee a boot crash.

But this isn't an init routine - this is something that runs when a module is 
loaded...

Anyone who can load a module can crash the kernel? I would expect the module 
not to load - but I agree with Mike - it seems a little harsh for someone who 
screwed up their module makefile....

-Robin
