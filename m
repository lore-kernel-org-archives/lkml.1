Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbZEDLKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbZEDLKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 07:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbZEDLKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 07:10:21 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:35854 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbZEDLKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 07:10:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T3VyikVoZYSwcJhYiPo0UVJlwsqHVJlEby3aZlPMAyicVvu3aqFx6X7PW44LvecxLA
         XeIgZI3UjkGYunjlcxIemW00/RG+IPPA3kEaEvEN+djVlgE/dubariZG4yj+hJU5gtid
         1O+//TxS/EoBLd3d6iyruS39PsySj24CyNC/s=
Date: Mon, 4 May 2009 15:10:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: introducing __GFP_PANIC
Message-ID: <20090504111014.GG4173@lenovo>
References: <84144f020905031038n751b48afsaefc3765ed632f82@mail.gmail.com> <20090503204542.GJ4615@lenovo> <alpine.DEB.2.00.0905031357140.17811@chino.kir.corp.google.com> <20090504081454.GA4173@lenovo> <1241425941.21088.19.camel@penberg-laptop> <20090504090825.GC4173@lenovo> <1241431031.21088.21.camel@penberg-laptop> <20090504100106.GD4173@lenovo> <20090504101121.GE4173@lenovo> <alpine.DEB.2.00.0905040353290.24987@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905040353290.24987@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[David Rientjes - Mon, May 04, 2009 at 03:56:10AM -0700]
| On Mon, 4 May 2009, Cyrill Gorcunov wrote:
| 
| > @@ -1685,7 +1687,12 @@ nopage:
| >  		dump_stack();
| >  		show_mem();
| >  	}
| > -	return page;
| > +	if (unlikely((gfp_mask & __GFP_PANIC))) {
| 
| Too many parentheses and this doesn't need the unnecessary braces.

Thanks David, fixed (old games /with other flags/ rudiment).

| 
| > +		panic("Out of memory: panic due to __GFP_PANIC.\n"
| > +			"%s order:%d, mode:0x%x\n", p->comm,
| > +			order, gfp_mask);
| 
| The extra newline in this statement doesn't seem necessary, it's just one 
| less line that will be visible on the frozen screen.  I also think calling 
| this 'gfp_mask' instead of 'mode' is more appropriate just like the oom 
| killer does.

ok, convinced. Maybe even make it shorter like
"Panic due to __GFP_PANIC: %s order:%d, gfp_mask:0x%x\n"
Hmm?

| 
| > +	}
| > +	return NULL;
| >  got_pg:
| >  	if (kmemcheck_enabled)
| >  		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
| > 
| 
	-- Cyrill
