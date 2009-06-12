Return-Path: <linux-kernel-owner+w=401wt.eu-S934378AbZFLNun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934378AbZFLNun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765234AbZFLNpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:45:08 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37294 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764176AbZFLNpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:45:06 -0400
Subject: Re: [GIT PULL] Early SLAB fixes for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       npiggin@suse.de, yinghai@kernel.org
In-Reply-To: <1244813895.7172.157.camel@pasglop>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <1244813895.7172.157.camel@pasglop>
Date: Fri, 12 Jun 2009 16:45:06 +0300
Message-Id: <1244814306.30512.65.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Fri, 2009-06-12 at 16:25 +0300, Pekka J Enberg wrote:
> > +	/* Lets avoid crashing in early boot code. */
> > +	if (WARN_ON_ONCE((local_flags & ~slab_gfp_mask) != 0))
> > +		local_flags &= slab_gfp_mask;
> > +

On Fri, 2009-06-12 at 23:38 +1000, Benjamin Herrenschmidt wrote:
> I still object to the WARN_ON, see all the previous discussions on that
> subject...

Yes, I know that!

I am not proposing this as the final fix to powerpc problems. But if we
were to do the masking you suggested, this is not the proper way to do
it at all. We need to mask the flags much earlier than this which is why
I am keeping the WARN_ON() there.

The patch is a stop-gap measure until we've reached an agreement how to
fix things properly. And I do think my patch is the right thing to do
here while we wait for Linus' opinion on this.

			Pekka

