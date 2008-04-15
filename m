Return-Path: <linux-kernel-owner+w=401wt.eu-S1762527AbYDOMyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762527AbYDOMyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 08:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYDOMyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 08:54:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:47176 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbYDOMym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:54:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=lyamh5CtFVDcnzI3F5GaRe3+eU2WneHi3xxjk6TXeeT16PTBllgCN53FVAaeKEIyNWwnvPG2R4fyLOAiSZMqyVc/KSDlODmPFMh5KK5s78m0V/BnAgZLwCdQPfldtcBr6SjtBIaSSDfQn/G75Gl9oKllfcTiFNbxCImVzdL9XdM=
Date: Tue, 15 Apr 2008 16:50:09 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080415125009.GA5573@martell.zuzino.mipt.ru>
References: <20080415115058.GA6788@in.ibm.com> <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins> <20080415123233.GA19797@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415123233.GA19797@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 08:32:34AM -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > On Tue, 2008-04-15 at 17:23 +0530, K. Prasad wrote:
> > 
> > > +	trace_mark(futex_wait_called, "uaddr:%p fshared:%p val:%u "
> > > +			"abs_time:%p bitset:%d",
> > > +			uaddr, fshared, val, abs_time, bitset);
> > 
> > This is some seriuosly ugly looking gunk, why would we want stuff like
> > that scattered across the code?
> > 
> 
> I don't really see how it differs so much from printks, which kernel
> developers are already familiar with.

They aren't in every -E codepath, nor they are at the start
and at the end of every important function (like system call).

Such printks are usually inserted during debugging when you don't care
about ugliness and these patches will eventually make kernel looks like
being permanently debugged one.

