Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbZETHjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbZETHjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbZETHjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:39:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:36459 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZETHi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:38:59 -0400
Subject: Re: [PATCH 0/3] tracepoints: delay argument evaluation
From: Peter Zijlstra <peterz@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, fche@redhat.com
In-Reply-To: <20090520072750.DA9A0FC38D@magilla.sf.frob.com>
References: <cover.1242763826.git.jbaron@redhat.com>
	 <1242803524.26820.530.camel@twins>
	 <20090520072750.DA9A0FC38D@magilla.sf.frob.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 20 May 2009 09:38:47 +0200
Message-Id: <1242805127.26820.532.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 00:27 -0700, Roland McGrath wrote:
> > Why can't 
> > 
> > trace_block_bio_complete(arg..)
> >    if (__trace_block_bio_compete.state)
> >      __trace_block_bio_complete(arg)
> > 
> > work?
> > 
> > Surely its possible to wrap the whole stuff in yet another macro layer
> > that will do the conditional before evaluating the arguments?
> 
> That is exactly what Jason has implemented.  
> He called the new macro layer tracepoint_call.
> 
> You can't use a macro to generate a new macro definition, so it's not
> possible with cpp alone to have the new macro layer be one that defines a
> separate trace_foobar() macro for each defined tracepoint.

Right, just realized that.

But I think we should be asking GCC to get fixed. Since inline functions
don't act like a compiler barrier anyway, they might as well not force
argument evaluation either.
