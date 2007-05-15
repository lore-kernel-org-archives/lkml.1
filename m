Return-Path: <linux-kernel-owner+w=401wt.eu-S934088AbXEOJVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088AbXEOJVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 05:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760276AbXEOJVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 05:21:18 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:47409 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759876AbXEOJVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 05:21:17 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH 1/2] kbuild: Add "Section mismatch" warning whitelist for powerpc
Date: Tue, 15 May 2007 17:22:56 +0800
Message-ID: <989B956029373F45A0B8AF0297081890B76040@zch01exm26.fsl.freescale.net>
In-Reply-To: <a781481a0705141717v2669805aoa590bfd54da7856b@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] kbuild: Add "Section mismatch" warning whitelist for powerpc
Thread-Index: AceWhnRcRVxuzJABRxiAw0CTQNFTJgASTCUQ
From: "Li Yang-r58472" <LeoLi@freescale.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Kumar Gala" <galak@kernel.crashing.org>
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Linus" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Satyam Sharma [mailto:satyam.sharma@gmail.com]
> Sent: Tuesday, May 15, 2007 8:18 AM
> To: Kumar Gala
> Cc: Sam Ravnborg; Li Yang-r58472; Linus; Andrew Morton; Linux Kernel;
> linuxppc-dev@ozlabs.org
> Subject: Re: [PATCH 1/2] kbuild: Add "Section mismatch" warning
whitelist for
> powerpc
> 
> Hi,
> 
> On 5/14/07, Kumar Gala <galak@kernel.crashing.org> wrote:
> >
> > On May 14, 2007, at 6:06 AM, Sam Ravnborg wrote:
> >
> > > On Mon, May 14, 2007 at 06:53:32PM +0800, Li Yang wrote:
> > >> This patch fixes the following "Section mismatch" warnings when
> > >> build powerpc platforms.
> > >>
> > >> -------------
> > >> WARNING: arch/powerpc/mm/built-in.o - Section mismatch: reference
to
> > >> .init.text:early_get_page from .text between
> > >> 'pte_alloc_one_kernel' (at
> > >> offset 0xc68) and 'pte_alloc_one'
> > >> WARNING: mm/built-in.o - Section mismatch: reference to
> > >> .init.text:set_up_list3s from .text between
> > >> 'kmem_cache_create' (at offset
> > >> 0x20300) and 'cache_reap'
> > >> -------------
> >
> > This warnings should be handled by __init_refok instead.
> 
> Actually, once __init_refok comes in, would we need any other
> whitelisting mechanism at all? I think the exception patterns in
> secref_whitelist() and those two other whitelisting functions
> (init_section_ref_ok and exit_section_ref_ok) could all be
> subsumed and made redundant if / when __init_refok is used
> in the actual sources.

I don't think so.  __init_refok can be used to mark special functions
which are legitimate to reference .init.text/.init.data but cannot be
used to mark special sections.

- Leo
