Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZIRFCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZIRFCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 01:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbZIRFCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 01:02:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbZIRFCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 01:02:39 -0400
Date: Fri, 18 Sep 2009 01:02:37 -0400 (EDT)
From: Miroslav Rezanina <mrezanin@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Message-ID: <255160165.266571253250157721.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <625566043.266451253249879910.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Re: [Xen-devel] Re: [PATCH][v2.6.29][XEN] Return unused memory to
 hypervisor
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

> From: "Jeremy Fitzhardinge" <jeremy@goop.org>
> To: "Miroslav Rezanina" <mrezanin@redhat.com>
> Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
> Sent: Thursday, September 17, 2009 6:47:10 PM GMT +01:00 Amsterdam / Berlin / Bern / Rome / Stockholm / Vienna
> Subject: Re: [Xen-devel] Re: [PATCH][v2.6.29][XEN] Return unused memory to hypervisor
>
> On 09/17/09 01:14, Miroslav Rezanina wrote:
> > Hi Jeremy,
> > I check your application. It won't work correctly. You are calling
> return_unused_memory in xen_memory_setup that is too soon.
> > When you are calling it, there is no hole in map in any case.
> Calling should be in xen_post_allocator_init function (in
> arch/x86/xen/mmu.c).
> >   
> 
> OK.  Where does the e820 map get changed in the meantime?
> 
xen_memory_setup just set RAM map from 0 to initial nr_pages. Only one place I'm sure map is changed is
parsing mem parameter. You mentioned that there can be other cases when some parts of map are removed.
>     J
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel

-- 
Miroslav Rezanina
Software Engineer - Virtualization Team - XEN kernel

