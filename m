Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbZEVLSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbZEVLSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 07:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbZEVLSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 07:18:10 -0400
Received: from sh.osrg.net ([192.16.179.4]:43680 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbZEVLSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 07:18:09 -0400
Date: Fri, 22 May 2009 20:17:41 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH -tip v2 0/5] add common functions for struct dma_map_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090522105608.GM9835@amd.com>
References: <1242359705-2117-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20090522195446L.fujita.tomonori@lab.ntt.co.jp>
	<20090522105608.GM9835@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090522201751A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 22 May 2009 20:17:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009 12:56:08 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Fri, May 22, 2009 at 07:54:35PM +0900, FUJITA Tomonori wrote:
> > On Fri, 15 May 2009 12:55:00 +0900
> > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > We unified x86 and IA64's handling of multiple dma mapping operations
> > > (struct dma_map_ops in linux/dma-mapping.h) so we can remove
> > > duplication in their arch/include/asm/dma-mapping.h.
> > > 
> > > This patchset adds include/asm-generic/dma-mapping-common.h that
> > > provides some generic dma mapping function definitions for the users
> > > of struct dma_map_ops. This enables us to remove about 100 lines. This
> > > also enables us to easily add CONFIG_DMA_API_DEBUG support, which only
> > > x86 supports for now. The 4th patch adds CONFIG_DMA_API_DEBUG support
> > > to IA64 by adding only 8 lines.
> > > 
> > > This is against tip/master since tip has some changes to
> > > arch/x86/include/asm/dma-mapping.h.
> > > 
> > > The changes since the first version are
> > > 
> > > - fixed a bug that dma_attrs is not passed properly (thanks to Arnd
> > > Bergmann).
> > > 
> > > - used a new name, dma-mapping-common.h, instead of dma-mapping.h
> > > (suggested by Arnd Bergmann).
> > > 
> > > - added Joerg's Acked-by
> > > 
> > > =
> > >  arch/ia64/Kconfig                        |    1 +
> > >  arch/ia64/include/asm/dma-mapping.h      |  110 ++----------------
> > >  arch/x86/Kconfig                         |    1 +
> > >  arch/x86/include/asm/dma-mapping.h       |  174 +---------------------------
> > >  include/asm-generic/dma-mapping-common.h |  190 ++++++++++++++++++++++++++++++
> > >  lib/dma-debug.c                          |   82 ++++++++------
> > >  6 files changed, 252 insertions(+), 306 deletions(-)
> > 
> > Ping,
> > 
> > Any comments?
> >
> 
> I already acked the patches :)

Oops, I kept you CC'ed but asked Ingo and Tony. I should have been
explicit.
