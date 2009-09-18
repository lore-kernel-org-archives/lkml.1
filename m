Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZIRCVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZIRCVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 22:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZIRCVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 22:21:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56501 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbZIRCVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 22:21:44 -0400
Date: Thu, 17 Sep 2009 22:21:45 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix ppc64 build failure on fedora
Message-ID: <20090918022145.GF11961@bombadil.infradead.org>
References: <20090917174144.GA11961@bombadil.infradead.org> <1253238606.4932.23.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253238606.4932.23.camel@pasglop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 11:50:06AM +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2009-09-17 at 13:41 -0400, Kyle McMartin wrote:
> > From: Kyle McMartin <kyle@redhat.com>
> > 
> > For some reason or another (newer gcc?) on Fedora 12 koji builders we're
> > seeing _restgpr0_$n symbols instead of _restgpr_$n as handled in the
> > prom_init_check.sh file:
> > Checking prom_init.o symbol '_restgpr0_14'
> > Error: External symbol '_restgpr0_14' referenced from prom_init.c
> > Checking prom_init.o symbol '_restgpr0_17'
> > 
> > Add cases to handle this to the filter portion of the script.
> 
> My concern tho is if one of thse is actually called ... we implement
> them in arch/powerpc/lib/crtsaveres.S but with the "other" names..
> 

Sorry, this appears to be a GCC "feature" introduced in gcc4.5 which is
generating out of line save/restore on ppc64 at -Os. Thanks to Jakub's
suggestion I ended up working around this by building ppc with -O2 for
now (CC_OPTIMIZE_FOR_SIZE)

In any case, according to the gcc "docs" for this, these functions are
supposed to be provided by the linker in the ppc64 case, so it wasn't
correct to try and add them.

I believe Alan Modra said he'd look at the ld issue with regards to
this.

cheers, Kyle
