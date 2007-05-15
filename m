Return-Path: <linux-kernel-owner+w=401wt.eu-S1760762AbXEOARn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762AbXEOARn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 20:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbXEOARh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 20:17:37 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:27545 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860AbXEOARg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 20:17:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h14s7ecDFNcri0Zl6+kKbWiH0MB9ScotfJG5Mm7290bOU7uLCPmtpUCZyGGp4VWZXwfT4+Z/mDxdO+zVtFkDkiW3hXpCsl0wrMW0RSHGhk53esTqmRSh5c3fBW8IOLYPZgCiBc9BvLtADQ0vYVt8PspCqvDjbGO0+e8rOnJmNHI=
Message-ID: <a781481a0705141717v2669805aoa590bfd54da7856b@mail.gmail.com>
Date: Tue, 15 May 2007 05:47:34 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Kumar Gala" <galak@kernel.crashing.org>
Subject: Re: [PATCH 1/2] kbuild: Add "Section mismatch" warning whitelist for powerpc
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Li Yang" <leoli@freescale.com>,
       Linus <torvalds@linux-foundation.org>, "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
In-Reply-To: <3DF58590-DFD9-4665-8C47-33F407AAD1E7@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46483FAC.60503@freescale.com>
	 <20070514110636.GB10143@uranus.ravnborg.org>
	 <3DF58590-DFD9-4665-8C47-33F407AAD1E7@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 5/14/07, Kumar Gala <galak@kernel.crashing.org> wrote:
>
> On May 14, 2007, at 6:06 AM, Sam Ravnborg wrote:
>
> > On Mon, May 14, 2007 at 06:53:32PM +0800, Li Yang wrote:
> >> This patch fixes the following "Section mismatch" warnings when
> >> build powerpc platforms.
> >>
> >> -------------
> >> WARNING: arch/powerpc/mm/built-in.o - Section mismatch: reference to
> >> .init.text:early_get_page from .text between
> >> 'pte_alloc_one_kernel' (at
> >> offset 0xc68) and 'pte_alloc_one'
> >> WARNING: mm/built-in.o - Section mismatch: reference to
> >> .init.text:set_up_list3s from .text between
> >> 'kmem_cache_create' (at offset
> >> 0x20300) and 'cache_reap'
> >> -------------
>
> This warnings should be handled by __init_refok instead.

Actually, once __init_refok comes in, would we need any other
whitelisting mechanism at all? I think the exception patterns in
secref_whitelist() and those two other whitelisting functions
(init_section_ref_ok and exit_section_ref_ok) could all be
subsumed and made redundant if / when __init_refok is used
in the actual sources.

Satyam
