Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbXEBJfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbXEBJfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbXEBJfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:35:37 -0400
Received: from ns.suse.de ([195.135.220.2]:38606 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267AbXEBJfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:35:37 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jon Burgess <jburgess777@googlemail.com>
Subject: Re: [PATCH] Re: More than 2Gb problem (dvb related) ?
Date: Wed, 2 May 2007 11:35:32 +0200
User-Agent: KMail/1.9.6
Cc: Gregoire Favre <Gregoire.Favre@gmail.com>, linux-dvb@linuxtv.org,
       v4l-dvb-maintainer@linuxtv.org,
       Markus Rechberger <mrechberger@gmail.com>, linux-kernel@vger.kernel.org,
       Lee Revell <rlrevell@joe-job.com>
References: <20070427111047.GB10284@gmail.com> <20070501094153.GC6895@gmail.com> <1178057515.25218.24.camel@localhost.localdomain>
In-Reply-To: <1178057515.25218.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021135.32835.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Looks like you hit:
> 	BUG_ON(flags & ~(GFP_DMA | GFP_LEVEL_MASK | __GFP_NO_GROW));
> 
> I guess this was due to the vmalloc_32() change now passing in
> GFP_DMA32. Looks like that could be a problem with the
> x86_64-mm-vmalloc-32 patch. Andi?

Does this patch help?

Index: linux/mm/vmalloc.c
===================================================================
--- linux.orig/mm/vmalloc.c
+++ linux/mm/vmalloc.c
@@ -431,7 +431,7 @@ void *__vmalloc_area_node(struct vm_stru
 		area->flags |= VM_VPAGES;
 	} else {
 		pages = kmalloc_node(array_size,
-				(gfp_mask & ~(__GFP_HIGHMEM | __GFP_ZERO)),
+				(gfp_mask & GFP_LEVEL_MASK),
 				node);
 	}
 	area->pages = pages;


-Andi
