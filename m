Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbXCEUL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbXCEUL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbXCEUL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:11:27 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53059 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843AbXCEUL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:11:26 -0500
Message-ID: <45EC796D.5050705@vmware.com>
Date: Mon, 05 Mar 2007 12:11:25 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       virtualization <virtualization@lists.osdl.org>
Subject: Re: [patch] paravirt: VDSO page is essential
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain> <20070305143437.GF22829@bingen.suse.de>
In-Reply-To: <20070305143437.GF22829@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> But this still means I would need to decide between a PARAVIRT
> kernel that either supports xen/VMI or cannot boot old user land without
> weird options.  I don't think that's the correct solution. The goal
> is a single binary that runs everywhere and is still compatible.
>   

Rusty's patch looks a step in the right direction to me.  I can't 
comment on Ingo's patch as he failed to -cc me on it, despite the fact 
that we are the only ones affected by it.  We are not concerned so much 
with supporting legacy user land deployments, as we expect for the most 
part, the install scenario to happen when upgrading to new distros.

> What would probably work is to somehow decide at runtime if a hypervisor
> is there or not and then set vdso default based on that. I guess that
> detection would be hypervisor specific though and probably would
> need paravirt ops extensions.
>   

What we really need to do is to be able to detect an old user land and 
drop VDSO support when that is found.  But since we can't do that, the 
next best thing is to allow the hypervisor to choose whatever workaround 
it wants when it moves the fixmap and compat_vdso was enabled.  In our 
case, the workaround we will want is a boot option to disable VDSO for 
old user land, and a printk warning if you take #GPs and kill the init 
proc, because for us, this is not an expected support scenario.  We 
would much rather support the VDSO by default in paravirt kernels even 
with COMPAT_VDSO turned on.

Zach
