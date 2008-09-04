Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYIDHoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYIDHoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 03:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYIDHnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 03:43:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:54335 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbYIDHnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 03:43:51 -0400
Subject: Re: [PATCH 2/2] powerpc - Make the irq reverse mapping radix tree
	lockless
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: dwalker@mvista.com, tinytim@us.ibm.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       jean-pierre.dion@bull.net, michael@ellerman.id.au,
       linuxppc-dev@ozlabs.org, paulus@samba.org, gilles.carry@ext.bull.net,
       tglx@linutronix.de
In-Reply-To: <20080904092252.12b3df4a@bull.net>
References: <1218029429-21114-1-git-send-email-sebastien.dugue@bull.net>
	 <1218029429-21114-3-git-send-email-sebastien.dugue@bull.net>
	 <1219209781.21386.25.camel@pasglop> <20080903154105.7dff49db@bull.net>
	 <1220496739.4879.20.camel@pasglop>  <20080904092252.12b3df4a@bull.net>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 17:34:03 +1000
Message-Id: <1220513643.4879.68.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > >   I could not think of anything simple so far and I'm open for suggestions.
> > 
> > GFP_KERNEL should not fail, it will just block no ?
> 
>   No it won't block and will fail (returns NULL).

hrm... it used to never fail.. that may have changed. But it will
definitely block and try very hard to push things out to make space,
which is the whole point :-)

>   I will have to add that back as there is no more fallback.

Well, the must be one in the case the tree isn't initialized yet, so if
there's an allocation failure, you may "de-initialize" it or
something... Or you can fallback if you don't find, as easy, probably
easier since it shouldn't happen in practice.

> > I don't know if it's worth trying to fire off a new
> > allocation attempt later, probably not.
> 
>   I've been pondering with this lately, but I think that adding a linear
> lookup fallback should be OK.

Yup.

Cheers,
Ben.


