Return-Path: <linux-kernel-owner+w=401wt.eu-S933584AbXCPMBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584AbXCPMBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 08:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933592AbXCPMBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 08:01:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39693 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933584AbXCPMBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 08:01:10 -0400
Date: Fri, 16 Mar 2007 12:00:49 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Adrian Bunk <bunk@stusta.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 20/26] Xen-paravirt_ops: Core Xen implementation
Message-ID: <20070316120049.GA22072@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
	Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
	xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
	Zachary Amsden <zach@vmware.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Ian Pratt <ian.pratt@xensource.com>,
	Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
	Adrian Bunk <bunk@stusta.de>, Thomas Gleixner <tglx@linutronix.de>
References: <20070301232443.195603797@goop.org> <20070301232528.812011702@goop.org> <20070316091411.GF23174@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316091411.GF23174@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 10:14:11AM +0100, Ingo Molnar wrote:
> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Core Xen Implementation
> > 
> > This patch is a rollup of all the core pieces of the Xen 
> > implementation, including booting, memory management, interrupts, time 
> > and so on.
> 
> > --- a/arch/i386/kernel/head.S
> > +++ b/arch/i386/kernel/head.S
> > @@ -535,6 +535,10 @@ unhandled_paravirt:
> >  	ud2
> >  #endif
> >  
> > +#ifdef CONFIG_XEN
> > +#include "../xen/xen-head.S"
> > +#endif
> 
> i'd suggest to remove the #ifdef and push it into xen-head.S.

Even better would be an explanation of why this needs to be included
at all.  Life would be much simpler if this was simply a totally
separate file.

