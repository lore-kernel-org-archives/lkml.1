Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbXCEURz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbXCEURz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXCEURy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:17:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbXCEURy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:17:54 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Zachary Amsden <zach@vmware.com>
Subject: Re: [patch] paravirt: VDSO page is essential
Date: Mon, 5 Mar 2007 21:16:42 +0100
User-Agent: KMail/1.9.5
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       virtualization <virtualization@lists.osdl.org>
References: <20070305120631.GA14105@elte.hu> <20070305143437.GF22829@bingen.suse.de> <45EC796D.5050705@vmware.com>
In-Reply-To: <45EC796D.5050705@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703052116.42807.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 We are not concerned so much 
> with supporting legacy user land deployments,

I am concerned about that. I won't merge any patches that break compatibility
by default.

> > What would probably work is to somehow decide at runtime if a hypervisor
> > is there or not and then set vdso default based on that. I guess that
> > detection would be hypervisor specific though and probably would
> > need paravirt ops extensions.
> >   
> 
> What we really need to do is to be able to detect an old user land and 
> drop VDSO support when that is found.  

Rusty implemented that, but it was widely considered too ugly
(and it was not 100% reliable e.g. with chroots) 

> But since we can't do that, the  
> next best thing is to allow the hypervisor to choose whatever workaround 
> it wants when it moves the fixmap and compat_vdso was enabled.  In our 
> case, the workaround we will want is a boot option to disable VDSO for 
> old user land,

The boot option is already there, but boot options for is not my
idea of user friendly binary compatibility.

> and a printk warning if you take #GPs and kill the init  
> proc, because for us, this is not an expected support scenario.  We 
> would much rather support the VDSO by default in paravirt kernels even 
> with COMPAT_VDSO turned on.

But you can't have it at the compatible fixed address, right?

-Andi
