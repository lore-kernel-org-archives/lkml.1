Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbZHFKnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbZHFKnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 06:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZHFKnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 06:43:24 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:39401 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751307AbZHFKnY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 06:43:24 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz1432R98dN4015L1442Jzz1202hzzz32i21ch6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNYB3V-02-6EI-02
X-M-MSG: 
Date: Thu, 6 Aug 2009 12:42:40 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 0/5 v4] x86: Adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090806104240.GC7198@alberich.amd.com>
References: <20090805154402.GA6520@alberich.amd.com> <4A79EA5A.7040308@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A79EA5A.7040308@inria.fr>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 Aug 2009 10:42:40.0869 (UTC) FILETIME=[9F5CA950:01CA1682]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 10:23:54PM +0200, Brice Goglin wrote:
> Andreas Herrmann wrote:
> > Changes to previous patch set:
> > - fixed allnoconfig compile error and link error if CONFIG_PCI=n
> > - fixed hotplug issue: cpumask of siblings sharing same L3 were not
> >   properly updated
> > - properly allocate cpu_node_map
> >
> > Current patch set contains 5 patches:
> > - patch 1 adapts common code to show cpu_node_id,
> >   cpu_node_siblings and cpu_node_siblings_list in
> >   /sys/devices/system/cpu/cpu*/topology
> > - patch 2 prepares arch/x86 to provide cpu_node information
> > - patch 3 sets up cpu_node information for AMD Magny-Cours CPU
> > - patch 4 fixes L3 cache information for Magny-Cours
> > - patch 5 fixes mcheck code for Magny-Cours
> >   
> 
> Hello Andreas,
> 
> Reading your first submission I find something disturbing. You say that
> we'll have the following sibling information:
> 
>   Level        | Set of CPUs
>  --------------|---------------
>   phys_package | core_siblings
>   cpu_node     | cpu_node_siblings
>   core         | thread_siblings
>   thread       | one CPU

> This breaks the existing convention/semantics.

Isn't the existing convention that core_siblings denotes all CPUs on
same socket.

> Currently core/thread_siblings contains the cpumask covering *all*
> siblings of current core/thread object. What you're adding only
> shows the cpumask of current "cpu_node" object in
> cpu_node_siblings. I don't have any preference between both
> semantics, but I think "cpu_node" should use the semantics that
> "core" and "thread" do. So the above should be changed into:

>   Level        | Set of CPUs
>  --------------|---------------
>   phys_package | cpu_node_siblings
>   cpu_node     | core_siblings
>   core         | thread_siblings
>   thread       | one CPU

Of course I thought also to implement it this way because it looks
more consistent, but IMHO the patches are less intrusive if this
scheme is _not_ used. Instead I kept core_siblings as is ("for
historic reasons", nobody needs to accustom to new semantics). And use
cpu_node_siblings where it really matters.

But this reminds me that some documentation is required to describe
the new attributes.

What do others think?


Thanks,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


