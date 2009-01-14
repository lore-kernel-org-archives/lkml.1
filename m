Return-Path: <linux-kernel-owner+w=401wt.eu-S1763657AbZANP72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763657AbZANP72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761336AbZANP7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:59:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60102 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760869AbZANP7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:59:05 -0500
Date: Wed, 14 Jan 2009 10:58:59 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Kyle McMartin <kyle@infradead.org>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: kzalloc mod->ref
Message-ID: <20090114155859.GO25103@bombadil.infradead.org>
References: <20090114033533.GL25103@bombadil.infradead.org> <s5hmydufe3c.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hmydufe3c.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 10:09:59AM +0100, Takashi Iwai wrote:
> At Tue, 13 Jan 2009 22:35:33 -0500,
> Kyle McMartin wrote:
> > 
> > From: Kyle McMartin <kyle@redhat.com>
> > 
> > Dynamically allocate mod->ref instead of fixing it in the struct module.
> > Reduces on disk space wasted in the module .ko, and kills a loop
> > initializing the local_t it contains since we can just kzalloc it.
> > 
> > This matters when we're talking about large NR_CPUS.
> > 
> > Signed-off-by: Kyle McMartin <kyle@redhat.com>
> > ---
> > The patch removing cacheline_aligned from struct module_ref should be
> > applied as well to cut down on the amount of memory we allocate. This
> > patch makes a nice stopgap until we have per_cpu module references.
> > 
> > cheers, Kyle
> 
> Similar patches (including mine) have been already posted, but no
> proceed until now...
> 	http://lkml.org/lkml/2008/11/11/315

Ah, sigh.

It would be nice to get this sorted out, since we're serious wasting
disk space for no good reason...

Although as Richard points out, dropping the cacheline_aligned might
drop networking performance (which, sigh, is also stupid) but allocating
128b * NR_CPUS is just a ridiculous amount of memory to waste for a
reference count...

