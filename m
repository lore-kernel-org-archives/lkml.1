Return-Path: <linux-kernel-owner+w=401wt.eu-S965268AbXCENfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965268AbXCENfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965681AbXCENfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:35:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:52976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965268AbXCENfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:35:04 -0500
Date: Mon, 5 Mar 2007 15:34:37 +0100
From: Andi Kleen <ak@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Andi Kleen <ak@suse.de>, virtualization <virtualization@lists.osdl.org>
Subject: Re: [patch] paravirt: VDSO page is essential
Message-ID: <20070305143437.GF22829@bingen.suse.de>
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173101297.26165.39.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> VDSO is only a problem if (1) the hypervisor wants to reserve the top
> virtual address space (CONFIG_PARAVIRT=y), and (2) the glibc is old and

It broke the boot even with native hardware, no hypervisor

>  
> +config RESERVE_TOP
> +	bool
> +	help
> +	  Many hypervisors want to reserve some amount of the top of
> +	  virtual address space.  Unfortunately, old glibc needs the
> +	  vdso page there, so we must disable vdso if COMPAT_VDSO is
> +	  enabled as well as this option.

But this still means I would need to decide between a PARAVIRT
kernel that either supports xen/VMI or cannot boot old user land without
weird options.  I don't think that's the correct solution. The goal
is a single binary that runs everywhere and is still compatible.

What would probably work is to somehow decide at runtime if a hypervisor
is there or not and then set vdso default based on that. I guess that
detection would be hypervisor specific though and probably would
need paravirt ops extensions.

-Andi

