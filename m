Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbYJWV0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbYJWV0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYJWVZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:25:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752296AbYJWVZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:25:52 -0400
Date: Thu, 23 Oct 2008 14:24:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Keith Packard <keithp@keithp.com>, mingo@elte.hu, nickpiggin@yahoo.com.au,
       airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, yinghai@kernel.org
Subject: Re: Adding kmap_atomic_prot_pfn  (was: [git pull] drm patches for
 2.6.27-rc1)
In-Reply-To: <20081023133840.d4eef579.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org> <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com> <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com> <1224398496.5303.7.camel@koto.keithp.com>
 <20081019175320.GA6442@elte.hu> <1224450291.5303.23.camel@koto.keithp.com> <20081020115810.GC10594@elte.hu> <1224517744.5195.1.camel@koto.keithp.com> <20081022093615.GF12453@elte.hu> <1224793332.22877.8.camel@koto.keithp.com>
 <20081023133840.d4eef579.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 23 Oct 2008, Andrew Morton wrote:
> 
> Given that all highmem-implementing archtiectures must use the same
> declaration here, we might as well put it into include/linux/highmem.h.
> Although that goes against current mistakes^Wcode.
> 
> Does powerpc32 still implement highmem?  It seems that way.  You broke
> it, no?

This really shouldn't be in highmem.h AT ALL.

The whole point of that function has absolutely nothing to do with 
highmem, and it *must* be useful on non-highmem configurations to be 
appropriate.

So I'd much rather create a new <linux/kmap.h> or something. Or just 
expose this from to <asm/fixmap.h> or something. Let's not confuse this 
with highmem, even if the implementation _historically_ was due to that.

			Linus
