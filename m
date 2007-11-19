Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbXKSUJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbXKSUJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 15:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbXKSUJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 15:09:50 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56941 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbXKSUJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 15:09:49 -0500
Subject: Re: [PATCH] Cast __page_to_pfn to unsigned long in CONFIG_SPARSEMEM
From: Dave Hansen <haveblue@us.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mbligh@google.com
In-Reply-To: <20071119195257.GA3440@Krystal>
References: <20071113193349.214098508@polymtl.ca>
	 <20071113194025.150641834@polymtl.ca> <1195160783.7078.203.camel@localhost>
	 <20071115215142.GA7825@Krystal> <1195164977.27759.10.camel@localhost>
	 <20071116144742.GA17255@Krystal> <1195495626.27759.119.camel@localhost>
	 <20071119185258.GA998@Krystal> <1195501381.27759.127.camel@localhost>
	 <20071119195257.GA3440@Krystal>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 12:09:43 -0800
Message-Id: <1195502983.27759.134.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-19 at 14:52 -0500, Mathieu Desnoyers wrote:
> * Dave Hansen (haveblue@us.ibm.com) wrote:
> > On Mon, 2007-11-19 at 13:52 -0500, Mathieu Desnoyers wrote:
> > > > > So I guess the result is a pointer ? Should this be expected ?
> > > > 
> > > > Nope.  'pointer - pointer' is an integer.  Just solve this equation for
> > > > integer:
> > > > 
> > > >       'pointer + integer = pointer'
> > > > 
> > > 
> > > Well, using page_to_pfn turns out to be ugly in markers (and in
> > > printks) then. Depending on the architecture, it will result in either
> > > an unsigned long (x86_64) or an unsigned int (i386), which corresponds
> > > to %lu or %u and will print a warning if we don't cast it explicitly. 
> > 
> > Casting the i386 one to be an unconditional 'unsigned long' shouldn't be
> > an issue.  We don't generally expect pfns to fit into ints anyway. 
> 
> So would this make sense ?
> 
> Cast __page_to_pfn to unsigned long in CONFIG_SPARSEMEM
> 
> Make sure the type returned by __page_to_pfn is always unsigned long. If we
> don't cast it explicitly, it can be int on i386, but long on x86_64. This is
> especially inelegant for printks.

The only thing I might suggest doing differently is actually using the
page_to_pfn() definition itself:

memory_model.h:#define page_to_pfn __page_to_pfn

The full inline function version should do this already, and we
shouldn't have any real direct __page_to_pfn() users anyway.    

-- Dave

