Return-Path: <linux-kernel-owner+w=401wt.eu-S2992561AbXEBAhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992561AbXEBAhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992572AbXEBAhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:37:00 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20948 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992561AbXEBAgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:36:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:reply-to:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=Z69OvwQiLGDCYO0Q9oIcsrtuvLc+Qs93TfGLlLnx2b/q9IXYhyuWPbgaDnBM57p6x
	q+pX/sTy8Tj7yfUwZrT0w==
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
From: Rohit Seth <rohitseth@google.com>
Reply-To: rohitseth@google.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "'Hugh Dickins'" <hugh@veritas.com>,
       "'Mike Stroyan'" <mike.stroyan@hp.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Luck, Tony'" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <463728EB.8030308@yahoo.com.au>
References: <200704281830.l3SIUqOo004230@smtp.corp.google.com>
	 <463728EB.8030308@yahoo.com.au>
Content-Type: text/plain
Organization: Google Inc
Date: Tue, 01 May 2007 17:36:27 -0700
Message-Id: <1178066187.19466.69.camel@galaxy.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 21:47 +1000, Nick Piggin wrote:
> Rohit Seth wrote:
> >
> > 
> > It is invalidating any entries (containing same physical address) in both I
> > and D caches.  Any dirty lines in D cache are written back to memory before
> > getting invalidated (ofcourse).
> 
> OK. (should it be issuing both fc and fc.i to be robust in case a
> new implementation doesn't flush the dcache with fc.i?)
> 

For the Itanium case specifically, you only want to invalidate a stale
icache line.  Once that is done, next time icache will pick the correct
updated contents.

> 
> >>There are supposedly no icache lines at that point[**]:
> > 
> > 
> > For this bug to trigger there has to be a (stale) entry in icache containing
> > the old contents of a page that just got updated by kernel as explicit
> > copying of data (DMAs are coherent on ia64, meaning if a device were to
> > write to memory then architecture guarnatees that both I and D caches are
> > invalidated).
> 
> So if we have a dirty dcache line for a given physical address,
> it will _always_ be the case that a subsequent icache load will
> find that dirty data?

yes for ia64.

-rohit

