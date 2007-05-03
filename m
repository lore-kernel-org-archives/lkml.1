Return-Path: <linux-kernel-owner+w=401wt.eu-S1031123AbXECN07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031123AbXECN07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031240AbXECN07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:26:59 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59890 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031123AbXECN06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:26:58 -0400
From: Kevin Corry <kevcorry@us.ibm.com>
Organization: IBM
To: michael@ellerman.id.au
Subject: Re: [PATCH 2/2] powerpc: change topology_init() to a subsys_initcall
Date: Thu, 3 May 2007 08:26:54 -0500
User-Agent: KMail/1.9.5
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Stephane Eranian <eranian@hpl.hp.com>, Carl Love <carll@us.ibm.com>
References: <200705021208.59068.kevcorry@us.ibm.com> <200705021211.49331.kevcorry@us.ibm.com> <1178154707.5338.11.camel@concordia.ozlabs.ibm.com>
In-Reply-To: <1178154707.5338.11.camel@concordia.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705030826.55427.kevcorry@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Wed May 2 2007 8:11 pm, Michael Ellerman wrote:
> On Wed, 2007-05-02 at 12:11 -0500, Kevin Corry wrote:
> > Change the powerpc version of topology_init() from an __initcall to
> > a subsys_initcall to match all other architectures.
> >
> > Signed-off-by: Kevin Corry <kevcorry@us.ibm.com>
> >
> > Index: linux-2.6.21/arch/powerpc/kernel/sysfs.c
> > ===================================================================
> > --- linux-2.6.21.orig/arch/powerpc/kernel/sysfs.c
> > +++ linux-2.6.21/arch/powerpc/kernel/sysfs.c
> > @@ -498,4 +498,4 @@ static int __init topology_init(void)
> >
> >  	return 0;
> >  }
> > -__initcall(topology_init);
> > +subsys_initcall(topology_init);
>
> topology_init() depends on the register_one_node() stuff being
> available, which relies on register_node_type() being called AFAICT -
> which is a postcore_initcall(). So that's OK.
>
> It also creates sysfs files, which is OK because long before initcalls
> run vfs_caches_init() called mnt_init() which called sysfs_init().
>
> Just to be super safe it'd be good to diff your sysfs before and after
> the change. But assuming that show's nothing this looks fine to me.

I booted with and without this patch applied, and the file listings of /sys on 
both kernels show no differences (other than timestamps).

Thanks for the feedback.
-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
