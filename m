Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbYHEK5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbYHEK5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 06:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbYHEKut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 06:50:49 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:33463 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbYHEKur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 06:50:47 -0400
Date: Tue, 5 Aug 2008 10:27:49 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: benh@kernel.crashing.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, paulus@samba.org,
       michael@ellerman.id.au, jean-pierre.dion@bull.net,
       gilles.carry@ext.bull.net, tinytim@us.ibm.com, tglx@linutronix.de,
       rostedt@goodmis.org
Subject: Re: [PATCH 1/3] powerpc - Initialize the irq radix tree earlier
Message-ID: <20080805102749.6ae24947@bull.net>
In-Reply-To: <1217898303.24157.122.camel@pasglop>
References: <1217848124-3719-1-git-send-email-sebastien.dugue@bull.net>
	<1217848124-3719-2-git-send-email-sebastien.dugue@bull.net>
	<1217898226.24157.120.camel@pasglop>
	<1217898303.24157.122.camel@pasglop>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Aug 2008 11:05:03 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> >  - Remove the populating of the tree from the revmap function as
> >    you already do
> >  - Move it to irq_create_mapping() for the normal case
> >  - For pre-existing interrupt, have the generic code that initializes
> >    the radix tree walk through all interrupts and setup the revmap for
> >    them. If that needs locking vs. concurrent irq_create_mapping, it's
> >    easy to use one of the available spinlocks for that.
> 
> And in fact, you may even be able to avoid GFP_ATOMIC completely here
> and switch it to GFP_KERNEL since irq_create_mapping() can sleep afaik,
> provided that you avoid the spinlocking.

  Well, maybe, will have to look into this in details.

  Thanks,

  Sebastien.

> 
> Ben.
> 
> 
> 
