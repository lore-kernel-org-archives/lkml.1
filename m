Return-Path: <linux-kernel-owner+w=401wt.eu-S1751985AbYJSSBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbYJSSBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 14:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbYJSSBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 14:01:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:34514 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYJSSBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 14:01:09 -0400
Date: Sun, 19 Oct 2008 11:00:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Keith Packard <keithp@keithp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: io resources and cached mappings (was: [git pull] drm patches
 for 2.6.27-rc1)
Message-ID: <20081019110022.6780923f@infradead.org>
In-Reply-To: <20081019175320.GA6442@elte.hu>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	<200810181237.49784.nickpiggin@yahoo.com.au>
	<1224357062.4384.72.camel@koto.keithp.com>
	<alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	<20081018203741.GA23396@elte.hu>
	<1224366690.4384.89.camel@koto.keithp.com>
	<20081018223214.GA5093@elte.hu>
	<1224389697.4384.118.camel@koto.keithp.com>
	<1224398496.5303.7.camel@koto.keithp.com>
	<20081019175320.GA6442@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2008 19:53:20 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> struct resource {
>         resource_size_t start;
>         resource_size_t end;
>         const char *name;
>         unsigned long flags;
>         struct resource *parent, *sibling, *child;
> +       void *mapping;
> };
> 
> The APIs would be:
> 
>   int   io_resource_init_mapping(struct resource *res);
>  void   io_resource_free_mapping(struct resource *res);
>  void * io_resource_map(struct resource *res, pfn_t pfn, unsigned
> long offset); void   io_resource_unmap(struct resource *res, void
> *kaddr);
> 
> Note how simple and consistent it all gets: IO resources already know 
> their physical location and their size limits. Being able to cache an 
> ioremap in a mapping [and being able to use atomic kmaps on 32-bit]
> is a relatively simple and natural extension to the concept.

and making a simple wrapper around this that turns "struct pci_dev,
barnr" into a resource would make sense too, but yes.

We need one more

io_resource_force_cachability(struct resource, cachetype)

or maybe only

io_resource_force_writecombine(struct resource)




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
