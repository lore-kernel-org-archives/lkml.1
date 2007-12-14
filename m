Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbXLNPoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbXLNPoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbXLNPoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:44:07 -0500
Received: from waste.org ([66.93.16.53]:36513 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbXLNPoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:44:06 -0500
Date: Fri, 14 Dec 2007 09:42:42 -0600
From: Matt Mackall <mpm@selenic.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: remove __read_mostly
Message-ID: <20071214154242.GC19691@waste.org>
References: <20071213222044.GH21616@stusta.de> <20071214152454.GR17536@waste.org> <4762A35C.8020901@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4762A35C.8020901@cosmosbay.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 04:38:04PM +0100, Eric Dumazet wrote:
> Matt Mackall a ?crit :
> >On Thu, Dec 13, 2007 at 11:20:44PM +0100, Adrian Bunk wrote:
> >  
> >>I tried the following patch with a full x86 .config [1]:
> >>
> >>--- a/include/asm-x86/cache.h
> >>+++ b/include/asm-x86/cache.h
> >>-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
> >>+/* #define __read_mostly 
> >>__attribute__((__section__(".data.read_mostly"))) */
> >>
> >>The result [2,3] was:
> >>
> >>-rwxrwxr-x 1 bunk bunk 46607243 2007-12-13 19:50 vmlinux.old
> >>-rwxrwxr-x 1 bunk bunk 46598691 2007-12-13 21:55 vmlinux
> >>
> >>It's not a surprise that the kernel can become bigger when __read_mostly 
> >>gets used, especially in cases where __read_mostly prevents gcc 
> >>optimizations.
> >>
> >>My question is:
> >>Is there anywhere in the kernel a case where __read_mostly brings a 
> >>measurable improvement or can it be removed?
> >>    
> >
> >Yes, but perhaps we can put it under CONFIG_BASE_FULL?
> >
> >  
> Yes, we probably can do something like that (in addition to !CONFIG_SMP)

Excellent point. If either CONFIG_BASE_FULL or CONFIG_SMP are not set,
we should not define __read_mostly.

-- 
Mathematics is the supreme nostalgia of our time.
