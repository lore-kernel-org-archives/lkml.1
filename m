Return-Path: <linux-kernel-owner+w=401wt.eu-S2992557AbXEBAgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992557AbXEBAgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992562AbXEBAgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:36:35 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20877 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992550AbXEBAgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:36:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:reply-to:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=FBiMklvioAENTxcUpxmDN8wVYdKMyROgolXmpujLcApY/qm6eBNBiQ6vrymj0kpvo
	BVZxMt8VXZKtSU1cTipug==
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
From: Rohit Seth <rohitseth@google.com>
Reply-To: rohitseth@google.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "'Hugh Dickins'" <hugh@veritas.com>,
       "'Mike Stroyan'" <mike.stroyan@hp.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Luck, Tony'" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46372A12.9080802@yahoo.com.au>
References: <200704281817.l3SIHu0P001764@smtp.corp.google.com>
	 <46372A12.9080802@yahoo.com.au>
Content-Type: text/plain
Organization: Google Inc
Date: Tue, 01 May 2007 17:36:20 -0700
Message-Id: <1178066180.19466.68.camel@galaxy.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 21:52 +1000, Nick Piggin wrote:
> Rohit Seth wrote:
> 
> >>and 
> >>it's only interested when it's executable i.e. "lazy_mmu_prot_update"
> >>is a name concealing some overdesign.
> > 
> > 
> > You are right that ia64 is only interested in whne the execute permissions
> > kick in (and FWIW ia64 used to use update_mmu_cache API to do what it is now
> > doing lazy_mmu_prot_update).  Though the idea was to design an API that any
> > arch can use to know when ever there is change in protections on a mapping.
> 
> What I think what we should do is audit flush_icache_page coverage, and
> convert ia64 to use that (because it needs this to happen _before_ the
> pte is set).
> 

That doesn't address the underlying requirement that arch specific code
should be told of change in protections.  For ia64, you are right that
it equates to flushing icache in some cases, but this API is more
generic.

> All we should need to do is add a pte argument to flush_icache,

I'm sure this is doable.  Though it is more of design issue of whether
that is the right way to do it.  I understand this extra API is
difficult at this time because of one single consumer.

-rohit


