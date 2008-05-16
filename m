Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbYEPHBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbYEPHBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 03:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYEPHAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 03:00:54 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:38457 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYEPHAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 03:00:52 -0400
Date: Fri, 16 May 2008 09:00:48 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, torvalds@linux-foundation.org,
       zippel@linux-m68k.org, schwab@suse.de, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH] init - fix building bug and potential buffer overflow
In-Reply-To: <20080515134928.83b2d948.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805160900030.22059@anakin>
References: <20080514154402.GF6902@cvg> <20080515105803.7c9ab8c7.akpm@linux-foundation.org>
 <20080515180528.GC7481@cvg> <Pine.LNX.4.64.0805152132530.22059@anakin>
 <aa79d98a0805151322s20a2bb34x4491bcacfcef310@mail.gmail.com>
 <20080515134928.83b2d948.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Andrew Morton wrote:
> On Fri, 16 May 2008 00:22:14 +0400
> "Cyrill Gorcunov" <gorcunov@gmail.com> wrote:
> > On 5/15/08, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > On Thu, 15 May 2008, Cyrill Gorcunov wrote:
> > >> [Andrew Morton - Thu, May 15, 2008 at 10:58:03AM -0700]
> > >> | On Wed, 14 May 2008 19:44:02 +0400 Cyrill Gorcunov <gorcunov@gmail.com>
> > >> wrote:
> > >> strlcat there but it seems it would fail to build too. Originally I've
> > >> messed
> > >> strlcat with strncat :(
> > >
> > > Actually it build and runs fine after s/strncat/strlcat/...
> > >
> 
> (top-posting repaired)
> 
> > Could you please make an update to the patch? I can make it only
> > tomorrow evening (ie not that fast)
> 
> Like this?

Builds and boots fine!

> From: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> This patch fixes a build bug on m68k - gcc decides to emit a call to the
> strlen library function, which we don't implement.  Use strlcat() instead.
> 
> 
> What is more important - my previous patch
> 
> commit e662e1cfd434aa234b72fbc781f1d70211cb785b
> Author: Cyrill Gorcunov <gorcunov@gmail.com>
> Date:   Mon May 12 14:02:22 2008 -0700
> 
>     init: don't lose initcall return values
> 
> Has introduced potential buffer overflow by wrong calculation of string
> accumulator size.
> 
> Many thanks Andreas Schwab and Geert Uytterhoeven for helping
> to catch and fix the bug.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
