Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbYG3XAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbYG3XAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYG3XAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:00:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:60693 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbYG3XAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:00:40 -0400
Subject: Re: [PATCH] powerpc/ibmveth: fix multiple errors with
	dma_mapping_error conversion
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Paul Mackerras <paulus@samba.org>,
       ppc-dev <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4890DA8E.5000502@garzik.org>
References: <20080728021424.40cf66bc.sfr@canb.auug.org.au>
	 <4890DA8E.5000502@garzik.org>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 08:59:16 +1000
Message-Id: <1217458756.11188.357.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-30 at 17:18 -0400, Jeff Garzik wrote:
> Stephen Rothwell wrote:
> > The addition of an argument to dma_mapping_error() in commit
> > 8d8bb39b9eba32dd70e87fd5ad5c5dd4ba118e06 "dma-mapping: add the device
> > argument to dma_mapping_error()" left a bit of fallout:
> > 
> > drivers/net/ibmveth.c:263: error: too few arguments to function 'dma_mapping_error'
> > drivers/net/ibmveth.c:264: error: expected ')' before 'goto'
> > drivers/net/ibmveth.c:284: error: expected expression before '}' token
> > drivers/net/ibmveth.c:297: error: too few arguments to function 'dma_mapping_error'
> > drivers/net/ibmveth.c:298: error: expected ')' before 'dma_unmap_single'
> > drivers/net/ibmveth.c:306: error: expected expression before '}' token
> > drivers/net/ibmveth.c:491: error: too few arguments to function 'dma_mapping_error'
> > drivers/net/ibmveth.c:927: error: too few arguments to function 'dma_mapping_error'
> > drivers/net/ibmveth.c:927: error: expected ')' before '{' token
> > drivers/net/ibmveth.c:974: error: expected expression before '}' token
> > drivers/net/ibmveth.c:914: error: label 'out' used but not defined m
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  drivers/net/ibmveth.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > Compiler tested for ppc64_defconfig.
> 
> applied
> 

I think I merged that one up already... it was a trivial compile fix
for a fallover of an API change in a powerpc specific driver so I
didn't wait for an ack.

Ben.


