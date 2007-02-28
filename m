Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbXB1Ih4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbXB1Ih4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 03:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbXB1Ih4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 03:37:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45819 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbXB1Ihq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 03:37:46 -0500
Date: Wed, 28 Feb 2007 09:30:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 06/26] Xen-paravirt_ops: paravirt_ops: allocate a fixmap slot
Message-ID: <20070228083055.GA8866@elte.hu>
References: <20070227081337.434798469@goop.org> <20070227081631.122933982@goop.org> <20070227101143.GC10827@elte.hu> <45E47E95.2060803@goop.org> <45E4D1B1.7030903@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E4D1B1.7030903@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0607]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > Yes.  vmalloc would have the annoying side-effect of actually 
> > allocating some pages which would be shadowed by the remapping, but 
> > I guess get_vm_area would do the job.  I'll give it a go.
> 
> Hm, this is a bit awkward.  We need to map the shared info page fairly 
> early - say, around paging_init - but we're still on the bootmem 
> allocator at that point, so get_vm_area isn't usable yet.  Using a 
> fixmap keeps things simple.  It seems to me that having a single 
> fixmap available is useful for this kind of simple/early mapping, and 
> if someone needs to map something larger, then they can put it off 
> until get_vm_area() is available...

fair enough. Please rename it to FIX_PARAVIRT_BOOTUP - you can still 
rely on it being available later on too, but we'd like to give everyone 
the right fundamental idea about this: it's meant to be a limited, 
inflexible interface for bootstrap only.

	Ingo
