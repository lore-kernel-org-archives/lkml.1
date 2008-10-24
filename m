Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbYJXDWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbYJXDWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 23:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYJXDV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 23:21:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:40894 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbYJXDV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 23:21:58 -0400
Subject: Re: Adding kmap_atomic_prot_pfn  (was: [git pull] drm patches for
	2.6.27-rc1)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Keith Packard <keithp@keithp.com>, mingo@elte.hu,
       nickpiggin@yahoo.com.au, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, yinghai@kernel.org
In-Reply-To: <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com>
	 <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com>
	 <1224398496.5303.7.camel@koto.keithp.com> <20081019175320.GA6442@elte.hu>
	 <1224450291.5303.23.camel@koto.keithp.com> <20081020115810.GC10594@elte.hu>
	 <1224517744.5195.1.camel@koto.keithp.com> <20081022093615.GF12453@elte.hu>
	 <1224793332.22877.8.camel@koto.keithp.com>
	 <20081023133840.d4eef579.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 14:21:14 +1100
Message-Id: <1224818474.7654.429.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-23 at 14:24 -0700, Linus Torvalds wrote:
> The whole point of that function has absolutely nothing to do with 
> highmem, and it *must* be useful on non-highmem configurations to be 
> appropriate.
> 
> So I'd much rather create a new <linux/kmap.h> or something. Or just 
> expose this from to <asm/fixmap.h> or something. Let's not confuse
> this 
> with highmem, even if the implementation _historically_ was due to
> that.

Well, on powerpc, we just went (or rather, Kumar just went) through the
oops of implementing fixmap and then kmap on top of it... just because
we wanted kmap_atomic functionality on non-highmem platforms :-) (and
the fixmap approach has some other interesting features).

So yes, I agree. Typically very useful for any 32-bit processor with a
memory mapped PCI Express config space since it's something like 256M of
virtual space to map it all iirc.

Cheers,
Ben.

