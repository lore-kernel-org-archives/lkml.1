Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbYAPP0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbYAPP0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 10:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYAPP0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 10:26:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:49312 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbYAPP0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 10:26:06 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] x86: some more patches
Date: Wed, 16 Jan 2008 16:26:01 +0100
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
References: <patchbomb.1200435425@localhost> <200801161544.15884.ak@suse.de> <20080116145427.GA640@elte.hu>
In-Reply-To: <20080116145427.GA640@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801161626.01711.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 January 2008 15:54:27 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > >  #define PHYSICAL_PAGE_MASK	(PAGE_MASK & __PHYSICAL_MASK)
> > 
> > 
> > I haven't tested yet, but we looked at that one earlier and I thought 
> > it was ok because
> > 
> > #define __PHYSICAL_MASK          _AT(phys_addr_t, (_AC(1,ULL) << __PHYSICAL_MASK_SHIFT) - 1)
> > 
> > and 
> > 
> > typedef u64     phys_addr_t;
> > 
> > for PAE. So the expression above should have been already 64bit.
> 
> no. The problem is that PAGE_MASK is:

I covered that in the end of the email.
> 
> 
> (PHYSICAL_PAGE_MASK is broken too in the same way, i just fixed that in 
> my tree - but it's not used by anything on 32-bit PAE but by PAGE_MASK)

Yes, but if you cast to long the result will be 32bit again. Or do you
rely on it being always used in 64bit signed context with sign extension?
While that might work it would seem rather fragile to me, just asking
for similar future bugs.

-Andi

