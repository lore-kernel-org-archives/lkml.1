Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbXKTDbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbXKTDbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 22:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbXKTDa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 22:30:57 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43278 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752701AbXKTDa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 22:30:56 -0500
Date: Mon, 19 Nov 2007 19:30:55 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 03/45] Generic CPU operations: Core piece
In-Reply-To: <20071120031751.GA21743@Krystal>
Message-ID: <Pine.LNX.4.64.0711191927510.21689@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071120011332.415903723@sgi.com>
 <20071120031751.GA21743@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007, Mathieu Desnoyers wrote:

> 
> Very interesting patch! I did not expect we could mix local atomic ops
> with per CPU offsets in an atomic manner.. brilliant :)
> 
> Some nitpicking follows...

Well this is a draft so I was not that thorough. The beast is getting too 
big. It would be good if I could get the first patches merged that just 
deal with the two allocators and then gradually work the rest.

> I think you could use extra () around old, new etc.. ?

Right.

> Same here.
> 
> > +	(x);					\
> 
> () seems unneeded here, since x is local.

But (x) is returned to the "caller" of the macro so it should be specially 
marged.

> > + * In that case we can simply disable preemption which
> > + * may be free if the kernel is compiled without preemption.
> > + */
> > +
> > +#define _CPU_READ(addr)				\
> > +({						\
> > +	(__CPU_READ(addr));			\
> > +})
> 
> ({ }) seems to be unneeded here.

Hmmm.... I wanted a consistent style.

