Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYKFVui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYKFVui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbYKFVty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:49:54 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:55958 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbYKFVtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:49:52 -0500
Date: Thu, 6 Nov 2008 22:48:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Takashi Iwai <tiwai@suse.de>, Tony Luck <tony.luck@intel.com>,
       Isaku Yamahata <yamahata@valinux.co.jp>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix section type conflict in arch/ia64/xen/xen_pv_ops.c
Message-ID: <20081106214848.GA3579@uranus.ravnborg.org>
References: <s5h1vxou7gf.wl%tiwai@suse.de> <49133E11.8050607@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49133E11.8050607@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 10:57:21AM -0800, Jeremy Fitzhardinge wrote:
> Takashi Iwai wrote:
> >__initdata and const cannot be always a happy pair, as gcc-4.3.3 gives
> >the compile errors like:
> >
> >  arch/ia64/xen/xen_pv_ops.c:156: error: xen_init_ops causes a section 
> >  type conflict
> >  arch/ia64/xen/xen_pv_ops.c:340: error: xen_iosapic_ops causes a section 
> >  type conflict
> >
> >This patch simply removes const from data with __initdata.
> >  
> 
> Yeah, I've seen these sort of messages before, but I don't see why 
> there's an inherent problem with having const __initdata.
> 
> Sam?

The root problem here is that in some cases gcc will stuff this into
a section marked CONST and in other cases not.
So when we manually specify the section we better not mix const and
non-const stuff in the same section.
The problem is that it is very gcc dependent. I have with powerpc
seen that the same code was not put in CONST with a 32 bit build,
but with the 64 bit build it was.
The only cure was to remove the const and use initdata.
You can try to play with initconst - and it may work.
But you need to have pretty good build coverage to be sure.

	Sam
