Return-Path: <linux-kernel-owner+w=401wt.eu-S1759814AbYCZNK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814AbYCZNK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 09:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbYCZNKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 09:10:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216AbYCZNKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 09:10:10 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: fw-ohci: plug dma memory leak in AR handler
Date: Wed, 26 Mar 2008 09:09:49 -0400
User-Agent: KMail/1.9.9
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200803251647.16227.jwilson@redhat.com> <47E9F6BB.4010601@s5r6.in-berlin.de>
In-Reply-To: <47E9F6BB.4010601@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803260909.49850.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 March 2008 03:09:47 am Stefan Richter wrote:
> Jarod Wilson wrote:
> > @@ -605,7 +606,7 @@ static void ar_context_tasklet(unsigned long data)
> >  			buffer = handle_ar_packet(ctx, buffer);
> >
> >  		dma_free_coherent(ohci->card.device, PAGE_SIZE,
> > -				  buffer, buffer_bus);
> > +				  start, start_bus);
> >  		ar_context_add_page(ctx);
>
> On the other hand, why do we free a page + allocate a page?
> Why don't we re-initialize and re-add the old page?

Oh good, I'm not crazy (outside of having firewire on the brain way too much 
right now). I had that same thought tossing and turning in bed late last 
night. :)

-- 
Jarod Wilson
jwilson@redhat.com
