Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbYJXOze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbYJXOze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYJXOz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:55:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbYJXOzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:55:25 -0400
Date: Fri, 24 Oct 2008 07:53:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Keith Packard <keithp@keithp.com>
cc: benh@kernel.crashing.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, nickpiggin@yahoo.com.au, airlied@linux.ie,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, yinghai@kernel.org,
       Peter Anvin <hpa@zytor.com>
Subject: Re: Adding kmap_atomic_prot_pfn  (was: [git pull] drm patches for
 2.6.27-rc1)
In-Reply-To: <1224826660.22877.83.camel@koto.keithp.com>
Message-ID: <alpine.LFD.2.00.0810240752300.3287@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>  <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com>  <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com>  <1224398496.5303.7.camel@koto.keithp.com>
 <20081019175320.GA6442@elte.hu>  <1224450291.5303.23.camel@koto.keithp.com> <20081020115810.GC10594@elte.hu>  <1224517744.5195.1.camel@koto.keithp.com> <20081022093615.GF12453@elte.hu>  <1224793332.22877.8.camel@koto.keithp.com> 
 <20081023133840.d4eef579.akpm@linux-foundation.org>  <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org>  <1224813015.22877.51.camel@koto.keithp.com>  <alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org>  <1224818645.7654.431.camel@pasglop>
 <1224826660.22877.83.camel@koto.keithp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Oct 2008, Keith Packard wrote:
> 
> I'm fine with sticking the mapping in a separate structure; it's just
> the return from ioremap_wc on 64-bit systems, and nothing at all on
> 32-bit systems.

Actually, on 32-bit, the 'prot' should be there, as should the starting 
physical page. Otherwise the two interfaces would be very odd, and you'd 
have to repeat those arguments in all callers (ie both in "prepare" and 
in the actual "access").

			Linus
