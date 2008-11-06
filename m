Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbYKFWba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbYKFWba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYKFWbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:31:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:48276 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbYKFWbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:31:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dMOBjuvXkRIfjmvvZeb+iCRhJj//AMJFWq4XIOgtXR2oDBSjbdFYiIgNoJIJOvbCdS
         ff7u6gHyu0bMC4YfiAEztW6jxDrKN8RhJVaJGZ1WdLfkFJiwkRieacQc+/MWF2qZ5K3t
         mhqctXNdf0vlQgODSYDgKX2zvGQv+yS5f7bdI=
Date: Fri, 7 Nov 2008 01:34:17 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: next-20081106: undefined reference to `__per_cpu_start'
Message-ID: <20081106223417.GA26686@x200.localdomain>
References: <20081106173645.e7e79071.sfr@canb.auug.org.au> <20081106183939.GA26925@x200.localdomain> <Pine.LNX.4.64.0811061310350.6009@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811061310350.6009@quilx.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 01:15:07PM -0600, Christoph Lameter wrote:
> On Thu, 6 Nov 2008, Alexey Dobriyan wrote:
> 
> > On blackfin-BF526-EZBRD and other blackfins:
> >
> >   LD      .tmp_vmlinux1
> > mm/built-in.o: In function `cpu_alloc_init':
> > (.init.text+0x1486): undefined reference to `__per_cpu_start'
> > mm/built-in.o: In function `cpu_alloc_init':
> > (.init.text+0x148c): undefined reference to `__per_cpu_start'
> > mm/built-in.o: In function `cpu_alloc_init':
> > (.init.text+0x1492): undefined reference to `__per_cpu_end'
> > mm/built-in.o: In function `cpu_alloc_init':
> > (.init.text+0x1496): undefined reference to `__per_cpu_end'
> 
> Any contigencies for __per_cpu_start/end in your blackfin vmlinux.lds.h?
> That is where these symbols are defined
> 
> Or did you use generic percpu support and set
> CONFIG_HAVE_ZERO_BASED_PER_CPU?

References are coming from PERCPU_AREA_SIZE.

This works, but I have no idea if this correct:

--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -51,6 +51,8 @@
 #define DEFINE_PER_CPU_FIRST(type, name)				\
 	DEFINE_PER_CPU(type, name)
 
+#define PERCPU_AREA_SIZE 0
+
 #endif /* !CONFIG_SMP */
 
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
