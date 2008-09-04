Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbYIDDpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbYIDDpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 23:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbYIDDpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 23:45:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:45389 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbYIDDpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 23:45:39 -0400
Subject: Re: [PATCH 2/2] powerpc - Make the irq reverse mapping radix tree
	lockless
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, paulus@samba.org,
       michael@ellerman.id.au, jean-pierre.dion@bull.net,
       gilles.carry@ext.bull.net, tinytim@us.ibm.com, tglx@linutronix.de,
       rostedt@goodmis.org, dwalker@mvista.com
In-Reply-To: <20080903154105.7dff49db@bull.net>
References: <1218029429-21114-1-git-send-email-sebastien.dugue@bull.net>
	 <1218029429-21114-3-git-send-email-sebastien.dugue@bull.net>
	 <1219209781.21386.25.camel@pasglop>  <20080903154105.7dff49db@bull.net>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 12:52:19 +1000
Message-Id: <1220496739.4879.20.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-03 at 15:41 +0200, Sebastien Dugue wrote:
> On Wed, 20 Aug 2008 15:23:01 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > BTW. It would be good to try to turn the GFP_ATOMIC into GFP_KERNEL,
> 
>   That would be nice indeed
> 
> > maybe using a semaphore instead of a lock to protect insertion vs.
> > initialisation.
> 
>   a semaphore? are you meaning a mutex? If not, I fail to understand what you're
> implying.

Right, a mutex, bad habit calling those semaphores from the old days :-)

>   Right, that's the problem with this new scheme and I'm still trying
> to find a way to handle memory allocation failures be it for GFP_ATOMIC or
> GFP_KERNEL.
> 
>   I could not think of anything simple so far and I'm open for suggestions.

GFP_KERNEL should not fail, it will just block no ? If it fails, it's
probably catastrophic enough not to care. You can always fallback to
linear lookup. I don't know if it's worth trying to fire off a new
allocation attempt later, probably not.

Ben.


