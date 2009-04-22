Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbZDVAmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbZDVAmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 20:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZDVAmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 20:42:05 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15723 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZDVAmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 20:42:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Z6Exd0NvClOtawZIzFLzbgP2y/AbO7nEl5IYISiERYaGhAONUbe7D3aIjifjiXZu2
	/8oNzIHAkM7YuYwi12NMA==
Date: Tue, 21 Apr 2009 17:41:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 21/25] Use allocation flags as an index to the zone
 watermark
In-Reply-To: <20090422092429.6271.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0904211739520.31232@chino.kir.corp.google.com>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-22-git-send-email-mel@csn.ul.ie> <20090422092429.6271.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009, KOSAKI Motohiro wrote:

> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 376d848..e61867e 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1157,10 +1157,13 @@ failed:
> >  	return NULL;
> >  }
> >  
> > -#define ALLOC_NO_WATERMARKS	0x01 /* don't check watermarks at all */
> > -#define ALLOC_WMARK_MIN		0x02 /* use pages_min watermark */
> > -#define ALLOC_WMARK_LOW		0x04 /* use pages_low watermark */
> > -#define ALLOC_WMARK_HIGH	0x08 /* use pages_high watermark */
> > +/* The WMARK bits are used as an index zone->pages_mark */
> > +#define ALLOC_WMARK_MIN		0x00 /* use pages_min watermark */
> > +#define ALLOC_WMARK_LOW		0x01 /* use pages_low watermark */
> > +#define ALLOC_WMARK_HIGH	0x02 /* use pages_high watermark */
> > +#define ALLOC_NO_WATERMARKS	0x08 /* don't check watermarks at all */
> > +#define ALLOC_WMARK_MASK	0x07 /* Mask to get the watermark bits */
> 
> the mask only use two bit. but mask definition is three bit (0x07), why?
> 

I think it would probably be better to simply use

	#define ALLOC_WMARK_MASK	(ALLOC_NO_WATERMARKS - 1)

here and define ALLOC_NO_WATERMARKS to be 0x04.
