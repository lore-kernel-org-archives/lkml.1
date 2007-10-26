Return-Path: <linux-kernel-owner+w=401wt.eu-S1759031AbXJZJ4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031AbXJZJ4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbXJZJ40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:56:26 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:21565 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbXJZJ4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:56:25 -0400
X-IronPort-AV: i="4.21,332,1188792000"; 
   d="scan'208"; a="42485075:sNHT28177401"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: David Woodhouse <dwmw2@infradead.org>, Jon Loeliger <jdl@freescale.com>
Subject: Re: history of extratext sections?
Date: Fri, 26 Oct 2007 05:57:32 -0400
User-Agent: KMail/1.9.5
Cc: paulus@samba.org, linux-kernel@vger.kernel.org
References: <200710240836.13412.rgetz@blackfin.uclinux.org>
In-Reply-To: <200710240836.13412.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260557.32641.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 26 Oct 2007 09:56:23.0705 (UTC) FILETIME=[77899090:01C817B6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24 Oct 2007 08:36, Robin Getz pondered:
> Paul:
> 
> I noticed that when passing a zero address to kallsyms_lookup(), the
> kernel thought it was a valid kernel address, even if it was not for the
> specific architecture it was running on.
> 
> This was because is_kernel_extratext() was checking against labels that
> don't exist on many archs. Since PPC is the only kernel which defines
> _extra_text, (which doesn't seem to be used anymore?) there are three options:
>  - make the check dependant on PPC
>  - make the check dependant on extratext being populated
>  - remove _extra_text support from:
>     linux-2.6.x/arch/ppc/kernel/vmlinux.lds.S
>     linux-2.6.x/include/asm-generic/sections.h
>     linux-2.6.x/kernel/kallsyms.c
>     linux-2.6.x/scripts/kallsyms.c
> 
> Since I don't know the history on that label I thought I would ask
> (since PPC seem to be the only arch using it) before I sent a patch.

OK, it looks like:

David Woodhouse added this functionality 5 May 2005:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=075d6eb16d273dab7b7b4b83fcee8bce4ee387ed

and then Jon Loeliger removed everything in this section 17 Sep 2005
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=6c45ab992e4299c869fb26427944a8f8ea177024

David/Jon:

Is this section still used on PPC, or can the entire support for extratext be removed?

Thanks
